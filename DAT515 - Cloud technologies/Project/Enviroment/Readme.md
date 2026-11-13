This file contains the enviroment files for the programs we use, all secrets are removed, and specific info like google account must be replaced, but this is commented where applicable, overall, some configuring required

Request flow:

Client → nginx (443, api.kamen.no, Pi 1)
       → minikube NodePort (192.168.49.2:30080)
       → Service `fileapi` (load balances)
       → API pods (2 replicas, port 8080)
       → Garage S3 (Pi 1:3900) — replicated to Pi 2
       → PostgreSQL (Pi 1:5432) for file metadata

| Component | File | Notes |
|---|---|---|
| nginx | api| TLS termination; `proxy_pass` points at the NodePort receives on port 443 sends on 30080 |
| Kubernetes | fileapi.yaml | Deployment (2 replicas) + Service ( listens on NodePort 30080, sends on to port 8080) |
| Container image | Dockerfile | Packages the published .NET app, listens on 8080 |
| App settings | k8s.env | Loaded as Secret `fileapi-env`; `__` maps to `:` in .NET config |
| Object storage | garage/garage.toml | Two nodes, replication_factor = 2 |
| Systemd settings | garage.service | systemd, starts garage on boot, and on failure |



The enviroment files on our live project lives here:

Kubernetes enviroment, these are run the cluster enviroment:
~/fileapi-k8s/k8s.env

Kubernetes and dockerfiles, these define the apps deployment in this image, as well as the dockerimage for the fileapi:
~/fileapi-k8s/fileapi.yaml 
~/fileapi-k8s/Dockerfile

Nginx, responsible for handling our reverse proxxy, while technically unnessecary if you are testing locally, it is necessary to maintain googles oath, and removing it requires configuring the port you either send to from the applicaton, or the port the kubernetes cluster expects:
/etc/nginx/sites-enabled/api

The following go on all devices running garage, they connect and configure the storage s3 compatible storage, we ran this on two devices:
 /etc/garage.toml
 /etc/systemd/system/garage.service
