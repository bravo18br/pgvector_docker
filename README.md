# Projeto: PostgreSQL com a Extensão pgvector

Este projeto configura um container Docker com PostgreSQL 15 e a extensão `pgvector` para habilitar o armazenamento e manipulação de vetores. 

## Pré-requisitos

- [Docker](https://www.docker.com/) instalado
- [Docker Compose](https://docs.docker.com/compose/) instalado

## Estrutura do Projeto

```
.
├── Dockerfile                   # Define a imagem com PostgreSQL e pgvector
├── docker-compose.yml           # Configuração dos serviços Docker
├── initdb/                      # Scripts de inicialização do banco de dados
│   └── init.sql                 # Script para criar a extensão pgvector
└── README.md                    # Documentação do projeto
```

## Configuração

### 1. Dockerfile

O `Dockerfile` é responsável por configurar o PostgreSQL e instalar a extensão `pgvector`:

```dockerfile
FROM postgres:15

# Instalar pgvector
RUN apt-get update && apt-get install -y postgresql-15-pgvector && rm -rf /var/lib/apt/lists/*

# Copiar arquivos de inicialização
COPY ./initdb /docker-entrypoint-initdb.d/
```

### 2. docker-compose.yml

O arquivo `docker-compose.yml` configura o serviço PostgreSQL e monta os volumes necessários:

```yaml
services:
  db:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: pgvector
    environment:
      - POSTGRES_USER=docker
      - POSTGRES_PASSWORD=docker
      - POSTGRES_DB=postgres
      - UTC=-3
      - TIMEZONE=America/Sao_Paulo
    ports:
      - "5455:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U docker -d postgres"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: always
    volumes:
      - pgvector_data:/var/lib/postgresql/data
      - ./initdb:/docker-entrypoint-initdb.d
    networks:
      - pgvector_net
    command: postgres

volumes:
  pgvector_data:
    driver: local

networks:
  pgvector_net:
    name: pgvector_net
    driver: bridge
    attachable: true
```

### 3. initdb/init.sql

O script `init.sql` é executado durante a inicialização do container para criar a extensão `pgvector`:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

## Como Usar

1. Clone este repositório:

   ```bash
   git clone <url-do-repositorio>
   cd <nome-do-repositorio>
   ```

2. Construa e inicie os serviços:

   ```bash
   docker-compose up --build
   ```

3. Verifique se a extensão `pgvector` foi instalada:

   ```bash
   docker exec -it pgvector psql -U docker -d postgres -c "\dx"
   ```

   O resultado esperado deve incluir a extensão `vector`.

## Troubleshooting

- Caso o container não inicie corretamente, verifique os logs com:

  ```bash
  docker logs pgvector
  ```

- Certifique-se de que a porta `5455` não está em uso por outro serviço.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

