# CrowdQ Infrastructure Setup

This repository contains the Docker-based infrastructure stack for the **CrowdQ** microservices showcase project. It provides databases, message brokers, observability tools, caching, and developer utilities to support local development and testing.

## 🗂️ Folder Structure

```
infra/
├── docker-compose.yml       # Main Docker Compose file
├── .env                     # Environment variable configuration
├── prometheus/
│   └── prometheus.yml       # Prometheus configuration file
└── README.md                # This file
```

## 🧩 Services Overview

| Service              | Port | Description                                     |
|----------------------|------|-------------------------------------------------|
| **PostgreSQL**       | 5432 | Main database for application services (CrowdQ) |
| **pgAdmin**          | 5050 | PostgreSQL database browser                     |
| **Redis**            | 6379 | In-memory cache                                 |
| **RedisInsight**     | 5540 | GUI for Redis monitoring                        |
| **Zookeeper**        | 2181 | Coordination service for Kafka                  |
| **Kafka**            | 9092 | Event streaming platform                        |
| **Redpanda Console** | 8080 | Kafka UI tool                                   |
| **Prometheus**       | 9090 | Metrics collection                              |
| **Grafana**          | 3000 | Dashboard and visualizations                    |
| **SonarQube**        | 9000 | Static code analysis                            |
| **Sonar DB**         | 5433 | PostgreSQL DB dedicated to SonarQube            |

## ⚙️ Environment Variables (.env)

All configuration values like ports and credentials are extracted to the `.env` file for maintainability and clarity.

Example:

```env
# Zookeper
ZK_HOST=zookeeper
ZK_PORT=2181

# Kafka
KAFKA_BROKER=kafka:9092
KAFKA_PORT=9092

# Kafka UI - Redpanda
KAFKA_UI_PORT=8080

# CrowdQ Postgres Database
CROWDQ_DB_HOST=postgres
CROWDQ_DB_PORT=5432
CROWDQ_DB_NAME=crowdq
CROWDQ_DB_USER=crowdq
CROWDQ_DB_PASSWORD=crowdq

# Postgres Database UI - PgAdmin
PGADMIN_PORT=5050
PGADMIN_EMAIL=admin@crowdq.dev
PGADMIN_PASSWORD=admin

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# Redis UI - RedisInsight
REDISINSIGHT_PORT=5540

# Prometheus
PROMETHEUS_PORT=9090

# Grafana
GRAFANA_PORT=3000

# SonarQube Postgres Database
SONARQUBE_DB_HOST=sonar-postgres
SONARQUBE_DB_PORT=5432
SONARQUBE_DB_NAME=sonarqube
SONARQUBE_DB_USER=sonar
SONARQUBE_DB_PASSWORD=sonar

# SonarQube
SONARQUBE_HOST=sonarqube
SONARQUBE_PORT=9000
```

## 🐘 PostgreSQL

Two PostgreSQL services are included:

- `crowdq-postgres` — for application data
- `sonar-postgres` — for SonarQube only (to avoid DB conflicts)

Access either DB using **pgAdmin** at `http://localhost:5050`.

## 🔴 Redis

- Redis runs on `localhost:6379`
- Use **RedisInsight** (`http://localhost:5540`) for a visual interface.

## 🔁 Kafka & Zookeeper

- Zookeeper: Required by Kafka, on port `2181`
- Kafka: Configured with PLAINTEXT for development
- Redpanda Console (`http://localhost:8080`) helps browse topics, messages, etc.

## 📊 Metrics & Dashboards

- Prometheus (`http://localhost:9090`) scrapes metrics from services
- Grafana (`http://localhost:3000`) provides customizable dashboards

Configure Grafana to use Prometheus as a data source.

## ✅ Static Code Analysis

- SonarQube runs on `http://localhost:9000`
- Connects to its own PostgreSQL container (`sonar-postgres`)

Login default user: `admin` / `admin`

## 🚀 Usage

1. Copy `.env.example` to `.env` and adjust values if needed.
2. Start all services:

```bash
docker compose up -d
```

3. Access web interfaces:

- pgAdmin: http://localhost:5050
- RedisInsight: http://localhost:5540
- Kafka UI: http://localhost:8080
- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090
- SonarQube: http://localhost:9000

## 🧼 Cleanup

```bash
docker compose down -v
```

## 📂 Volumes

| Volume Name            | Purpose                       |
|------------------------|-------------------------------|
| `crowdq_postgres_data` | App PostgreSQL persistence    |
| `sonar_postgres_data`  | SonarQube PostgreSQL data     |
| `sonarqube_data`       | SonarQube main data dir       |
| `sonarqube_logs`       | Logs from SonarQube           |
| `sonarqube_extensions` | Plugins for SonarQube         |
| `grafana_data`         | Grafana dashboards & settings |

## 🤝 Contributing

This infra stack is part of the **CrowdQ microservices showcase**. Suggestions or improvements welcome!
