 #!/bin/bash

# Check if the container 'mydb1' exists and stop it if it does
if [ "$(docker ps -aq -f name=csv-loader)" ]; then
    echo "Stopping existing container 'csv-loader'..."
    docker stop csv-loader
fi

# Check if the container 'mydb1' exists and remove it if it does
if [ "$(docker ps -aq -f name=csv-loader)" ]; then
    echo "Removing existing container 'csv-loader'..."
    docker rm -f csv-loader
fi

# Build the Docker image
echo "Building the Docker image 'db2-csv-loader'..."
docker build -t db2-csv-loader .

# Run the Docker container
echo "Running the Docker container 'csv-loader'..."
docker run -itd --name csv-loader --privileged=true -p 50000:50000 \
-e LICENSE=accept \
-e DB2INST1_PASSWORD=admin1234 \
-e DBNAME=testdb1 \
db2-csv-loader
