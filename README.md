# dockerCDPS
Implementation of final scenery using docker-compose

# Simplifications 
- We are implementing just one server for now
- Instead of NAS servers, we aim to use docker volumes.

# Achievements
- Topology network has been defined in docker-compose file, as so have been lb, fw, s1, bd and c1 machines.
- s1 container waits for database to be ready, but migrating and seeding are just working by manually execution (docker-compose run s1 npm run-script migrate_cdps)
- bd does not stop after execution of Dockerfile (we had trouble with Docker ephemeral philosophy in this respect)
# To Do
