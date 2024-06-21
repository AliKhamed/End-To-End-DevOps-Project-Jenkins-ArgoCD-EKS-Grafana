resource "aws_s3_bucket" "ivolve-s3" {
  bucket = var.bucket-name
}
resource "aws_s3_bucket_versioning" "ivolve-s3-versioning" {
  bucket = aws_s3_bucket.ivolve-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "ivolve-dynamodb-table" {
  name         = "terraformFstatFile"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"


  attribute {
    name = "LockID"
    type = "S"
  }
}
############################################################################################

# You must run the above code before run terraform backend code 

############################################################################################
# terraform {
#   backend "s3" {
#     bucket = "alikhames566-s3-bucket-terraform-fstat"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraformFstatFile"
#   }
# }
