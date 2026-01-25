# Kubernetes
Repositório destinado as configurações do kubernetes

## Pré-requisitos
- Minikube ou cluster Kubernetes configurado
- kubectl configurado para o cluster
- K6 instalado

## Passos para Deploy da Aplicação no Kubernetes

### 0. Iniciando o minikube
```sh
minikube start --driver=docker  --force
```

### 1. Crie o Namespace
```sh
kubectl apply -f manifests/comum/1-namespace.yml
```

### 2. Recursos do Banco de Dados
```sh
kubectl apply -f manifests/database/1-pv.yml
kubectl apply -f manifests/database/2-pvc.yml
kubectl apply -f manifests/database/3-secrets.yml
kubectl apply -f manifests/database/4-deployment.yml
kubectl apply -f manifests/database/5-services.yml
```

### 3. Recursos da Aplicação

### 3.1 ConfigMap e Secrets
```sh
kubectl apply -f manifests/app/1-configmap.yml
kubectl apply -f manifests/app/2-secrets_bd.yml
kubectl apply -f manifests/app/2-secrets_mp.yml
```

### 3.2 Deployment, Service e HPA
```sh
kubectl apply -f manifests/app/3-deployment.yml
kubectl apply -f manifests/app/4-service.yml
kubectl apply -f manifests/app/5-hpa.yml
```

## 4. Teste o Deploy
- Verifique os pods:
```sh
kubectl get pods -n fiap-soat11
```
- Verifique os serviços:
```sh
kubectl get svc -n fiap-soat11
```
- Crie um proxy para expor o serviço externamente ao minikube e copie a url:
```sh
minikube service fiap-svc --url -n fiap-soat11
```

## 5. Teste de Stress - Validando HPA
- Execute o teste de stress com k6:
```sh
k6 run --env URL_SERVICO=<Url Proxy minikube service> stress.js
```

---

Siga a ordem acima para garantir que todos os recursos dependentes estejam disponíveis no momento certo.