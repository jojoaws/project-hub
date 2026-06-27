module "networking" {

  source = "git::https://github.com/jojoaws/terraform-modules.git//networking"

  project_name = var.project_name
}
