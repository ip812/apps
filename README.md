Before I used ArgoCD for GitOps and HCP Vault for secrets management, but currently the single VM I use for the cluster has only 2 CPUs and 2GB of RAM

This lead me to remove both from the cluster in order to save resources

ArgoCD alternative:
- CI/CD pipeline that will execute command on the VM via AWS SSM
    - git pull
    - kubectl apply -k .
- Lambda function that will make a commit to the repositroy when new image is pushed to ECR

Vault alternative:
- Will create kubernetes secrets in the bootstrapping process
- Whenever there is a change in the bootstrapping script, the VM will be recreated

P.S.
At the moment everything is located in a single namespace and there is one main secret(ip812-secrets) that holds all secrets needed for my applications

The reason for this is that if I want to use HCP Vault, I need to use the same namespace for all resources(HCP Vault Enterprise Standard license is required to manage secrets in multiple namespaces)
