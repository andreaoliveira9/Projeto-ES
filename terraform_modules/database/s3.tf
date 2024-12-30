resource "aws_s3_bucket" "image_bucket" {
  bucket = "clubsync-image-bucket"

  tags = {
    Name        = "Image Bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_ownership_controls" "image_bucket_ownership" {
  bucket = aws_s3_bucket.image_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "image_bucket_public_access" {
  bucket = aws_s3_bucket.image_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "pavilions_folder" {
  bucket = aws_s3_bucket.image_bucket.bucket
  key    = "pavilions/"
  content = ""        
}

resource "aws_s3_object" "clubs_folder" {
  bucket = aws_s3_bucket.image_bucket.bucket
  key    = "clubs/"   
  content = ""       
}

resource "aws_iam_user" "boto3_user" {
  name = "boto3_user"
}

resource "aws_iam_access_key" "boto3_user_key" {
  user = aws_iam_user.boto3_user.name
}

resource "aws_iam_user_policy" "boto3_user_policy" {
  name = "boto3_user_policy"
  user = aws_iam_user.boto3_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::clubsync-image-bucket",
        "arn:aws:s3:::clubsync-image-bucket/*"
      ]
    }
  ]
}
EOF
}