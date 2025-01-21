FROM postgres:15

# Instalar pgvector
RUN apt-get update && apt-get install -y postgresql-15-pgvector && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de inicialização
COPY ./initdb /docker-entrypoint-initdb.d/
