FROM eclipse-temurin:21-jre-alpine

COPY keycloak/server.crt.pem /etc/ssl/certs/keycloak.crt.pem

RUN keytool -importcert \
    -noprompt \
    -trustcacerts \
    -alias keycloak \
    -file /etc/ssl/certs/keycloak.crt.pem \
    -keystore "$JAVA_HOME/lib/security/cacerts" \
    -storepass changeit
