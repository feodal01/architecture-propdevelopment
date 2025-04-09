#!/bin/bash
# 3-assign-roles.sh

# Группа dev-viewers -> роль "cluster-view"
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dev-viewers-binding
subjects:
  - kind: Group
    name: dev-viewers
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-view
  apiGroup: rbac.authorization.k8s.io
EOF

# Группа dev-ops (если хотим роль cluster-edit) — по заданию минимум две группы, но можно и три
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dev-ops-binding
subjects:
  - kind: Group
    name: dev-ops
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-edit
  apiGroup: rbac.authorization.k8s.io
EOF

# Группа dev-admins -> роль "cluster-privileged"
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: dev-admins-binding
subjects:
  - kind: Group
    name: dev-admins
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-privileged
  apiGroup: rbac.authorization.k8s.io
EOF
