# ── Stage 1: build (optional – only needed if you DON'T build in Jenkins) ──
# Uncomment this block if you want a fully self-contained Docker build
# FROM maven:3.9-eclipse-temurin-21 AS builder
# WORKDIR /app
# COPY pom.xml .
# RUN mvn dependency:go-offline -q
# COPY src ./src
# RUN mvn clean package -DskipTests

# ── Stage 2: runtime ────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jre-alpine

# Non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the JAR built by Maven/Gradle in Jenkins (passed via --build-arg)
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

RUN chown appuser:appgroup app.jar

USER appuser

EXPOSE 8080

# Tuned JVM flags for containers
ENTRYPOINT ["java", \
  "-XX:+UseContainerSupport", \
  "-XX:MaxRAMPercentage=75.0", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-jar", "app.jar"]
