# GCP: LtInteg service account bootstrap (Cloud Shell)

**Artifact version:** 1.0.0

## Why a script (not CloudFormation)

GCP does not provide an AWS CloudFormation–equivalent “upload one template for all IAM” flow. Running this script in **Cloud Shell** avoids installing `gcloud` locally; you are already authenticated to your project.

## Steps

1. Open [Cloud Shell](https://shell.cloud.google.com/) and select your project.
2. Upload `bootstrap-service-account.sh` or paste its contents into a new file.
3. Run:
   ```bash
   chmod +x bootstrap-service-account.sh
   ./bootstrap-service-account.sh YOUR_PROJECT_ID
   ```
4. Optional second argument: service account short name (default `ltinteg-connection`).
5. Create a **JSON key** for that service account only if LtInteg is configured to use key-based auth; store it securely and paste into LtInteg.

Role bindings match [GCP_SERVICE_ACCOUNT_IAM.md](../../docs/reference/GCP_SERVICE_ACCOUNT_IAM.md).

## Checksum

```bash
sha256sum bootstrap-service-account.sh
```

**SHA256** (current committed file): `6195aad1d7c98944303ff175d7e5a05682b964ae9912ad5d8ff29cb34d464ddb`

## Changelog

- **1.0.0** — Initial bundle (viewer, storage, run, DNS, certificate manager, network viewer, Artifact Registry reader).
