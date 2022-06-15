terraform {
required_version = ">= 1.0.2"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.43.0"
    }
  }
}

