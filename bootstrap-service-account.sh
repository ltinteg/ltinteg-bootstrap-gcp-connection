#!/usr/bin/env bash
# LtInteg GCP connection — create service account + project roles + enable APIs
# Version: 1.0.2 — preflight auth check for Cloud Shell sessions
#
# Usage (Cloud Shell):
#   curl -fsSL .../bootstrap-service-account.sh | bash -s -- YOUR_PROJECT_ID
#   ./bootstrap-service-account.sh YOUR_PROJECT_ID [SERVICE_ACCOUNT_SHORT_NAME]
#
# Do NOT commit JSON keys to git. Create a key in Console if LtInteg requires a key file.

set -euo pipefail

PROJECT_ID="${1:-}"
SA_SHORT="${2:-ltinteg-connection}"

if [[ -z "${PROJECT_ID}" ]]; then
  echo "Usage: $0 PROJECT_ID [SERVICE_ACCOUNT_SHORT_NAME]" >&2
  echo "Example: $0 my-gcp-project ltinteg-connection" >&2
  exit 1
fi

ACTIVE_ACCOUNT="$(gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null || true)"
if [[ -z "${ACTIVE_ACCOUNT}" ]]; then
  echo "ERROR: No active gcloud account found." >&2
  echo "Run one of the following, then re-run this script:" >&2
  echo "  gcloud auth login" >&2
  echo "  gcloud config set account ACCOUNT" >&2
  exit 1
fi
echo "==> Using gcloud account: ${ACTIVE_ACCOUNT}"

echo "==> Using project: ${PROJECT_ID}"
gcloud config set project "${PROJECT_ID}"

APIS=(
  cloudresourcemanager.googleapis.com
  storage.googleapis.com
  run.googleapis.com
  dns.googleapis.com
  certificatemanager.googleapis.com
  compute.googleapis.com
  artifactregistry.googleapis.com
)

echo "==> Enabling APIs (idempotent)..."
for api in "${APIS[@]}"; do
  gcloud services enable "${api}" --project="${PROJECT_ID}"
done

SA_EMAIL="${SA_SHORT}@${PROJECT_ID}.iam.gserviceaccount.com"

if gcloud iam service-accounts describe "${SA_EMAIL}" --project="${PROJECT_ID}" &>/dev/null; then
  echo "==> Service account already exists: ${SA_EMAIL}"
else
  echo "==> Creating service account: ${SA_SHORT}"
  gcloud iam service-accounts create "${SA_SHORT}" \
    --project="${PROJECT_ID}" \
    --display-name="LtInteg connection"
fi

ROLES=(
  roles/viewer
  roles/storage.admin
  roles/run.admin
  roles/dns.admin
  roles/certificatemanager.editor
  roles/compute.networkViewer
  roles/artifactregistry.reader
)

echo "==> Binding roles (idempotent adds)..."
for role in "${ROLES[@]}"; do
  if gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="${role}" \
    --quiet; then
    echo "   [ok] ${role}"
  else
    echo "   [warn] could not bind ${role} on project ${PROJECT_ID}; skipping." >&2
  fi
done

echo ""
echo "Done. Service account: ${SA_EMAIL}"
echo "Next: Create a JSON key (IAM → Service Accounts → ${SA_SHORT} → Keys) only if required;"
echo "      paste the JSON into LtInteg as a GCP service-account connection, with project ID ${PROJECT_ID}."
