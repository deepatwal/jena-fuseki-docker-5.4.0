
ARG JAVA_VERSION=21
ARG ALPINE_VERSION=3.21.2
ARG FUSEKI_VERSION=5.4.0
ARG FUSEKI_JAR=fuseki-server.jar  # Define this variable before its use

## ---- Stage: Download and build Java.
FROM eclipse-temurin:${JAVA_VERSION}-alpine AS base

## -- Fuseki installed and runs in /fuseki.
WORKDIR /fuseki

# ---- Stage: Build runtime
FROM alpine:${ALPINE_VERSION}

## Copy Java runtime directly from the base image (Temurin)
COPY --from=base /opt/java/openjdk /opt/java/openjdk

## Copy the Fuseki installation files (Fuseki Server)
COPY --from=base /fuseki /fuseki

# Work directory for Fuseki
WORKDIR /fuseki

ARG JENA_USER=fuseki
ARG JENA_GROUP=$JENA_USER
ARG JENA_GID=1000
ARG JENA_UID=1000

# Run as this user
RUN addgroup -g "${JENA_GID}" "${JENA_GROUP}" && \
    adduser "${JENA_USER}" -G "${JENA_GROUP}" -s /bin/ash -u "${JENA_UID}" -H -D

RUN mkdir --parents /fuseki && \
    chown -R $JENA_USER /fuseki

USER $JENA_USER

RUN \
    mkdir -p /fuseki/logs && \
    mkdir -p /fuseki/databases

# Set environment variables for Java
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Expose the necessary port
EXPOSE 3030

# Copy the Fuseki server jar file from your local machine to the container
COPY ${FUSEKI_JAR} /fuseki/

# Set the entrypoint to run the server using the Java command
ENTRYPOINT ["java", "-jar", "fuseki-server.jar"]
