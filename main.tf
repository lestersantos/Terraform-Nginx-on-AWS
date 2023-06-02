# CALL YOUR MODULES
module "vpc" {
  source = "./modules/network"
  vpc_cidr    = var.vpc_module["vpc_cidr"]
  environment = var.vpc_module["environment"]
  project_name = var.project_name
}

module "launch_template" {
  source        = "./modules/launch_template"
  vpc_id        = module.vpc.vpc_id
  instance_size = var.launch_template_module["instance_size"]
  disk_size     = var.launch_template_module["disk_size"]
  ami           = var.launch_template_module["ami"]
  project_name  = var.project_name
  alb_sg_id     = module.alb.alb_sg_id
}

module "autoscaling_group"{
  source = "./modules/asg"
  lt_id  = module.launch_template.lt_id
  subnets = module.vpc.vpc_private_subnets
  project_name = var.project_name
  alb_tg_arn = module.alb.alb_tg_arn
}

module "alb" {
    source = "./modules/alb"
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.vpc_public_subnets
    project_name = var.project_name
    acm_certificate = var.alb_module["acm_certificate"]
    ssl_policy = var.alb_module["ssl_policy"]
}

module route53_module {
    source = "./modules/route53"
    alb_dns_name = module.alb.alb_dns_name
    alb_zone_id = module.alb.alb_zone_id
    record_name = var.route53_module["record_name"]
    hosted_zone_name = var.route53_module["hosted_zone_name"]
}

module efs_module {
    source = "./modules/efs"
    project_name = var.project_name
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.vpc_public_subnets
    backend_sg_id = module.launch_template.backend_sg_id
}