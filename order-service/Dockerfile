# Stage 1: Cache dependencies and compile the target module
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy the multi-module project configuration layers
COPY pom.xml .
COPY order-service/pom.xml order-service/
COPY bid-service/pom.xml bid-service/

# Prefetch dependency layers to speed up workflow rebuilds
RUN mvn dependency:go-offline -B -pl order-service

# Copy source records and package the binary
COPY order-service/src order-service/src
RUN mvn clean package -DskipTests -pl order-service

# Stage 2: Establish a highly lightweight, secure production runtime execution capsule
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/order-service/target/order-service-*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
