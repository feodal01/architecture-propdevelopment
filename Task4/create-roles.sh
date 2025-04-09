#!/bin/bash
# 2-create-roles.sh

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-view
rules:
  - apiGroups: ["", "extensions", "apps"]
    resources: ["pods", "deployments", "services", "daemonsets", "replicasets", "jobs", "configmaps"]
    verbs: ["get", "list", "watch"]
  # Запрещаем секреты, поэтому их нет в списке resources

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-edit
rules:
  - apiGroups: ["", "extensions", "apps"]
    resources: ["pods", "deployments", "services", "daemonsets", "replicasets", "jobs", "configmaps"]
    verbs: ["create", "get", "list", "watch", "update", "patch", "delete"]
  # Здесь по-прежнему нет доступа к secrets и управлению RBAC

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-privileged
rules:
  - apiGroups: ["*"]  # все группы
    resources: ["*"]   # все ресурсы, включая secrets и роли
    verbs: ["*"]       # полный доступ
EOF
