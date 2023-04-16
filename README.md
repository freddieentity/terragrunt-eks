# Infrastructure live repository
This repo will be in charge of handling infrastructure provisioning for actual environments (dev, qa, staging, prod) which will be orchestrated by Terragrunt - a wrapper of Terraform.
Each environment corresponds to each folder in the envs folder. In specific environment folder, it will have its own terragrunt.hcl to input module variables while extending parents terragrunt.hcl configurations.

```sh
.
├── README.md
├── envs # Contains environment infrastructure
│   ├── common.hcl
│   ├── dev
│   │   ├── eks
│   │   │   └── terragrunt.hcl
│   │   └── vpc
│   │       └── terragrunt.hcl
│   ├── prod
│   │   └── terragrunt.hcl
│   ├── qa
│   │   └── terragrunt.hcl
│   └── staging
│       └── terragrunt.hcl
├── terragrunt.hcl # Root configuration including remote state, 
```
```sh
# Instead of go over each module in each environment. We will run all using terragrunt run-all command
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply --terragrunt-non-interactive # echo "Y" | terragrunt apply-all
terragrunt run-all destroy --terragrunt-non-interactive
# During provision all infrastructure. If some modules corrupt then you could get into specific module folder to recreate it manually
```

TODO:
- Validate PR (similar with module repo)

- Put comment of `terraform plan` to PR

- CD plan must have approval button to merge and then trigger `terraform apply`