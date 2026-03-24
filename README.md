# LtInteg GCP Connection Bootstrap

Bootstrap a Google Cloud service account for LtInteg using Cloud Shell in a few minutes.

**Artifact version:** `1.0.0`

## What this repository provides

- `bootstrap-service-account.sh`: creates a dedicated service account and applies the IAM roles required by LtInteg.
- A repeatable setup flow designed for project administrators.
- A simple Cloud Shell-first workflow, so no local `gcloud` install is required.

## Prerequisites

- Google Cloud project where LtInteg will operate
- Project-level permission to manage IAM (`roles/resourcemanager.projectIamAdmin` or equivalent)
- Access to [Google Cloud Shell](https://shell.cloud.google.com/)

## Quick start (Cloud Shell)

Run the following in Cloud Shell:

```bash
curl -fsSL "https://github.com/ltinteg/ltinteg-bootstrap-gcp-connection/blob/master/bootstrap-service-account.sh" -o bootstrap-service-account.sh
chmod +x bootstrap-service-account.sh
./bootstrap-service-account.sh YOUR_PROJECT_ID
```

Optional second argument:

```bash
./bootstrap-service-account.sh YOUR_PROJECT_ID ltinteg-connection
```

If your LtInteg setup uses service account key authentication, create a JSON key for this account after bootstrap and store it securely.

## IAM scope

The script applies the role set documented in `GCP_SERVICE_ACCOUNT_IAM.md` (viewer, storage, run, DNS, certificate manager, network viewer, and Artifact Registry reader).

## Verify artifact integrity

```bash
sha256sum bootstrap-service-account.sh
```

Expected SHA256:

`6195aad1d7c98944303ff175d7e5a05682b964ae9912ad5d8ff29cb34d464ddb`

## Security notes

- Use a dedicated service account per environment when possible.
- Grant only required roles; remove domains your organization does not use.
- Never commit JSON keys to source control.

## Version history

- `1.0.0`: initial public release.
