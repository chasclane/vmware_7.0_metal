auth_token = ""
ssh_private_key_path = "~/.ssh/id_rsa"
public_ips_cidr = ["/28"]
project_id = ""
organization_id = ""

# Device provisioning
router_hostname = "edge-gateway"
esxi_hostname = "esx"
router_size = "c3.medium.x86"
esxi_size = "m3.large.x86"
facility = "dc13"
router_os = "ubuntu_18_04"
vmware_os = "vmware_esxi_7_0"
billing_cycle = "hourly"
esxi_host_count = 3

# VMWare specific variables
vcenter_portgroup_name  = "VM Public Net 1"
vcenter_datacenter_name = "Equinix Metal DC13"
vcenter_cluster_name = "dc13-1"
vcenter_domain = "vsphere.local"
vcenter_user_name = "Administrator"
domain_name = "equinix-metal.local"
vpn_user = "vm_admin"

# Minio storage
s3_url = ""
s3_bucket_name = "vmware"
s3_access_key = ""
s3_secret_key = ""
vcenter_iso_name = "VMware-VCSA-all-7.0.1-17004997.iso"

private_subnets = [
  {
    "name" : "VM Private Net 1",
    "nat" : true,
    "vsphere_service_type" : null,
    "routable" : true,
    "cidr" : "172.16.0.0/24"
  },
  {
    "name" : "vMotion",
    "nat" : false,
    "vsphere_service_type" : "vmotion",
    "routable" : false,
    "cidr" : "172.16.1.0/24"
  },
  {
    "name" : "vSAN",
    "nat" : false,
    "vsphere_service_type" : "vsan",
    "routable" : false,
    "cidr" : "172.16.2.0/24"
  }
]

public_subnets = [
  {
    "name" : "VM Public Net 1",
    "nat" : false,
    "vsphere_service_type" : "management",
    "routable" : true,
    "ip_count" : 16
  }
]