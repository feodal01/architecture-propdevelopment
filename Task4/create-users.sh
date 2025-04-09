#!/bin/bash
# 1-create-users.sh
# Примерный скрипт для генерации ключей и сертификатов пользователей в Minikube

# Создаём директории для хранения сертификатов
mkdir -p users-certs

# ==== Создание пользователя "alice" (только просмотр) ====
openssl genrsa -out users-certs/alice.key 2048
openssl req -new -key users-certs/alice.key -subj "/CN=alice/O=dev-viewers" -out users-certs/alice.csr
# Подписываем CSR с помощью CA кластера Minikube
# Ключ CA находится в /var/lib/minikube/certs/ (зависит от версии minikube)
sudo openssl x509 -req -in users-certs/alice.csr \
  -CA /var/lib/minikube/certs/ca.crt \
  -CAkey /var/lib/minikube/certs/ca.key \
  -CAcreateserial -out users-certs/alice.crt -days 365

# Добавляем контекст в kubeconfig
kubectl config set-credentials alice --client-certificate=users-certs/alice.crt --client-key=users-certs/alice.key
kubectl config set-context alice@minikube --cluster=minikube --user=alice

# ==== Создание пользователя "bob" (привилегированный) ====
openssl genrsa -out users-certs/bob.key 2048
openssl req -new -key users-certs/bob.key -subj "/CN=bob/O=dev-admins" -out users-certs/bob.csr
sudo openssl x509 -req -in users-certs/bob.csr \
  -CA /var/lib/minikube/certs/ca.crt \
  -CAkey /var/lib/minikube/certs/ca.key \
  -CAcreateserial -out users-certs/bob.crt -days 365

kubectl config set-credentials bob --client-certificate=users-certs/bob.crt --client-key=users-certs/bob.key
kubectl config set-context bob@minikube --cluster=minikube --user=bob
