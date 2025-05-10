# Base image for Java
ARG JAVA_VERSION=21
ARG ALPINE_VERSION=3.21.2
ARG FUSEKI_VERSION=5.4.0
ARG FUSEKI_JAR=fuseki-server.jar
ARG JENA_VERSION=5.4.0
ARG REPO=https://repo1.maven.org/maven2

# ---- Stage: Download and build Java
FROM eclipse-temurin:${JAVA_VERSION}-alpine AS base

WORKDIR /fuseki

# ---- Stage: Build runtime
FROM alpine:${ALPINE_VERSION}

# Install dependencies
RUN apk update && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Copy Java runtime
COPY --from=base /opt/java/openjdk /opt/java/openjdk

# Copy Fuseki directory (optional placeholder)
COPY --from=base /fuseki /fuseki

# Download and extract Apache Jena tools from Maven Central
ARG JENA_VERSION
ARG REPO
RUN curl -fSL "${REPO}/org/apache/jena/apache-jena/${JENA_VERSION}/apache-jena-${JENA_VERSION}.tar.gz" -o /tmp/jena.tar.gz && \
    tar -xzf /tmp/jena.tar.gz -C /opt && \
    rm /tmp/jena.tar.gz

# Set environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV JENA_HOME=/opt/apache-jena-${JENA_VERSION}
ENV PATH="${JAVA_HOME}/bin:${JENA_HOME}/bin:${PATH}"

# Set working directory
WORKDIR /fuseki

# Create fuseki user and folders
ARG JENA_USER=fuseki
ARG JENA_GROUP=$JENA_USER
ARG JENA_GID=1000
ARG JENA_UID=1000

RUN addgroup -g "${JENA_GID}" "${JENA_GROUP}" && \
    adduser "${JENA_USER}" -G "${JENA_GROUP}" -s /bin/ash -u "${JENA_UID}" -H -D && \
    mkdir --parents /fuseki && \
    chown -R $JENA_USER /fuseki

USER $JENA_USER

RUN mkdir -p /fuseki/logs && mkdir -p /fuseki/databases && mkdir -p /fuseki/tmp

# Expose Fuseki server port
EXPOSE 3030

# Copy Fuseki server jar from local context
COPY ${FUSEKI_JAR} /fuseki/

# Define default CMD to run the Fuseki server (this is the default behavior)
CMD ["java", "-jar", "fuseki-server.jar"]

# Ensure that utilities like tdb2 commands are available for use
