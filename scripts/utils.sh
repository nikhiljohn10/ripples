is_true() {
    test "$1" = "true" && return 0
    return 1
}

is_empty() {
    test -z "$1" && return 0
    return 1
}

error_exit() {
    is_empty "$1" && echo "$1"
    exit 1
}

read_user() {
    echo -n "Username: "
    read USERNAME
}

read_pass() {
    echo -n "Password: "
    read -s PASSWORD
    echo -ne "\033[2K\r"
}

is_container_running() {
    if is_empty "$1"; then
        echo -n "Container name: "
        read CONTAINER_NAME
    else
        CONTAINER_NAME=$1
    fi
    is_empty $(docker ps -q -f name="$CONTAINER_NAME") && \
        return 1
    return 0
}

check_ca_health() {
    # Usage: check_ca_health [conatiner_name] [-v]
    CONTAINER_NAME=""
    if test "$1" = "-v"; then 
        if is_empty "$2"; then
            CONTAINER_NAME="${2:-stepca}";
        fi
    else
        if is_empty "$1"; then
            CONTAINER_NAME="${1:-stepca}";
        fi
    fi
    STATUS=$(docker exec $CONTAINER_NAME curl -sk https://ca:9000/health 2>/dev/null)
    !(test "$STATUS" = "{\"status\":\"ok\"}") && \
        return 1
    test "$2" = "-v" -o "$1" = "-v" && echo "$STATUS"
    return 0
}

prune() {
    # Usage: prune [-i]
    docker volume prune --force
    docker network prune --force
    test "$1" = "-i" && docker image prune -a --force
}

compose_down() {
    # Usage: compose_down [compose_project_name]
    if !(test -d "./$1"); then
        echo "$1 is not a directory in the current folder"
        return 1
    fi
    compose_file="$(pwd)/$1/docker-compose.yml"
    if test -f $compose_file; then
        docker compose -f "$compose_file" down && echo "$1 is down" || \
        echo "Failed to take down $1"
    fi
}
