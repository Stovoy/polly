#!/bin/bash -e

po() {
    eval "_po_$@"
}

_po_help() {
    echo "Usage: po <command>"
    echo "Commands:"
    echo "  help          Print this help dialog."
    echo "  reload        Reload po."
    echo "  env           Print docker env (used by 'po connect')."
    echo "  connect       Point docker to remote stevemostovoy.me host."
    echo "  disconnect    Point docker to local host."
    echo "  ssh           SSH into remote stevemostovoy.me host."
    echo "  shell         Open a shell into the running container."
    echo "  explore       Run a new container, skipping the entrypoint."
    echo "  build         Build the docker container."
    echo "  push          Push the docker image to the docker registry as latest."
    echo "  pull          Pull the latest images from the docker registry with docker-compose."
    echo "  attach        Launch the containers with docker-compose and attach to the output."
    echo "  all           Build and launch with attachment in one command."
    echo "  up            Launch the containers with docker-compose."
}

_po_reload() {
    source "$BASH_SOURCE"
}

_po_env() {
    docker-machine env stevemostovoy.me
}

_po_connect() {
	eval $(docker-machine env stevemostovoy.me)
}

_po_disconnect() {
    unset DOCKER_TLS_VERIFY
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset DOCKER_MACHINE_NAME
    unset DOCKER_API_VERSION
}

_po_ssh() {
    docker-machine ssh stevemostovoy.me "$@"
}

_po_shell() {
    docker exec -it $(docker-compose ps -q stevemostovoy.me) sh
}

_po_explore() {
    docker run -it --entrypoint sh stevemostovoy.me
}

_po_build() {
    docker build -t stevemostovoy/stevemostovoy.me .
}

_po_push() {
    _po_ssh docker push stevemostovoy/stevemostovoy.me
}

_po_pull() {
    docker-compose pull
}

_po_attach() {
    docker-compose up
}

_po_all() {
    _po_build
    _po_attach
}

_po_up() {
    docker-compose up -d
}

export -f po
export -f _po_help
export -f _po_reload
export -f _po_connect
export -f _po_disconnect
export -f _po_ssh
export -f _po_shell
export -f _po_explore
export -f _po_build
export -f _po_push
export -f _po_pull
export -f _po_attach
export -f _po_up
export -f _po_all

echo "polly cli loaded. Use 'po help' for info."
