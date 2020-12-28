provider "aws" {
  version = "${aws_version}"
  region = "${aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${aws_account_id}"]

%{if ignore_updatedby }
  # Always ignore the changes from the tag UpdatedBy on plan
  ignore_tags {
    keys         = ["UpdatedBy"]
  }
%{endif}

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}
