# Minikube Deployment Commands & PoC Output

Use these exact commands to validate the normalized full-stack application on your local Minikube cluster:

### 1. Start Minikube and Enable Ingress
```bash
$ minikube start --driver=docker
😄  minikube v1.38.0 on Ubuntu 24.04
✨  Using the docker driver based on existing profile
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.49 ...
🔄  Restarting existing docker container for "minikube" ... 
🐳  Preparing Kubernetes v1.35.0 on Docker 29.2.0 ... 
🔎  Verifying Kubernetes components...
🌟  Enabled addons: ingress
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

$ minikube addons enable ingress
🌟  The 'ingress' addon is enabled
```

### 2. Set Docker environment to Minikube
This allows us to build Docker images locally and make them available to Minikube without needing a registry.
```bash
$ eval $(minikube docker-env)
```

### 3. Build the Application Images
```bash
$ cd frontend
$ docker build -t flightly-modern-air-travel-booking-system-main-frontend:latest .
[+] Building 21.4s (16/16) FINISHED                         docker:default
 => => naming to docker.io/library/flightly-modern-air-travel-booking-system-main-frontend:latest

$ cd ../backend
$ docker build -t flightly-modern-air-travel-booking-system-main-backend:latest .
[+] Building 8.6s (16/16) FINISHED                          docker:default
 => => naming to docker.io/library/flightly-modern-air-travel-booking-system-main-backend:latest
```

### 4. Deploy Kubernetes Manifests using Kustomize
Apply the development environment overlay:
```bash
$ kubectl apply -k k8s/overlays/local
namespace/flightly-local created
configmap/app-config-72mbkfgbd7 created
secret/app-secrets-6ct2t6b985 created
service/backend created
service/frontend created
service/mongo created
persistentvolumeclaim/mongo-data created
deployment.apps/backend created
deployment.apps/frontend created
deployment.apps/mongo created
ingress.networking.k8s.io/flightly-ingress created
```

### 5. Verification Output

```bash
$ kubectl get pods,ingress,svc -n flightly-local
NAME                        READY   STATUS    RESTARTS      AGE
backend-7f6bc95779-gv4vk    1/1     Running   2 (24m ago)   14h
frontend-666f786d9f-246tb   1/1     Running   3 (24m ago)   15h
mongo-8d4796644-mqvfl       1/1     Running   1 (13h ago)   15h

NAME                                         CLASS   HOSTS            ADDRESS        PORTS   AGE
ingress.networking.k8s.io/flightly-ingress   nginx   flightly.local   192.168.49.2   80      15h

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)     AGE
service/backend    ClusterIP   10.103.152.8     <none>        8080/TCP    15h
service/frontend   ClusterIP   10.107.161.119   <none>        80/TCP      15h
service/mongo      ClusterIP   10.98.4.118      <none>        27017/TCP   15h
```

```bash
$ curl -s -o /dev/null -w "%{http_code}" -H "Host: flightly.local" http://192.168.49.2/api/health
200
$ curl -s -o /dev/null -w "%{http_code}" -H "Host: flightly.local" http://192.168.49.2/
200
```

### 6. User Journey Proof
Verified via manual UI testing through the Ingress:
1. **Login**: Authenticated successfully with `testuser@example.com`.
2. **Booking**: Able to search and select flights (e.g., Mymensingh to Dhaka).
3. **Session**: JWT token correctly handled and stored for protected routes.
