provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "static-storage" {
  bucket = "static-storage-timamio"
}

