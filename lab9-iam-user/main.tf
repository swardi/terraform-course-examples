provider "aws"{
  region = "eu-central-1"
}

variable "usernames" {
  type = list(string)
  description = "Names of the IAM users"
  default = ["john", "catherine", "mark", "yen"]
}

resource "aws_iam_user" "tf_user" {
  for_each = toset(var.usernames)
  name =  each.value

  tags = {
    purpose = "tf-training"
  }
}

output "all_users_arn" {
  value = aws_iam_user.tf_user[*].arn
}
