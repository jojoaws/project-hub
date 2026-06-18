terraform {
  backend "s3" {
    bucket = "cloud-mastery-tfstate-bucket-677920913262"

    key = "projecthub/terraform.tfstate"

    region = "us-east-1"
  }
}
