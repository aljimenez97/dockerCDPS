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
 Another alternative is to access the service through Docker container *c1* (client)
## Major problems encountered
- **Synchronization of containers**. Some processes depend on the state of others. For instance, our servers cannot populate the database if the latter is not initialized and running on the expected port. Another case is the load balancing service, which needs to wait for the quiz servers to be ready in order to initialize.
- **Docker ephemeral philosophy**. Docker containers are designed to be ephemeral. This implies that they can be stopped and destroyed and then substituted by another container. In the case of our Dockerfiles, we noticed that some machines, such as the clients, exited as soon as *docker-compose up* command finished. This was due to the lack of an *ENTRYPOINT* or *CMD* being executed in the foreground that kept the machine running. **This is Docker expected behaviour**. We forced the client container to keep running by adding a *sleep* command in the Dockerfile
