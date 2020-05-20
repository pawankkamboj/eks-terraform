#
# Provider Configuration
#

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.38.0"
}

