#!/usr/bin/env bash
# LtInteg GCP connection — create service account + project roles + enable APIs
# Version: 1.0.0 — align roles with docs/reference/GCP_SERVICE_ACCOUNT_IAM.md
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
  roles/certificatemanager.admin
  roles/compute.networkViewer
  roles/artifactregistry.reader
)

echo "==> Binding roles (idempotent adds)..."
for role in "${ROLES[@]}"; do
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="${role}" \
    --quiet
done

echo ""
echo "Done. Service account: ${SA_EMAIL}"
echo "Next: Create a JSON key (IAM → Service Accounts → ${SA_SHORT} → Keys) only if required;"
echo "      paste the JSON into LtInteg as a GCP service-account connection, with project ID ${PROJECT_ID}."
