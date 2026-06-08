#!/bin/bash

echo "========================================================="
echo "        STARTING AUTOMATED ARCHITECTURE DEMO             "
echo "========================================================="

# 1. Automatically extract dynamic AWS Load Balancer DNS names
echo ">>> Extracting ephemeral AWS Load Balancer endpoints..."
ORDER_HOST=$(kubectl get svc order-service -n toy-apps -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
BID_HOST=$(kubectl get svc bid-service -n toy-apps -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$ORDER_HOST" ] || [ -z "$BID_HOST" ]; then
    echo "ERROR: Cloud endpoints are not generated yet. Ensure your infrastructure is deployed."
    exit 1
fi

echo "Order Service Target: http://$ORDER_HOST"
echo "Bid Service Target:   http://$BID_HOST:8082"

# 2. Wait for AWS Network Load Balancers to finish cloud initialization
echo ">>> Verifying cloud route availability (this may loop a few times while AWS updates DNS)..."
until curl -s -o /dev/null --connect-timeout 2 "http://$ORDER_HOST/orders"; do
    echo "Waiting for AWS Network Load Balancer routes to propagate..."
    sleep 10
done
echo "Cloud routing paths online."

# 3. Drive the Producer Layer: Send secure Mock Order Event
echo -e "\n>>> STEP 1: Sending transaction event payload to Order Service..."
ORDER_RESPONSE=$(curl -s -X POST "http://$ORDER_HOST/orders" \
  -H "Authorization: ROLE_CUSTOMER" \
  -H "Content-Type: application/json" \
  -d '{"item": "enterprise-quantum-widget", "orderId": "1001"}')

echo "Order Service Response Context:"
echo "$ORDER_RESPONSE" | json_pp 2>/dev/null || echo "$ORDER_RESPONSE"

# 4. Wait for Kafka streaming and NoSQL persistence layers to sync
echo -e "\n>>> STEP 2: Allowing background event broker stream ingestion to settle..."
sleep 5

# 5. Drive the Consumer Layer: Fetch calculated metrics out of MongoDB Atlas
echo ">>> STEP 3: Querying calculated data metrics from Bid Service..."
METRICS_RESPONSE=$(curl -s "http://$BID_HOST:8082/metrics")

echo "Real-Time Aggregated NoSQL Metrics:"
echo "$METRICS_RESPONSE" | json_pp 2>/dev/null || echo "$METRICS_RESPONSE"

echo "========================================================="
echo "        AUTOMATED DEMO EXECUTION COMPLETE                "
echo "========================================================="
