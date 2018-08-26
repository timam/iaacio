provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "static-storage-bucket" {
  bucket = "${var.static-storage-bucket}"
}

