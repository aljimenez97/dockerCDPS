# dockerCDPS
Implementation of final scenario (pfinal) using docker-compose for learning purpose.
![alt scenario](https://github.com/aljimenez97/dockerCDPS/blob/master/github-resources/scenario.png)
Source: *Práctica Final: Despliegue de una aplicación escalable (CDPS 2018-2019)*

Related repos:
https://github.com/CORE-UPM/quiz_2019

## Simplifications 
- Instead of NAS servers, we aim to use docker native **volumes**.
- **No FireWall container will be set up**. By carefully defining the internal networks Docker itself publishes the expected *iptables*. We will have to take into account those ports being published to the external network (host) and only expose internally those that are not meant to be accessed from the outside, such us the database port (3306).

## Install 
Please note that if you aim to run the scenario in an OS such as Windows or macOS you will need to install Docker Desktop first (it includes *docker-compose*). You can find instructions on how to install *docker-compose* in the following link https://docs.docker.com/compose/install/

Once *docker-compose* is installed:
```
git clone https://github.com/aljimenez97/dockerCDPS.git
cd dockerCDPS
docker-compose up
```
It will take a while for the last command to finish. Once it does, the service should be running. The easiest way to check it is browsing http://localhost:3000, for we defined in the compose file that the service would map the internal port 80 of the load balancer to port 3000 of the host machine. 
![alt safari](https://github.com/aljimenez97/dockerCDPS/blob/master/github-resources/safari.png)

Another alternative is to access the service through Docker container *c1* (client)
 ```
docker exec -it c1 /bin/bash
```
Once the new prompt appears:
 ```
curl 20.2.0.1
```
Note that 20.2.0.1 corresponds to the interface of the load balancer the client has access to. The following is the expected output of the command:
![alt curl output](https://github.com/aljimenez97/dockerCDPS/blob/master/github-resources/curl.png)

## Major problems encountered
### Synchronization of containers
Some processes depend on the state of others. For instance, our servers cannot populate the database if the latter is not initialized and running on the expected port. Another case is the load balancing service, which needs to wait for the quiz servers to be ready in order to initialize.
In these cases we need to verify that some containers are running and that the services needed are available. 

**Container synchronization** is achieved by adding *depends_on* tags on the docker compose file. For instance, in the LB example:
```
lb:
    build: ./LB  #use local version
    container_name: "lb"
    ports:
      - "3000:80"
    depends_on:
      - s1
      - s2
      - s3
      - s4
```
This will load the quiz server containers before launching the load balancer.

**Service synchronization** is achieved by running checking scripts as entrypoints of those containers that need a service to work. For instance, the quiz server Dockerfile defines: 
```
# Copy script
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod 755 /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
```

And the content of that script is
```
#!/bin/bash

echo "ENTRYPOINT"
until nc -z -v -w30 20.2.4.31 3306 > /dev/null 2>&1
do
	echo "Waiting for db connection..."
	sleep 2
done

echo "is working"

npm run-script migrate_cdps
npm run-script seed_cdps
npm run-script start_old
```
It ensures the database is reachable and running and after that migrates and seeds it and it finally starts the server.

### Docker ephemeral philosophy 
Docker containers are designed to be ephemeral. This implies that they can be stopped and destroyed and then substituted by another container. In the case of our Dockerfiles, we noticed that some machines, such as the clients, exited as soon as *docker-compose up* command finished. This was due to the lack of an *ENTRYPOINT* or *CMD* being executed in the foreground that kept the machine running. **This is Docker expected behaviour**. We forced the client container to keep running by adding a *sleep* command in the Dockerfile
```
CMD sleep 100000000000000000000
```
Please note **this is not a propper solution** but still works for testing purposes

### Storage service
In an attempt to simplify the project structure, we have substituted the NAS system by the use od Docker native volumes. The counterpart is that we have no storage replication. This might be further researched in the future.
The advantage of docker volumes is its simplicity. We just define the volume in the *compose* file:
```
volumes:
  nas:
```
And then specify the route of the volume in the containers that will use it. For example:
```
s4:
    build: ./S4  #use local version
    container_name: "s4"
    networks:
      lb-server:
        ipv4_address: "20.2.3.14"
      server-bd:
        ipv4_address: "20.2.4.14"
    volumes:
      - nas:/quiz_2019/public/uploads 
```
