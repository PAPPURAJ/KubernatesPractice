#!/bin/bash

# Script to check Spring Boot Actuator endpoints
# Make sure the application is running on port 8083 before executing this script

echo "Checking Spring Boot Actuator Endpoints"
echo "======================================="
echo

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl to run this script."
    exit 1
fi

# Base URL for actuator endpoints
BASE_URL="http://localhost:8083/actuator"

# Function to make a curl request and format the output
check_endpoint() {
    local endpoint=$1
    local description=$2
    
    echo "Checking $description ($endpoint)..."
    response=$(curl -s "$BASE_URL/$endpoint")
    
    # Check if the response is valid JSON
    if echo "$response" | jq . &> /dev/null; then
        echo "$response" | jq .
    else
        echo "$response"
    fi
    echo "----------------------------------------"
    echo
}

# Check if the application is running
echo "Checking if the application is running..."
if curl -s "$BASE_URL" > /dev/null; then
    echo "Application is running and actuator is accessible."
else
    echo "Error: Cannot connect to $BASE_URL"
    echo "Make sure the application is running on port 8083."
    exit 1
fi
echo "----------------------------------------"
echo

# Check available endpoints
echo "Available Actuator Endpoints:"
curl -s "$BASE_URL" | jq ._links
echo "----------------------------------------"
echo

# Check specific endpoints
check_endpoint "health" "Health Status"
check_endpoint "info" "Application Info"
check_endpoint "metrics" "Available Metrics"
check_endpoint "metrics/jvm.memory.used" "JVM Memory Usage"
check_endpoint "env" "Environment Variables"
check_endpoint "beans" "Spring Beans"
check_endpoint "mappings" "Request Mappings"

echo "Actuator check completed."
echo "For more details, refer to the ActuatorGuide.md file."