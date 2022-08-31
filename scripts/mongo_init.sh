#!/usr/bin/env sh

docker exec -it mongo mongosh --eval "rs.initiate({
 _id: \"mongoReplicaSet\",
 members: [
   {_id: 0, host: \"mongo\"},
   {_id: 1, host: \"mongo-1\"},
   {_id: 2, host: \"mongo-2\"}
 ]
})"

sleep 4
docker exec -it mongo mongosh --eval "rs.status()"
docker exec -it mongo-1 mongosh --eval "rs.status()"
docker exec -it mongo-2 mongosh --eval "rs.status()"

cat << EOF

SQL URL:      mongodb://mongo:Mongodb12345@localhost:27017/mongodb?retryWrites=true&w=majority

EOF