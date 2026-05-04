#!/bin/bash
# Move up one level to the root before building
cd ..
docker build -t muchtodo-backend:latest .