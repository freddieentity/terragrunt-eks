- 1. version.tf enforces the version required for this module.
- 2. iam.tf create the EKS cluster and EKS node groups IAM roles
Both includes the new created role binding with the assume role policy then attach to existing provided IAM roles to access to AWS resources
- 3. eks.tf create the EKS cluster and the EKS node groups
EKS makes call to AWS services on your behalf using above STS token including create autoscaling group for node groups
- 4. oidc.tf create the OIDC provider whichs enable trust between K8S and AWS IAM
![IRSA Token Issuing](./docs/images/irsa.png)  
K8S Service Account will be a "token issuer"
EKS use this SA including IAM role annotation and the JWT SA token to call AssumeRoleWithWebIdentity API for making SA token valid as an STS token
IAM OIDC provider receives and validates the SA token with K8S then authorize this SA token valid as an STS token
https://aws.amazon.com/blogs/containers/diving-into-iam-roles-for-service-accounts/
- 5. *-irsa.tf create fine-grained application IRSA roles based on OIDC provider
- 6. variables.tf module variables
- 7. outputs.tf module outputs