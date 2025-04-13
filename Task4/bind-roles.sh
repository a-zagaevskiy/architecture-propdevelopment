#!/bin/bash

set -e

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
    name: viewers
subjects:
- kind: User
  name: analyst1
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: analyst2
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: monitor1
  apiGroup: rbac.authorization.k8s.io
roleRef:
    kind: Role
    name: viewer
    apiGroup: rbac.authorization.k8s.io
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: editors
subjects:
- kind: User
  name: admin1
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: admin2
  apiGroup: rbac.authorization.k8s.io
roleRef:
    kind: ClusterRole
    name: editor
    apiGroup: rbac.authorization.k8s.io
EOF

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: admins
subjects:
- kind: User
  name: ib1
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: root
  apiGroup: rbac.authorization.k8s.io
roleRef:
    kind: ClusterRole
    name: admin
    apiGroup: rbac.authorization.k8s.io
EOF