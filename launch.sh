start() {
    echo "Launching..."
    local image_name

    echo "Creating network..."
    docker network create messaging

    echo "Starting rabbitMQ..."
    docker run -d --name rabbitMQ --network=messaging -p 5672:5672 -p 15672:15672 rabbitmq:3-management
    # docker run -v rabbitmq_data:/bitnami/rabbitmq/mnesia -p 4369:4369 -p 5551:5551 -p 5552:5552 -p 5672:5672 -p 25672:25672 -p 15672:15672 -e RABBITMQ_SECURE_PASSWORD=yes -e RABBITMQ_LOGS=- docker.io/bitnami/rabbitmq:3.12

    echo "Building client..."
    image_name=$(docker build -t messaging/client -q ./client | sed 's/.*://')
    echo "Starting client..."
    docker run -d --name client --network=messaging -p 8080:8080 $image_name

    echo "Building service..."
    image_name=$(docker build -t messaging/service -q ./service | sed 's/.*://')
    echo "Starting service..."
    docker run -d --name service --network=messaging -p 8081:8080 $image_name
}

stop() {
    echo "Stopping..."
    docker stop client service rabbitMQ
    echo "Removing..."
    docker rm client service rabbitMQ
    echo "Removing network..."
    docker network rm messaging
}
if [ -z "$1" ]; then
    echo 'Nope'
    exit 1
fi
case "$1" in
'stop') stop ;;
*) start ;;
esac
