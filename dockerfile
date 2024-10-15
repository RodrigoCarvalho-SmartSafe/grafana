# Usando a imagem base do Alpine Linux
FROM alpine:3.20.3

# Instalação de pacotes necessários
RUN apk add --no-cache \
    curl \
    wget \
    tar \
    libc6-compat \
    tzdata \
    ca-certificates \
    fontconfig \
    && update-ca-certificates

# Definindo variáveis
ENV GRAFANA_VERSION=11.2.2
ENV GRAFANA_HOME=/usr/share/grafana

# Baixando e instalando o Grafana
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
    && echo "Criando a pasta do grafana" \
    && mkdir /usr/share/grafana \
    && mv grafana-v${GRAFANA_VERSION}/* $GRAFANA_HOME/ \
    && rm -rf grafana-${GRAFANA_VERSION}* \
    && adduser -D grafana \
    && chown -R grafana:grafana $GRAFANA_HOME \
    && chown -R 472:472 $GRAFANA_HOME \
    && chmod -R 755 $GRAFANA_HOME/

# Expondo a porta padrão do Grafana
EXPOSE 3000

# Definindo o diretório de trabalho
WORKDIR $GRAFANA_HOME

# Executando o Grafana
USER grafana
CMD ["bin/grafana-server", "web"]