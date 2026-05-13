# renegociacaotributaria

Landing page estatica servida via Nginx em container Docker.

## Pipeline de deploy

```
git push origin main
   |
   v
GitHub Actions builda a imagem
   |
   v
Push para ghcr.io/belfortcontabilidade/renegociacaotributaria:latest
   |
   v
Watchtower (rodando no servidor) detecta nova imagem em ate 30s
   |
   v
Container e recriado automaticamente
```

Nao depende de webhook nem de API do Portainer.

## Configuracao inicial

### 1. Tornar a imagem publica no GHCR
Apos o primeiro workflow rodar:
- Acessar https://github.com/belfortcontabilidade?tab=packages
- Abrir o pacote `renegociacaotributaria` → **Package settings** → Change visibility → **Public**
- (Se preferir privada, cadastrar credenciais do GHCR no Portainer em *Registries*)

### 2. Criar a stack no Portainer
1. **Stacks → Add stack**
2. Nome: `renegociacaotributaria`
3. Build method: **Web editor** — colar o conteudo do `docker-compose.yml` deste repo
4. **Deploy the stack**

A stack inclui dois servicos:
- `web` — o nginx servindo o HTML na porta `8080`
- `watchtower` — checa a cada 30s se ha nova imagem `:latest` no GHCR e recria o `web` automaticamente

> Watchtower so atualiza containers com a label `com.centurylinklabs.watchtower.enable=true` (`--label-enable`), entao nao mexe em outros containers do servidor.

### 3. Pronto
A partir daqui, todo `git push origin main` dispara: build → push GHCR → Watchtower atualiza producao em ~30s.

## Rodar localmente

```bash
docker compose up -d
# Acessar http://localhost:8080
```
