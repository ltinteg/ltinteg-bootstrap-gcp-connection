# LtInteg GCP Connection Bootstrap

Bootstrap a Google Cloud service account for LtInteg using Cloud Shell in a few minutes.

**Artifact version:** `1.0.2`

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
curl -fsSL "https://raw.githubusercontent.com/ltinteg/ltinteg-bootstrap-gcp-connection/refs/heads/master/bootstrap-service-account.sh" -o bootstrap-service-account.sh
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

`7123bff8e13ea2f39c63a47664eaafc3e015702fa870e41e94cad4b66a4b338a`

## Security notes

- Use a dedicated service account per environment when possible.
- Grant only required roles; remove domains your organization does not use.
- Never commit JSON keys to source control.

## Troubleshooting

- **`You do not currently have an active account selected`**
  - Run `gcloud auth login` (or `gcloud config set account ACCOUNT`) and execute the script again.

## Version history

- `1.0.2`: added preflight check for active `gcloud` account before enabling APIs.
- `1.0.1`: use `roles/certificatemanager.editor` and continue when a role cannot be bound.
- `1.0.0`: initial public release.
