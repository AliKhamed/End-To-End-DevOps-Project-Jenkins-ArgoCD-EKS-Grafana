# End-To-End-DevOps-Project-Jenkins-ArgoCD-EKS-Grafana

### Create ArgoCD on EKS cluster

1. Add helm repo
```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

```

2. Create helm argocd
```
kubectl create namespace argocd
helm install argocd argo/argo-cd --namespace argocd

```
3. Create argocd LoadBalancer
```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

```
4. Get argocd initial admin password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

### Create EKS Token

1. Step 1: Create a ServiceAccount, Role and roleBiniding
    Create a YAML manifest (sa-token.yml):

```
# service-account.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
  namespace: default
secrets:
  - name: my-service-account-secret
---
# role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: my-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "deployments"]
  verbs: ["get", "list", "create", "delete", "update"]
---
# role-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: my-role-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: my-service-account
  namespace: default
roleRef:
  kind: Role
  name: my-role
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: v1
kind: Secret
metadata:
  name: my-service-account-secret
  annotations:
    kubernetes.io/service-account.name: "my-service-account"
type: kubernetes.io/service-account-token

```

2. Get Token And add it as a credential on Jenkins UI

```
kubectl get secret my-service-account-secret -o jsonpath='{.data.token}' | base64 --decode

```