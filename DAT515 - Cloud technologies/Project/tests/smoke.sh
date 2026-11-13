#!/usr/bin/env bash
# Smoke test for the deployed API.
# Usage: bash smoke.sh [base-url]      (default: https://api.kamen.no)
# It creates two throwaway users and one file, and deletes the file at the end.

BASE="${1:-https://api.kamen.no}"
STAMP=$(date +%s)
EMAIL1="smoke1-$STAMP@example.com"
EMAIL2="smoke2-$STAMP@example.com"
PASSWORD="Password123!"
FAILS=0
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

check() { # name, expected, actual
  if [ "$2" = "$3" ]; then
    echo "PASS  $1"
  else
    echo "FAIL  $1 (expected $2, got $3)"
    FAILS=$((FAILS + 1))
  fi
}

# Runs curl, saves the response body in $TMP/body and prints the HTTP status code.
status() { curl -s -o "$TMP/body" -w "%{http_code}" "$@"; }

json_field() { sed -n "s/.*\"$1\":\"\([^\"]*\)\".*/\1/p" "$TMP/body"; }

JSON="Content-Type: application/json"

echo "Testing $BASE"

# 1. Files are not available without a token
check "GET /files without token is rejected" 401 "$(status "$BASE/files")"

# 2. Registration
check "register user 1" 200 "$(status -X POST "$BASE/register" -H "$JSON" -d "{\"email\":\"$EMAIL1\",\"password\":\"$PASSWORD\"}")"
check "register same email again is rejected" 409 "$(status -X POST "$BASE/register" -H "$JSON" -d "{\"email\":\"$EMAIL1\",\"password\":\"$PASSWORD\"}")"
check "register with invalid email is rejected" 400 "$(status -X POST "$BASE/register" -H "$JSON" -d "{\"email\":\"not-an-email\",\"password\":\"$PASSWORD\"}")"

# 3. Login
check "login with wrong password is rejected" 401 "$(status -X POST "$BASE/login" -H "$JSON" -d "{\"email\":\"$EMAIL1\",\"password\":\"wrong\"}")"
check "login with unknown email is rejected" 401 "$(status -X POST "$BASE/login" -H "$JSON" -d "{\"email\":\"nobody-$STAMP@example.com\",\"password\":\"$PASSWORD\"}")"
check "login with correct password" 200 "$(status -X POST "$BASE/login" -H "$JSON" -d "{\"email\":\"$EMAIL1\",\"password\":\"$PASSWORD\"}")"
TOKEN1=$(json_field token)
[ -n "$TOKEN1" ] || { echo "FAIL  no token returned by login, cannot continue"; exit 1; }
AUTH1="Authorization: Bearer $TOKEN1"

# 4. Upload, list, download
echo "smoke test $STAMP" > "$TMP/hello.txt"
check "upload a file" 200 "$(status -X POST "$BASE/files" -H "$AUTH1" -F "file=@$TMP/hello.txt")"
KEY=$(json_field objectName)
[ -n "$KEY" ] || { echo "FAIL  no object key returned by upload, cannot continue"; exit 1; }

check "list shows the uploaded file" 200 "$(status "$BASE/files" -H "$AUTH1")"
if grep -q "hello.txt" "$TMP/body"; then echo "PASS  uploaded file is in the list"; else echo "FAIL  uploaded file is not in the list"; FAILS=$((FAILS + 1)); fi

check "download the file" 200 "$(status "$BASE/files/download?key=$KEY" -H "$AUTH1")"
if cmp -s "$TMP/body" "$TMP/hello.txt"; then echo "PASS  downloaded content matches"; else echo "FAIL  downloaded content differs"; FAILS=$((FAILS + 1)); fi

# 5. Ownership: a second user cannot see or download the file of the first user
check "register user 2" 200 "$(status -X POST "$BASE/register" -H "$JSON" -d "{\"email\":\"$EMAIL2\",\"password\":\"$PASSWORD\"}")"
TOKEN2=$(json_field token)
AUTH2="Authorization: Bearer $TOKEN2"

check "user 2 list request" 200 "$(status "$BASE/files" -H "$AUTH2")"
if grep -q "hello.txt" "$TMP/body"; then echo "FAIL  user 2 can see the file of user 1"; FAILS=$((FAILS + 1)); else echo "PASS  user 2 does not see the file of user 1"; fi
check "user 2 cannot download the file of user 1" 404 "$(status "$BASE/files/download?key=$KEY" -H "$AUTH2")"
check "user 2 cannot delete the file of user 1" 404 "$(status -X DELETE "$BASE/files?key=$KEY" -H "$AUTH2")"

# 6. Delete
check "delete the file as owner" 204 "$(status -X DELETE "$BASE/files?key=$KEY" -H "$AUTH1")"
check "deleted file is gone" 404 "$(status "$BASE/files/download?key=$KEY" -H "$AUTH1")"

echo
if [ "$FAILS" -eq 0 ]; then
  echo "All checks passed."
else
  echo "$FAILS check(s) failed."
  exit 1
fi
