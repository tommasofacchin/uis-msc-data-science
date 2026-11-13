# How to run the tests

Run all commands from the repository root (`Group-5`).

## 1. C# unit tests (local, no server needed)

```bash
dotnet test 7project/tests/Api.Tests
```

## 2. Smoke test (against the deployed system)

Requires bash. On Windows use Git Bash, not the WSL `bash`.

```bash
bash 7project/tests/smoke.sh
bash 7project/tests/smoke.sh https://api.kamen.no   # explicit URL
```

From PowerShell:

```powershell
& "C:\Program Files\Git\bin\bash.exe" 7project/tests/smoke.sh
```

## 3. Go tests (against the deployed system)

If `API_URL` is not set, the tests are skipped.

```bash
API_URL=https://api.kamen.no go test -v ./7project/tests/
```

From PowerShell:

```powershell
$env:API_URL = "https://api.kamen.no"
go test -v ./7project/tests/
```

## Note

The smoke test and the Go tests create throwaway users in the production
database (`smoke1-…@example.com`, `go1-…@example.com`). They are not deleted.
