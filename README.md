# dockerCDPS
Implementation of final scenario (pfinal) using docker-compose for learning purpose.

# Simplifications 
- Instead of NAS servers, we aim to use docker volumes.
- No FireWall conatainer will be set up. By carefully defining the internal networks docker itself publishes the expected iptables. We will have to take into account those ports being published to the external network (host) and only expose internally those that are not meant to be accessed from the outside, such us the database port (3306).

# Major problems encountered

