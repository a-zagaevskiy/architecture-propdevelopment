#!/bin/bash

set -e

# Создаем роль viewer, которая может просматривать информацию в кластере и не имеет доступа к конфиденциальной информации
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: viewer
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "nodes"]
  verbs: ["get", "list", "watch"]
EOF

# Создаем роль editor, которая имеет полные права доступа к кластеру и не имеет доступа к конфиденциальной информации
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: editor
rules:
- apiGroups: [""]
  resources: ["pods", "deployments", "services", "configmaps", "nodes"]
  verbs: ["*"]
EOF

# Создаем роль admin, которая имеет полные права доступа к кластеру и имеет доступ к конфиденциальной информации
cat <<EOF | kubectl apply -f - 
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: admin
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
EOF
