# ---------------------------------------------------------
# Artifact Registry (Docker)
# ---------------------------------------------------------
resource "google_artifact_registry_repository" "docker_repo" {
  repository_id = var.artifact_repo_name
  location      = var.region
  format        = "DOCKER"
  description   = "Docker repo gd-cicd"
  vulnerability_scanning_config {
    enablement_config = "DISABLED"
  }
}

# ---------------------------------------------------------
# Service Account used by GitHub Actions
# ---------------------------------------------------------
resource "google_service_account" "cicd_sa" {
  account_id   = var.cicd_sa_id
  display_name = var.cicd_sa_name
}

# Give it permissions needed for CI/CD
resource "google_project_iam_member" "sa_artifact_write" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}

resource "google_project_iam_member" "sa_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}

resource "google_project_iam_member" "sa_serviceaccount_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cicd_sa.email}"
}

# ---------------------------------------------------------
# Workload Identity Federation
# ---------------------------------------------------------

# 1. Create Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = var.wif_pool_id
  display_name              = var.wif_pool_name
}

# 2. Create OIDC Provider for GitHub Actions
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_provider_id = var.wif_provider_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  display_name                       = var.wif_provider_name
  attribute_mapping = {
    "google.subject"                = "assertion.sub"
    "attribute.actor"               = "assertion.actor"
    "attribute.repository"          = "assertion.repository"
    "attribute.repository_owner"    = "assertion.repository_owner"
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
  }
  attribute_condition = <<EOT
  assertion.repository_owner_id == "${var.repo_owner_id}"
  EOT
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# ---------------------------------------------------------
# Allow GitHub to impersonate the Service Account
# ---------------------------------------------------------
resource "google_service_account_iam_member" "allow_wif_impersonation" {
  service_account_id = google_service_account.cicd_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.repo_id}"
}
