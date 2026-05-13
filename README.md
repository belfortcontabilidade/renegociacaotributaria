# renegociacaotributaria

Landing page estatica servida via Nginx em container Docker.

## Deploy

Pipeline automatico via GitHub Actions:

1. Push em `main` dispara o workflow `.github/workflows/deploy.yml`
2. Imagem e construida e publicada em `ghcr.io/belfortcontabilidade/renegociacaotributaria:latest`
3. Workflow chama o webhook do Portainer, que faz `pull` da nova imagem e recria o container

### Configuracao inicial

**No GitHub** (uma unica vez):

- Em `Settings > Secrets and variables > Actions`, criar o secret `PORTAINER_WEBHOOK_URL` com o webhook gerado pelo Portainer (passo abaixo).
- Apos o primeiro build, em `Packages > renegociacaotributaria > Package settings`, deixar a visibilidade como `Public` (ou configurar registry credentials no Portainer).

**No Portainer** (uma unica vez):

1. `Stacks > Add stack`
2. Nome: `renegociacaotributaria`
3. Build method: `Web editor` — colar o conteudo do `docker-compose.yml`
4. Habilitar **GitOps updates** ou **Re-pull image and redeploy** com webhook
5. Copiar a URL do webhook gerada e cadastrar no secret `PORTAINER_WEBHOOK_URL` do GitHub
6. Deploy

A partir dai todo `git push origin main` publica em producao.

## Rodar localmente

```bash
docker compose up -d
# Acessar http://localhost:8080
```
