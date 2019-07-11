variable "artifact_version" {
  description = "version of the artifact to be deployed."
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "/var/lib/jenkins/.ssh/id_rsa"
}