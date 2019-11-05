provider "aws"{
  region = "eu-central-1"
}

resource "aws_iam_user" "tf_user" {
  name = "tf-user-s3"
  path = "/hq/devs/"

  tags = {
    purpose = "tf-training"
  }

}

resource "aws_iam_user_policy" "full-s3" {
  name = "full-s3-access"
  user = aws_iam_user.tf_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TFInline",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.tf_user.name
}

output "iam_access_key_id" {
  value = aws_iam_access_key.access_key.id
}

output "iam_access_key_secret" {
  value = aws_iam_access_key.access_key.secret
}
