# STAGE 1: Build
FROM golang:1.25-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git

# Set the working directory
WORKDIR /app

# Copy the go.mod and go.sum from their specific location to the root of /app
COPY much-to-do/Server/MuchToDo/go.mod much-to-do/Server/MuchToDo/go.sum ./

# Download dependencies
RUN go mod download

# Copy the ENTIRE project into /app
COPY . .
COPY .env .env

# Change working directory to where the go.mod is actually located
# This is the "magic" fix so Go recognizes the local packages
WORKDIR /app/much-to-do/Server/MuchToDo

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./cmd/api/main.go

# STAGE 2: Run
FROM alpine:latest
# Add curl for the health check
RUN apk add --no-cache curl
RUN adduser -D staticuser
USER staticuser
WORKDIR /home/staticuser/

# Copy the binary we built in the first stage
COPY --from=builder /app/main .

# ADD THIS LINE: Copy the .env file so config.LoadConfig(".") can find it
COPY --from=builder /app/.env .

# Environment defaults
ENV SERVER_PORT=8080

EXPOSE 8080

# Implementation of the required health check[cite: 1]
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["./main"]