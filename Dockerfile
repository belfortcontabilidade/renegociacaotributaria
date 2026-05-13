FROM nginx:alpine

COPY renegociacaotributaria.html /usr/share/nginx/html/index.html
COPY renegociacaotributaria.html /usr/share/nginx/html/renegociacaotributaria.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
