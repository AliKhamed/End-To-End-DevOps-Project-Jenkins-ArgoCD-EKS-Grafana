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
apiVersion: v1
kind: ServiceAccount
metadata:
  name: deployer

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployer-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "deployments", "ingresses"]  # Example resources, adjust as needed
  verbs: ["create", "get", "update", "delete", "list", "watch"]

--- 
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: deployer-rolebinding
subjects:
- kind: ServiceAccount
  name: deployer
  namespace: default  # Adjust the namespace as per your requirements
roleRef:
  kind: Role
  name: deployer-role
  apiGroup: rbac.authorization.k8s.io


```

2. Get Token And add it as a credential on Jenkins UI

```
SECRET=$(kubectl get serviceaccount deployer -o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get secret $SECRET -o jsonpath='{.data.token}' | base64 --decode)
echo $TOKEN

```