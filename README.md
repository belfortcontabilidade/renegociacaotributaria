# renegociacaotributaria

Landing page estatica servida via Nginx, em Docker Swarm com Traefik (`letsencryptresolver`) e auto-update via Shepherd.

## Arquitetura

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
Shepherd (rodando no Swarm) detecta novo digest a cada 30s
   |
   v
docker service update --image ... (rolling update)
```

## Pre-requisitos no servidor

- Docker Swarm ativo (`docker swarm init`)
- Rede externa `BelfortNet` existente (ja usada pelo n8n)
- Traefik rodando com entrypoint `websecure` e certresolver `letsencryptresolver` na mesma rede
- DNS A do dominio escolhido apontando para o servidor

## Configuracao inicial

### 1. Domínio
O compose esta configurado para `renegociacao.belfortcontabilidade.com.br`. Se quiser outro, edite a label `traefik.http.routers.renegociacaotributaria.rule` no `docker-compose.yml` e crie o DNS A correspondente.

### 2. Imagem no GHCR
Apos o primeiro workflow concluir, em https://github.com/belfortcontabilidade?tab=packages abra o pacote `renegociacaotributaria` → Package settings → Change visibility → **Public**.

Se preferir manter privada, autenticar o Swarm manager uma vez:
```bash
docker login ghcr.io -u belfortcontabilidade -p <PAT_com_read:packages>
```
O `WITH_REGISTRY_AUTH=true` do Shepherd ja propaga essas credenciais.

### 3. Stack no Portainer
1. **Stacks → Add stack**
2. Nome: `renegociacaotributaria`
3. Build method: **Web editor** — colar o conteudo do `docker-compose.yml` deste repo
4. **Deploy the stack**

A stack sobe dois services:
- `renegociacaotributaria` — Nginx servindo o HTML, exposto via Traefik
- `shepherd` — checa a cada 30s se ha imagem nova; so atualiza services com label `shepherd.enable=true`

> Se voce ja tem um Shepherd global rodando em outra stack, remova o servico `shepherd` deste compose para evitar duplicidade — o filtro `label=shepherd.enable=true` faz com que o Shepherd global ja cuide deste service.

### 4. Pronto
A partir daqui, todo `git push origin main` dispara: build → push GHCR → Shepherd faz rolling update em ~30s.

## Rodar localmente (sem Swarm)

```bash
docker run --rm -p 8080:80 -v "$PWD/renegociacaotributaria.html:/usr/share/nginx/html/index.html:ro" nginx:alpine
# Acessar http://localhost:8080
```
