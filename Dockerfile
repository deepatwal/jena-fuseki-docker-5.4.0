# Use Eclipse Temurin JDK base image
ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-alpine

ARG JENA_VERSION=5.4.0
ARG REPO=https://repo1.maven.org/maven2

# Install curl
RUN apk add --no-cache curl

# Download and extract Apache Jena CLI tools
RUN curl -fSL "${REPO}/org/apache/jena/apache-jena/${JENA_VERSION}/apache-jena-${JENA_VERSION}.tar.gz" -o /tmp/jena.tar.gz \
 && mkdir -p /opt/jena \
 && tar -xzf /tmp/jena.tar.gz -C /opt/jena --strip-components=1 \
 && rm /tmp/jena.tar.gz

# Set env vars
ENV JAVA_HOME=/opt/java/openjdk \
    JENA_HOME=/opt/jena \
    PATH="$JAVA_HOME/bin:$JENA_HOME/bin:$PATH"

# Workdir and app JAR
WORKDIR /fuseki
COPY fuseki-server.jar .

# Expose port & default command
EXPOSE 3030
CMD ["java", "-jar", "fuseki-server.jar", "--config", "/fuseki/run/config.ttl"]
