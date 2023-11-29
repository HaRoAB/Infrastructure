 #!/bin/bash
 set -e
 
 # Wait for MongoDB to be ready
 for i in {1..30}; do
     if mongosh --host $MONGO_HOST --port $MONGO_PORT --eval "db.stats()" > /dev/null; then
         break
     fi
     echo "Waiting for MongoDB to start..."
     sleep 2
 done

 MONGO_CONNECTION_STRING="mongodb://$MONGO_HOST:$MONGO_PORT/all_your_database_are_belong_to_us"
 kubectl create configmap api-config --from-literal=env.MONGO_CONNECTION_STRING="$MONGO_CONNECTION_STRING" --dry-run=client -o yaml | kubectl apply -f -n fitnessappnamespace
 
 mongosh --host $MONGO_HOST --port $MONGO_PORT <<EOF
