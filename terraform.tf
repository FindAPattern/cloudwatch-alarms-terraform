terraform {
  backend "s3" {
    bucket = "prodmann-terraform-artifacts"
    key    = "post01/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
