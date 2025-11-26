variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "gridtests"
}

variable "region" {
  description = "Region for Artifact Registry"
  type        = string
  default     = "europe-north2"
}

variable "artifact_repo_name" {
  description = "Name of Artifact Registry repo"
  type        = string
  default     = "gd-cicd2"
}

variable "cicd_sa_id" {
  description = "Service account id"
  type        = string
  default     = "github-cicd2"
}

variable "cicd_sa_name" {
  description = "Service account name"
  type        = string
  default     = "GitHub Actions Pipeline2"
}

variable "wif_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "github-pool2"
}

variable "wif_pool_name" {
  description = "Workload Identity Pool Display Name"
  type        = string
  default     = "GitHub Actions Pool2"
}

variable "wif_provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
  default     = "github-provider2"
}

variable "wif_provider_name" {
  description = "Workload Identity Provider name"
  type        = string
  default     = "GitHub Provider"
}
variable "github_repo" {
  description = "GitHub repository in the form owner/repo"
  type        = string
  default     = "app212/gd-cicd"
}

variable "repo_id" {
  description = "ID number of Github repo"
}
variable "repo_owner_id" {
  description = "ID number of Github repo owner"
}
