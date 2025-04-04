bootstrap:
	@kubectl create secret generic hcp-credentials \
      --namespace hcp-vault \
      --from-literal=clientID=${var.hcp_client_id} \
      --from-literal=clientSecret=${var.hcp_client_secret}
	@kubectl create secret generic slk-bot-token \
      --namespace hcp-vault \
      --from-literal=slack-token=${var.slk_bot_token}
	@helm repo add hashicorp https://helm.releases.hashicorp.com
	@helm install vault-secrets-operator hashicorp/vault-secrets-operator -n hcp-vault --create-namespace
	@helm repo add traefik https://helm.traefik.io/traefik
	@helm install traefik traefik/traefik -f values/traefik.yaml -n traefik --create-namespace
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm install argocd argo/argo-cd -f values/argocd.yaml -n argocd --create-namespace
	@helm install updater argo/argocd-image-updater -f values/argocd-image-updater.yaml -n argocd 

