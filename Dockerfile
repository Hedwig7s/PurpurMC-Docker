FROM eclipse-temurin:21-jre

# Exposing necessary ports
EXPOSE 25565/tcp
EXPOSE 8100/tcp

# Setting environment variables
ENV MC_VERSION=1.20.1 \
    MC_EULA=true \
    MC_RAM_XMS=1536M \
    MC_RAM_XMX=2048M

# Defining volume
VOLUME /home/server

# Switch to root for setup
USER root
WORKDIR /home/server

# Copy the main script
COPY src/main.sh /main.sh

# Install required packages and cleanup afterwards
RUN apt update &&\
    apt install -y curl findutils unar &&\
    rm -rf /var/lib/apt/lists/*

# Make the script executable
RUN chmod +x /main.sh

# Add new user for server execution
RUN adduser purpur

# Grant purpur user rwx permissions for /home/server
RUN chown -R purpur:purpur /home/server && chmod -R 777 /home/server

# Switch to the new user
USER purpur

# Define the entry point
CMD ["/main.sh"]
