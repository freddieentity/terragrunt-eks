#!/bin/bash
echo "**|X|** ArgoCD Information"
echo "ArgoCD Username: admin | Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)"