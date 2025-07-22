## 🧠 Understanding Docker Hostnames vs `localhost`

When working with Docker containers, it's important to remember how **networking between containers** works versus **accessing services from your host machine**:

### 📝 From Your Host Machine (e.g., browser, curl, etc.)

When you open a browser or use `curl` on your local machine, you access services via:

```
http://localhost:<exposed-port>
```

Examples:

- `http://localhost:5050` → pgAdmin
- `http://localhost:5540` → RedisInsight
- `http://localhost:3000` → Grafana
- `http://localhost:9090` → Prometheus

This works because Docker exposes specific container ports to your host through the `ports:` section in `docker-compose.yml`.

---

### 🔗 From One Container to Another

Inside Docker containers, services communicate over the **Docker network** using **container names** as hostnames.

For example, if pgAdmin is running in a container and you want it to connect to PostgreSQL (also in a container), you must **use the service/container name** from `docker-compose.yml`:

```
Host: postgres
Port: 5432
```

**❌ Wrong:** `localhost` (from inside pgAdmin container, it means "pgAdmin container itself")

**✅ Correct:** `postgres` (Docker container name)

This applies to all services running inside Docker. Examples:

- RedisInsight should connect to Redis using `redis:6379`
- Grafana or Prometheus scraping targets should use `service-name:port`, not `localhost`

---

### 🚀 Accessing Host Services from Docker

If a container needs to access something running directly on your host (e.g., your local running app), you can use:

```
host.docker.internal
```

This is a special DNS name Docker provides to allow containers to talk to the host.

Example:

```
http://host.docker.internal:58000/actuator/prometheus
```

---

### ℹ️ Summary

| From                          | To                                 | Use |
| ----------------------------- | ---------------------------------- | --- |
| Host → Docker container       | `localhost:<exposed-port>`         |     |
| Container → Another container | `service-name:internal-port`       |     |
| Container → Host machine      | `host.docker.internal:<host-port>` |     |

Understanding this will help you avoid confusing connection errors and ensure everything runs smoothly!

