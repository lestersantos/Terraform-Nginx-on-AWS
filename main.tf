# CALL YOUR MODULES
module "vpc" {
  source = "./modules/network"
  #Parameters to costumize the module network
  vpc_cidr    = var.vpc_module["vpc_cidr"]
  environment = var.vpc_module["environment"]
}

module "launch_template" {
  source        = "./modules/launch_template"
  vpc_id        = module.vpc.vpc_id #create a new variable in launch_template module variables
  instance_size = var.launch_template_module["instance_size"]
  disk_size     = var.launch_template_module["disk_size"]
  ami           = var.launch_template_module["ami"]
  project_name  = var.project_name
}

module "autoscaling_group"{
  source = "./modules/asg"
  lt_id  = module.launch_template.lt_id
  subnets = module.vpc.vpc_public_subnets
  project_name = var.project_name
}