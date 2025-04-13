#!/bin/bash

# Создаем и запускаем контейнеры
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80
kubectl run back-end-app --image=nginx --labels role=back-end --expose --port 80

kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80
kubectl run admin-back-end-app --image=nginx --labels role=admin-back-end --expose --port 80

# Создаем сетевые политики
kubectl apply -f non-admin-api-allow.yml