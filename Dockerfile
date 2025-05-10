## Licensed to the Apache Software Foundation (ASF) under one or more
## contributor license agreements. See the NOTICE file distributed with
## this work for additional information regarding copyright ownership.
## The ASF licenses this file to You under the Apache License, Version 2.0
## (the "License"); you may not use this file except in compliance with
## the License. You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

## Apache Jena Fuseki server Dockerfile.

## This Dockerfile builds a reduced footprint container.

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
