include {
    path = find_in_parent_folders()
}

terraform {
    source = "../../.."

    // before_hook "select_workspace" {
    //     commands = ["init"]
    //     execute = ["terraform", "workspace", "select", "${local.workspace}"]
    // }
}

locals { 
    common = read_terragrunt_config(find_in_parent_folders("common.hcl")) 
}
# local.common.locals.tags

inputs = {
  region = "us-east-1"
  kind_cluster_context = "kind-homelab"
}