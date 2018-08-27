provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_s3_bucket" "static-storage-bucket" {
  bucket = "${var.static-storage-bucket}"
}

resource "aws_s3_bucket_policy" "static-storage-bucket-policy" {
  bucket = "${aws_s3_bucket.static-storage-bucket.id}"
  policy =<<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::static-storage-timamio/*"]
    }
  ]
}
POLICY

}
