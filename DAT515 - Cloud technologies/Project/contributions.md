# Contributions and Self-Assessment

## Rubric Self-Assessment

Claim only points supported by the submitted revision. Completing this table is
required but does not itself earn points.

| Criterion                                   | Claimed points | Evidence and brief rationale |
| ------------------------------------------- | -------------: | ---------------------------- |
| Core implementation (25)                    | 25 | 0646948f213ae37bb6fb1168b6c11cbc828ab192 completed core functionality of the application |
| Cloud architecture and deployment (25)      | 21 | 0e550ad9f0ae2b5e16dec7d764ce0dddd7b54319 api.kamen.no Deployed on the interenet using garage(S3 compatible object storage), nginx reverse proxxy, using docker and kubernetes and google oauth, deducting because as of now the setup is dependant on the primary raspberry pi|
| Reproducibility and automation (20)         | 15 | 0646948f213ae37bb6fb1168b6c11cbc828ab192 App is mostly automated, and uses kubernetes to restart, for reproducing, you will have to manually fill in conf files and create your own instance of google oauth and ssh connection to provide tokens, deducting points because reproducing on another device is more difficult than it needed to be |
| Verification, operations, and security (20) | 16 | fce3171b0094e575b4b1fb2772f208b6c1b5bc7c 0646948f213ae37bb6fb1168b6c11cbc828ab192 07bf417eba0a5058b7ea1b554ba231ca8e5369c9 Using HTTPS and google oauth + passwordhashing for manual registration, secrets are stored outside the main file as enviroment variables, could improve operations by adding health checks though |
| Engineering judgment and evidence (10)      | 9 | Errors have been traced using logs + ai, and has produced a working and resilient application. Verified with unit tests and a smoke test in smoke.sh, deducting because the unit tests only cover token generation and registration |
| **Total (100)**                             | 86 | Core project more than meets the initial requirements, While deployments has its weaknesses, it is a very secure implementation with automatic restarts, and is available with HTTPS from the internet, in addition to using passwordhashing and data minimization principles to reduce the attack surface of the application. It also has unit tests, working smoke tests and log tracing |

## Contribution Summary

| Delivered outcome | Contributor(s) | Evidence | Status or limitation |
| ----------------- | -------------- | -------- | -------------------- |
| Desktop app: login, register, logout, upload, file list, download, delete | Tommaso | 24036b7, 5ff57ce, 548214f, 885a2a4 | Tested by hand only, no automated UI tests |
| Token handling in the app (saved token, Bearer header, back to login on 401) | Tommaso | 115244f, 885a2a4, 8fa2d11 | |
| Google sign-in button in the app | Tommaso | a07b52c | The Google account must be added as a test user |
| File ownership from the JWT and a metadata table for files | Tommaso | 30c0a82, b4223fc | Metadata is not copied to the Garage backup |
| Smoke test script and workflow for the deployed API | Tommaso | 133db40 | Checks the deployed API only, not the app UI |
| Unit tests for token generation and registration, run in CI | Tommaso | 07bf417 | Cover only the token service and registration, not the file endpoints, login or the UI |



## Individual Self-Assessments

### Audun Steinkopf

- **Git identity:** Mancorl
- **Primary contribution:** In the API: Login, register, database, Google Oath, garage setup, Kubernetes, Docker, Certbot, Live Webapi, Nginx reverse proxy and TLS.
- **Evidence:** 0e550ad9f0ae2b5e16dec7d764ce0dddd7b54319 , 0646948f213ae37bb6fb1168b6c11cbc828ab192, 7a3c1c722556378dc9d8b7b09a22b54147e366ae
- **Understanding:** Garage, Nginx reverse proxy, Docker&kubernetes setup, google oath, how i setup a live webapi with a url.
- **Reflection:** I learned that enviroment files should not be sepparate from the project, they should insted just be added to gitignore, so i can upload dummy files when necessary, and save myself much headake. I set up the enviroment by essentially hardcoding everything to the primary pi, making documentation harder. i should also pay more attention to the commands of the ai, as it at one time published to a new folder in response to a challenge i was having pushing the code to production. Hello World versioning is very useful for knowing that the pushed code made it to prod.


### Tommaso Facchin

- **Git identity:** tommasofacchin
- **Primary contribution:** The desktop app and the file part of the API. In the app: login, register, logout, upload, file list, download and delete, and the Google sign-in button. In the API: the file endpoints now take the owner from the JWT, and file info is stored in a Files table in PostgreSQL. I also wrote a smoke test script and a workflow that checks the deployed API.
- **Evidence:** 5ff57ce, 548214f, 885a2a4, a07b52c, 30c0a82, b4223fc, 8fa2d11, 133db40
- **Understanding:** I can explain how the login token is stored and sent to the API, how Google sign-in returns the token to the app, and how files are tied to their owner and their metadata is kept in the database.
- **Reflection:** The hardest part was making the app and the deployed API work together. At one point the file list stopped loading because I had deleted the GET /files endpoint by mistake in a commit, and the app only said "Could not load your files". I learned to check the server logs and the running version.



## Group Confirmation

By submitting this file, the group confirms that the contribution and hour
records are accurate, that submitted work has been reviewed and tested, and that
each member can explain the work attributed to them.
