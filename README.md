# CrowdQ Infrastructure Setup

This repository contains the Docker-based infrastructure stack for the **CrowdQ** microservices showcase project. It provides databases, message brokers, observability tools, authentication, caching, and developer utilities to support local development and testing.

## 🗂️ Folder Structure

```
crowdq-infra/
├── docker-compose.yml        # Main Docker Compose file
├── .env                      # Environment variable configuration
├── prometheus/
│   └── prometheus.yml        # Prometheus configuration
├── keycloak/
│   ├── server.crt.pem        # TLS certificate for Keycloak
│   └── server.key.pem        # TLS key for Keycloak
├── grafana/                  # Optional Grafana provisioning
├── kafka/                    # Optional Kafka configs
├── postgres/                 # Optional PostgreSQL configs
├── redis/                    # Optional Redis configs
└── README.md                 # This file
```

## 🧩 Services Overview

| Service              | Port  | Description                                     |
|----------------------|-------|-------------------------------------------------|
| **PostgreSQL**       | 5432  | Main database for application services (CrowdQ) |
| **pgAdmin**          | 5050  | PostgreSQL database browser                     |
| **Redis**            | 6379  | In-memory cache                                 |
| **RedisInsight**     | 5540  | GUI for Redis monitoring                        |
| **Zookeeper**        | 2181  | Coordination service for Kafka                  |
| **Kafka**            | 9092  | Event streaming platform                        |
| **Redpanda Console** | 8088  | Kafka UI tool                                   |
| **Prometheus**       | 9090  | Metrics collection                              |
| **Grafana**          | 3000  | Dashboard and visualizations                    |
| **SonarQube**        | 9000  | Static code analysis                            |
| **Sonar DB**         | 5433  | PostgreSQL DB dedicated to SonarQube            |
| **Keycloak**         | 59000 | Authentication service                          |
| **Keycloak DB**      | 5434  | PostgreSQL DB for Keycloak                      |

## ⚙️ Environment Variables (.env)

All configuration values like ports and credentials are extracted to the `.env` file for maintainability and clarity.

Example:

```env
# Zookeeper
ZK_HOST=zookeeper
ZK_PORT=2181

# Kafka
KAFKA_BROKER=kafka:9092
KAFKA_PORT=9092
KAFKA_UI_PORT=8088

# PostgreSQL (CrowdQ)
CROWDQ_DB_HOST=postgres
CROWDQ_DB_PORT=5432
CROWDQ_DB_NAME=crowdq
CROWDQ_DB_USER=crowdq
CROWDQ_DB_PASSWORD=crowdq

# PgAdmin
PGADMIN_PORT=5050
PGADMIN_EMAIL=admin@crowdq.dev
PGADMIN_PASSWORD=admin

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDISINSIGHT_PORT=5540

# Prometheus
PROMETHEUS_PORT=9090

# Grafana
GRAFANA_PORT=3000

# SonarQube
SONARQUBE_HOST=sonarqube
SONARQUBE_PORT=9000
SONARQUBE_DB_HOST=sonar-postgres
SONARQUBE_DB_PORT=5432
SONARQUBE_DB_NAME=sonarqube
SONARQUBE_DB_USER=sonar
SONARQUBE_DB_PASSWORD=sonar

# Keycloak
KEYCLOAK_HOST=keycloak
KEYCLOAK_PORT=59000
KEYCLOAK_DB_HOST=keycloak-postgres
KEYCLOAK_DB_PORT=5432
KEYCLOAK_DB_NAME=keycloak
KEYCLOAK_DB_USER=keycloak
KEYCLOAK_DB_PASSWORD=keycloak
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASSWORD=admin
```

## 🔐 Keycloak Setup with TLS

Keycloak is exposed securely using HTTPS with self-signed certificates located in `keycloak/server.crt.pem` and `server.key.pem`.

To generate new certificates:

```bash
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -nodes \
  -keyout server.key.pem \
  -out server.crt.pem \
  -subj "/CN=localhost" \
  -addext "subjectAltName=DNS:localhost"
chmod 755 server.key.pem
```

To trust the certificate on the Java KeyStore:

```bash
sudo keytool -importcert \
  -file /path/to/server.crt.pem \
  -alias keycloak \
  -keystore $JAVA_HOME/lib/security/cacerts \
  -storepass changeit \
  -noprompt
```

**Important**: Restart the Operating System.

## 🐘 PostgreSQL

- `crowdq-postgres`: main DB for services
- `sonar-postgres`: SonarQube-only DB
- `keycloak-postgres`: used only by Keycloak

Access via **pgAdmin** at [http://localhost:5050](http://localhost:5050) for main DB only.

## 🔴 Redis

- Runs at `localhost:6379`
- Access **RedisInsight** at [http://localhost:5540](http://localhost:5540)

## 🔁 Kafka & Zookeeper

- Zookeeper runs on `2181`
- Kafka listens on `9092` (PLAINTEXT)
- Use **Redpanda Console** at [http://localhost:8088](http://localhost:8088)

## 📊 Metrics & Dashboards

- Prometheus: [http://localhost:9090](http://localhost:9090)
- Grafana: [http://localhost:3000](http://localhost:3000)

Set Prometheus as a data source in Grafana after first login.

## ✅ Static Code Analysis

- SonarQube: [http://localhost:9000](http://localhost:9000)
- Default login: `admin` / `admin`
- Uses its own PostgreSQL DB (`sonar-postgres`)

## 🔐 Authentication

- Keycloak: [https://localhost:59000](https://localhost:59000)
- Runs with HTTPS using provided certificate and PostgreSQL backend

## 🚀 Usage

1. Copy `.env.example` to `.env` and adjust values as needed.
2. Start all services:

```bash
docker compose up -d
```

3. Access interfaces:

- pgAdmin: http://localhost:5050  
- RedisInsight: http://localhost:5540  
- Kafka UI (Redpanda): http://localhost:8088  
- Prometheus: http://localhost:9090  
- Grafana: http://localhost:3000  
- SonarQube: http://localhost:9000  
- Keycloak: https://localhost:59000  

> 🛑 On first access to Keycloak, your browser may warn about the self-signed certificate.

## 🧼 Cleanup

```bash
docker compose down -v
```

If you want to keep your data, avoid using the `-v` option when stopping the containers.

## 📂 Volumes

| Volume Name             | Purpose                       |
|-------------------------|-------------------------------|
| `crowdq_postgres_data`  | App PostgreSQL persistence    |
| `sonar_postgres_data`   | SonarQube DB data             |
| `keycloak_postgres_data`| Keycloak DB data              |
| `sonarqube_data`        | SonarQube data                |
| `sonarqube_logs`        | SonarQube logs                |
| `sonarqube_extensions`  | SonarQube plugins             |
| `grafana_data`          | Grafana dashboards/settings   |

## 🤝 Contributing

This infra stack is part of the **CrowdQ microservices showcase**. Feel free to suggest improvements or submit pull requests!
