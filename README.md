# VMware on Equinix Metal
This repo has Terraform plans to deploy a multi-node vSphere cluster with vSan enabled on Packet. Follow this simple instructions below and you shold be able to go from zero to vSphere in 30 to 60m.

## Install Terraform 
Terraform is just a single binary.  Visit their [download page](https://www.terraform.io/downloads.html), choose your operating system, make the binary executable, and move it into your path. 
 
Here is an example for **macOS**: 
```bash 
curl -LO https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_darwin_amd64.zip 
unzip terraform_0.12.18_darwin_amd64.zip 
chmod +x terraform 
sudo mv terraform /usr/local/bin/ 
``` 
## Initialize Terraform 
Terraform uses modules to deploy infrastructure. In order to initialize the modules you run: `terraform init`. This should download a few modules into a hidden directory called `.terraform` 

## If you don't have one yet, setup an S3 compatible object store
You need to use an S3 compatible object store in order to download *closed source* packages such as *vCenter* and the *vSan SDK*. [Minio](http://minio.io) works great for this, which is an open source object store is a workable option.

You will need to layout the S3 structure to look like this:
``` 
https://s3.example.com:9000 
    | 
    |__ vmware 
        | 
        |__ VMware-VCSA-all-7.0-14367737.iso
        | 
        |__ vsanapiutils.py
        | 
        |__ vsanmgmtObjects.py
``` 

These files can be downloaded from [My VMware](http://my.vmware.com).


You will need to find the two individual Python files in the vSAN SDK zip file and place them in the S3 bucket as shown above. One file is in the 'bindings' directory in the zip file, and the other is in the 'sample code' directory in the zip file.

Reserve a /28 Public IP Address block from the Equinix Metal Portal:

* Go to console.equinix.com
* IPs and Networks
* IPs
+ Request IP addresses
* Public IPv4
* Location = select the datacenter you're deploying this to
* Quantity = /28 (16 IPs)
* Add a description for your new block.


## Modify your variables 
There is a `terraform.tfvars` file that you can copy and use to update with your deployment variables. Open the file in a text editor to update the variables.

* Modify the variable: public_ips_cidr = ["123.123.123.0/28"]

The following variable blocks must be validated to be accurate for your desired deployment:

* `auth_token` - This is your Equinix API key.
* `ssh_private_key_path` - The local private part of your Equinix Metal SSH key. - Make sure this is correct and accessible.
* `public_ips_cidr` - This should be the IP block /28 that you reserved in the previous step
* `project_id` - The Equinix Metal project you'd like to deploy this into.
* `organization_id` - Your Equinix Metal org.

# Device provisioning - Update this to reflect your desired state
* router_hostname = "edge-gateway"
* esxi_hostname = "esx"
* router_size = "c3.medium.x86"     <--- Validate the server plan is available to provision in your desired location
* esxi_size = "m3.large.x86"        <--- Validate the server plan is available to provision in your desired location
* facility = "dc13"                 <--- Validate your facility/datacenter code is correct
* router_os = "ubuntu_18_04"        <--- Validate your OS code is correct
* vmware_os = "vmware_esxi_7_0"     <--- Validate your OS code is correct
* billing_cycle = "hourly"          <--- Validate your billing option code is correct
* esxi_host_count = 3               <--- Validate this is your desired host number - Recommended to deploy 3, if only 2 are needed, the 3rd can be deleted after successful completion.

# VMWare specific variables
* vcenter_portgroup_name  = "VM Public Net 1"
* vcenter_datacenter_name = "Equinix Metal DC13"
* vcenter_cluster_name = "dc13-1"
* vcenter_domain = "vsphere.local"
* vcenter_user_name = "Administrator"
* domain_name = "equinix-metal.local"
* vpn_user = "vm_admin"

# Minio storage
* s3_url = "http://86.109.7.194:9000/"
* s3_bucket_name = "vmware"
* s3_access_key = "newminio"
* s3_secret_key = "newminio321"
* vcenter_iso_name = "VMware-VCSA-all-7.0.1-17004997.iso"*


The others set how many hosts you'd like, their size, etc. You'll notice some default values in the `terraform.tfvars` file.
 
## Deploy the Packet vSphere cluster 
 
All there is left to do now is to deploy the cluster! Hopefully you don't get any errors
```bash 
terraform apply
``` 
This should end with output similar to this:

``` 
Apply complete! Resources: 50 added, 0 changed, 0 destroyed. 
 
Outputs: 
 
vCenter_Appliance_Root_Password = n4$REf6p*oMo2eYr 
vCenter_FQDN = vcva.packet.local 
vCenter_Password = bzN4UE7m3g$DOf@P 
vCenter_Username = Administrator@vsphere.local 
``` 
 
### IF THE SCRIPT FAILS:

* if the script fails DURING or BEFORE VCSA deploy - a `terraform destroy --auto-approve` is needed to clean it up. 
* if the script fails AFTER VCSA deploy - an additional `terraform apply -auto-approve` should suffice to continue the configuration and complete successfully

## Cleaning the environement
To clean up a created environment (or a failed one), run `terraform destroy --auto-approve`.

If this does not work for some reason, you can manually delete each of the resources created in Packet (including the project) and then delete your terraform state file, `rm -f terraform.tfstate`.
