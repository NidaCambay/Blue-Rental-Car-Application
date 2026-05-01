#!/bin/bash

# NGINX'in hazır olup olmadığını kontrol et
echo "NGINX Ingress kurulumunu kontrol ediyor..."
until kubectl get pods -l app.kubernetes.io/name=ingress-nginx -n ingress-nginx | grep -q '1/1\s*Running'; do
  echo "NGINX henüz hazır değil, 10 saniye sonra tekrar denenecek..."
  sleep 10
done