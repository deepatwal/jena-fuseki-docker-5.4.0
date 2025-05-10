# Use official Eclipse Temurin JDK base image
ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-alpine

ARG JENA_VERSION=5.4.0
ARG REPO=https://repo1.maven.org/maven2

# Install curl to fetch Jena CLI tools
RUN apk add --no-cache curl

# Download and extract Apache Jena CLI tools into /opt/jena
RUN curl -fSL "${REPO}/org/apache/jena/apache-jena/${JENA_VERSION}/apache-jena-${JENA_VERSION}.tar.gz" -o /tmp/jena.tar.gz && \
    mkdir -p /opt/jena && \
    tar -xzf /tmp/jena.tar.gz -C /opt/jena --strip-components=1 && \
    rm /tmp/jena.tar.gz

# Set environment variables for Jena
ENV JAVA_HOME=/opt/java/openjdk \
    JENA_HOME=/opt/jena \
    PATH="/opt/java/openjdk/bin:$JENA_HOME/bin:$PATH"

# Set working directory for Fuseki server
WORKDIR /fuseki

# Copy Fuseki server JAR from local context into container
COPY fuseki-server.jar .

# Expose Fuseki server port
EXPOSE 3030

# Default command to run Fuseki server
CMD ["java", "-jar", "fuseki-server.jar"]
