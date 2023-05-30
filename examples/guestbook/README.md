```sh
# Build Kustomize manifest and apply (Dev environment in this case)
kustomize build ./overlays/dev  | kubectl apply -f -
```