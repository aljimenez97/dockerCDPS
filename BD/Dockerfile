FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y iputils-ping && \
    apt-get install -y systemd && \
    apt-get install -y net-tools 

RUN apt update && \
    apt -y install mariadb-server

RUN sed -i -e 's/bind-address.*/bind-address=0.0.0.0/' -e 's/utf8mb4/utf8/' /etc/mysql/mariadb.conf.d/50-server.cnf

RUN service mysql restart && \
    mysqladmin -u root password xxxx && \
    mysql -u root --password='xxxx' -e "CREATE USER 'quiz' IDENTIFIED BY 'xxxx';" && \
    mysql -u root --password='xxxx' -e "CREATE DATABASE quiz;" && \
    mysql -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* TO 'quiz'@'localhost' IDENTIFIED by 'xxxx';" && \
    mysql -u root --password='xxxx' -e "GRANT ALL PRIVILEGES ON quiz.* TO 'quiz'@'%' IDENTIFIED by 'xxxx';" && \
    mysql -u root --password='xxxx' -e "FLUSH PRIVILEGES;"

EXPOSE 3306

