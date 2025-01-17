provider "aws" {
    region  = "us-west-2"
    shared_credentials_file  = "/aws/credentials"
    profile                  = "michalbagrowski"
}

data "terraform_remote_state" "ssl" {
    backend = "local"
    config {
        path = "${path.module}/../../ssl/terraform.tfstate"
    }
}

data "terraform_remote_state" "vpc" {
    backend = "local"
    config {
        path = "${path.module}/../../vpc/terraform.tfstate"
    }
}

resource "aws_api_gateway_domain_name" "domain" {
    domain_name = "all-rc-parts.com"
    certificate_arn = "${data.terraform_remote_state.ssl.all-rc-parts-com}"
}

resource "aws_api_gateway_base_path_mapping" "path" {
    api_id = "072t394l46"
    stage_name = "prd"
    domain_name = "${aws_api_gateway_domain_name.domain.domain_name}"
}

output  "domain-name" {
    value="${aws_api_gateway_domain_name.domain.cloudfront_domain_name}"
}

output "zone-id" {
    value="${aws_api_gateway_domain_name.domain.cloudfront_zone_id}"
}
