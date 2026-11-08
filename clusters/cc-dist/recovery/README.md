# Credential recovery

`tunnel-basic-auth.sops.yaml` preserves the original SOPS-encrypted tunnel login, including the `username` and `password` keys. It uses the same age recipients as the deployed secret.

This directory is outside the Flux apps path and is not listed in the cluster kustomization, so these files are not deployed. Traefik uses only the `users` key in `apps/network/traefik/basic-auth.sops.yaml`.

From the repository root, recover either value locally with an authorized SOPS key:

```sh
sops --decrypt --extract '["data"]["username"]' clusters/cc-dist/recovery/tunnel-basic-auth.sops.yaml | base64 --decode
sops --decrypt --extract '["data"]["password"]' clusters/cc-dist/recovery/tunnel-basic-auth.sops.yaml | base64 --decode
```

These commands display the credentials in your terminal. Keep this file encrypted when committing changes.
