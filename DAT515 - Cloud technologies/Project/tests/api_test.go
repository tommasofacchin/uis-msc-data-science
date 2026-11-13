package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"strings"
	"testing"
	"time"
)

// These tests call the deployed API. They are skipped unless API_URL is set:
//   API_URL=https://api.kamen.no go test ./7project/tests/

func baseURL(t *testing.T) string {
	url := os.Getenv("API_URL")
	if url == "" {
		t.Skip("API_URL not set, skipping tests against the deployed API")
	}
	return strings.TrimRight(url, "/")
}

func do(t *testing.T, method, url, token, contentType string, body []byte) (int, []byte) {
	t.Helper()
	req, err := http.NewRequest(method, url, bytes.NewReader(body))
	if err != nil {
		t.Fatal(err)
	}
	if contentType != "" {
		req.Header.Set("Content-Type", contentType)
	}
	if token != "" {
		req.Header.Set("Authorization", "Bearer "+token)
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(resp.Body)
	return resp.StatusCode, data
}

func postJSON(t *testing.T, url string, v any) (int, []byte) {
	t.Helper()
	b, _ := json.Marshal(v)
	return do(t, "POST", url, "", "application/json", b)
}

func register(t *testing.T, base, email, password string) string {
	t.Helper()
	code, body := postJSON(t, base+"/register", map[string]string{"email": email, "password": password})
	if code != 200 {
		t.Fatalf("register %s: got %d", email, code)
	}
	var r struct{ Token string }
	json.Unmarshal(body, &r)
	if r.Token == "" {
		t.Fatal("register returned no token")
	}
	return r.Token
}

func TestFilesRequireToken(t *testing.T) {
	base := baseURL(t)
	if code, _ := do(t, "GET", base+"/files", "", "", nil); code != 401 {
		t.Errorf("GET /files without token: got %d, want 401", code)
	}
}

func TestRegistrationRules(t *testing.T) {
	base := baseURL(t)
	email := fmt.Sprintf("go-%d@example.com", time.Now().UnixNano())
	register(t, base, email, "Password123!")

	if code, _ := postJSON(t, base+"/register", map[string]string{"email": email, "password": "Password123!"}); code != 409 {
		t.Errorf("duplicate email: got %d, want 409", code)
	}
	if code, _ := postJSON(t, base+"/register", map[string]string{"email": "not-an-email", "password": "Password123!"}); code != 400 {
		t.Errorf("invalid email: got %d, want 400", code)
	}
	if code, _ := postJSON(t, base+"/login", map[string]string{"email": email, "password": "wrong"}); code != 401 {
		t.Errorf("wrong password: got %d, want 401", code)
	}
}

func TestUploadDownloadDeleteAndOwnership(t *testing.T) {
	base := baseURL(t)
	stamp := time.Now().UnixNano()
	token1 := register(t, base, fmt.Sprintf("go1-%d@example.com", stamp), "Password123!")
	token2 := register(t, base, fmt.Sprintf("go2-%d@example.com", stamp), "Password123!")

	// upload
	var buf bytes.Buffer
	w := multipart.NewWriter(&buf)
	part, _ := w.CreateFormFile("file", "hello.txt")
	content := fmt.Sprintf("go test %d", stamp)
	part.Write([]byte(content))
	w.Close()
	code, body := do(t, "POST", base+"/files", token1, w.FormDataContentType(), buf.Bytes())
	if code != 200 {
		t.Fatalf("upload: got %d, want 200", code)
	}
	var up struct{ ObjectName string }
	json.Unmarshal(body, &up)
	if up.ObjectName == "" {
		t.Fatal("upload returned no object name")
	}
	url := base + "/files/download?key=" + up.ObjectName

	// owner can download the same content
	code, body = do(t, "GET", url, token1, "", nil)
	if code != 200 || string(body) != content {
		t.Errorf("download: got %d and %q, want 200 and %q", code, body, content)
	}

	// another user cannot download or delete it
	if code, _ := do(t, "GET", url, token2, "", nil); code != 404 {
		t.Errorf("other user download: got %d, want 404", code)
	}
	if code, _ := do(t, "DELETE", base+"/files?key="+up.ObjectName, token2, "", nil); code != 404 {
		t.Errorf("other user delete: got %d, want 404", code)
	}

	// owner deletes it, and it is gone
	if code, _ := do(t, "DELETE", base+"/files?key="+up.ObjectName, token1, "", nil); code != 204 {
		t.Errorf("delete: got %d, want 204", code)
	}
	if code, _ := do(t, "GET", url, token1, "", nil); code != 404 {
		t.Errorf("download after delete: got %d, want 404", code)
	}
}
