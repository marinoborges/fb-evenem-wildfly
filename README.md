# fb-evenem-wildfly
``
docker build -t fb-evenem-wildfly .
``

``
docker service create --name fb-evenem-wildfly -p 8080:8080 --network traefik_overlay --host fb-evenem-postgresql.host:172.30.0.7 --replicas=2 --reserve-memory=2100MB fb-evenem-wildfly
``

``
docker run -d --name fb-evenem-wildfly --add-host fb-evenem-postgresql.host:172.30.0.7 -p 8080:8080 -it fb-evenem-wildfly
``
