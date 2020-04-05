provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn = "${var.tf_role_arn}"
    session_name = "TF-Session"
  }
}
