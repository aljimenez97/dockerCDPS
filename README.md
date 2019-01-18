# dockerCDPS
Implementation of final scenario (pfinal) using docker-compose for learning purpose.

## Simplifications 
- Instead of NAS servers, we aim to use docker native **volumes**.
- **No FireWall container will be set up**. By carefully defining the internal networks Docker itself publishes the expected *iptables*. We will have to take into account those ports being published to the external network (host) and only expose internally those that are not meant to be accessed from the outside, such us the database port (3306).

## Major problems encountered
- **Synchronization of containers**. Some processes depend on the state of others. For instance, our servers cannot populate the database if the latter is not initialized and running on the expected port. Another case is the load balancing service, which needs to wait for the quiz servers to be ready in order to initialize.
- **Docker ephemeral philosophy**. Docker containers are designed to be ephemeral. This implies that they can be stopped and destroyed and then substituted by another container. In the case of our Dockerfiles, we noticed that some machines, such as the clients, exited as soon as *docker-compose up* command finished. This was due to the lack of an *ENTRYPOINT* or *CMD* being executed in the foreground that kept the machine running. **This is Docker expected behaviour**. We forced the client container to keep running by adding a *sleep* command in the Dockerfile
