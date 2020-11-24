terraform {
  required_providers {
    packet = {
      source = "packethost/packet"
      version = "~> 3.0.1"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
