# Project Report: Project Automatic

## 1. Project and Submission

- **Repository:** [https://github.com/dat515-2026/Group-5/tree/main/7project]
- **Deployed application or endpoint:** [api.kamen.no]
- **Mentor:** [Hein]
- **Group members:** [Audun Steinkopf, 277945, Mancorl, Tommaso Facchin, 313152, tommasofacchin]
- **Report completed:** [2026-11-08]

In two or three sentences, state what the system does, who it is for, and what
the group delivered.

### Delivered Scope

Report outcomes, not planned activity. Link each claim to the strongest available
evidence, such as a test, source file, deployment manifest, workflow run, or
video timestamp.

| Core goal from `design.md` | Result (met, partial, or not met) | Evidence | Brief explanation |
| -------------------------- | --------------------------------- | -------- | ----------------- |
| Setup of Cloud server | met | api.kamen.no | Setup our own cloud server running on a raspberry pi and kubernetes |
| Create C# application | met | 8fa2d11b18266614b80739f9a90fd71b1d5b4d0b | Gui Application which handles the Gui part of the application |
| Make the C# application run through Docker | met | 0e550ad9f0ae2b5e16dec7d764ce0dddd7b54319 | Application runs using a Docker image|
| Make docker run through kubernetes | met | 0e550ad9f0ae2b5e16dec7d764ce0dddd7b54319 | Allow kubernetes to handle several sepparate instances of the application, and load balancing the application |


### Changes from the Approved Design

| Garage | 0e550ad9f0ae2b5e16dec7d764ce0dddd7b54319 | Application now has an S3-compatible storage automatically backing up uploaded data |
| Google Oauth | 0646948f213ae37bb6fb1168b6c11cbc828ab192 | Uses google login to provide a cookie, eliminates need for local login, accounts are currently whitelist only |

## 2. Reproduce and Verify

Instructions must work from a clean checkout. Prefer scripts, a `Justfile`,
or a `Makefile` over repeated manual steps. State which commands are local
and which create billable cloud resources.

### Prerequisites

List only software or accounts the evaluator must obtain separately.

| Requirement | Tested version | Purpose |
| ----------- | -------------- | ------- |
| .NET | 10.0 | Required to run the application itself |
| Postgresql | 17| Required to interface with database when creating your own instance of the application |
| WinUi3(windows)/MacCatalyst(mac) | net10.0 | Required to build the GUI application for your specific pc |
| Minikube | 1.39.0 | Runs kubernetes |
| nginx | 1.26.3 | Optional, but used in our project for reverse proxy, can be skipped if you are not planning on a public deployment using google oauth |
| Certbot | 4.0.0 | Creates TLS certificates |


### Configuration

Document required variables and configuration without exposing secrets. Commit
a safe example file when useful.

All files can be found in the Enviroment folder

| Variable or file | Required? | Purpose and example value | Secret? |
| ---------------- | --------- | ------------------------- | ------- |
| API | No | Reverse Proxxy and TLS termination not needed for local testing | No |
| filapi.yaml | yes |  Kubernetes deployments | No |
| Dockerfile | yes | runs the main dll using docker | No |
| k8s.env | yes | Application settings | yes |
| garage.toml | yes | Garage node configuration | yes |
| Garage.service | yes | Systemd unit that starts garage on boot | No |

### Build

```bash

##Api
TAG=$(git rev-parse --short e141ba3)
dotnet publish 7project/Api -c Release -o ./publish
docker build -t fileapi:$TAG -f 7project/Enviroment/Dockerfile ./publish

##Gui App
cd 7project/UserApp
dotnet clean
dotnet build ##When prompted choose appropriate version for your operating system


````

```
### Tests

Unit tests (xUnit, in-memory database):

```bash
dotnet test tests/Api.Tests
```

Smoke test against the deployed API:

```bash
bash tests/smoke.sh https://api.kamen.no
```

The unit tests also run in GitHub Actions on every push that touches `Api/` (workflow `unit-tests.yml`). The smoke test runs weekly (workflow `smoke-test.yml`).


### Deploy

```bash
set -e

TAG=$(git rev-parse --short e141ba3)
ENV_DIR=7project/Enviroment
ENV_FILE=$HOME/k8s.env

minikube status >/dev/null 2>&1 || minikube start --driver=docker --memory=2200mb --cpus=2

if [ ! -f "$ENV_FILE" ]; then
  cp "$ENV_DIR/k8s.env" "$ENV_FILE"
  echo "Created $ENV_FILE from the template. Fill in the values, then run this again."
  exit 1
fi
if grep -q "CHANGE_ME" "$ENV_FILE"; then
  echo "$ENV_FILE still contains CHANGE_ME placeholders. Fill them in, then run this again."
  exit 1
fi

# 2. Make the image available to the cluster (minikube has no registry)
minikube image load "fileapi:$TAG"

# 3. Secret from the env file
kubectl delete secret fileapi-env --ignore-not-found
kubectl create secret generic fileapi-env --from-env-file="$ENV_FILE"

# 4. Apply the manifest with this build's image tag, then wait for the rollout
sed "s|image: .*|image: fileapi:$TAG|" "$ENV_DIR/fileapi.yaml" | kubectl apply -f -
kubectl rollout status deployment/fileapi --timeout=120s
```

State any one-time setup, expected completion time, and where the deployment can
be observed. If a local deployment is useful for development, document it after
the required target deployment rather than duplicating common steps.

### Verify and Use

```bash
kubectl get pods -o wide

curl -i http://$(minikube ip):30080/
curl -i https://api.kamen.no/
```

Expects a return code 200, and prints "Hello world"

### Stop or Remove Resources

```bash
minikube stop #Command to stop the application
```

## 3. Evaluation Evidence

### Testing

Unit tests (`dotnet test tests/Api.Tests`) cover JWT generation and user registration (invalid input, duplicate email, password stored hashed). They run in GitHub Actions on every push that touches the API. The smoke test checks the deployed API end to end: user creation, upload, download and delete.
Not covered: the file endpoints and login in the unit tests, the app UI, Google sign-in (the app depends on a whitelist of test users), load balancing, and recovery when a pod goes down.



### Operations and Security

Describe only measures relevant to this system and support them with evidence.
Examples include health checks, logs, metrics, resource limits, recovery,
authentication, authorization, secret handling, and TLS.

| Concern | Implemented measure | Evidence or verification |
| ------- | ------------------- | ------------------------ |
| Pod goes down/ application fails | smoke alarm automated test | 133db40403df198613ab2a5418082b43c5d65e68 |
| Server gets hacked, and leaks userdata | Passwordhashing, checked by a unit test | 7a3c1c722556378dc9d8b7b09a22b54147e366ae, 07bf417eba0a5058b7ea1b554ba231ca8e5369c9 |




### Known Limitations and Troubleshooting

List important known limitations and problems an evaluator may realistically
encounter. Give a concise symptom, diagnosis command, and remedy for each. Omit
this section if there are none.

## 4. Accountability

The required self-assessment is in `contributions.md`, and the required time
records are in `hours.csv`. Do not duplicate those records here.
