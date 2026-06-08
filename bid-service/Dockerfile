# Stage 1: Cache dependencies and compile the target module
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy multi-module orchestration pom layers
COPY pom.xml .
COPY order-service/pom.xml order-service/
COPY bid-service/pom.xml bid-service/

# Prefetch dependency layers
RUN mvn dependency:go-offline -B -pl bid-service

# Copy module source elements and build package
COPY bid-service/src bid-service/src
RUN mvn clean package -DskipTests -pl bid-service

# Stage 2: Lightweight execution capsule
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/bid-service/target/bid-service-*.jar app.jar

EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
