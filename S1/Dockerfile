FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y nmap && \
    apt-get install -y iputils-ping && \
    apt-get install -y net-tools netcat
     
RUN git clone https://github.com/CORE-UPM/quiz_2019.git

WORKDIR quiz_2019

RUN mkdir public/uploads

RUN apt-get install -y nodejs npm

RUN npm install && \
    npm install forever && \
    npm install mysql2

ENV QUIZ_OPEN_REGISTER=yes
ENV DATABASE_URL=mysql://quiz:xxxx@20.2.4.31:3306/quiz

WORKDIR /quiz_2019/views

RUN cat index.ejs | sed 's/.*Quiz.*/Quiz on S1./' > index2.ejs
RUN rm index.ejs
RUN mv index2.ejs index.ejs

WORKDIR /quiz_2019

# Copy script

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod 755 /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]

EXPOSE 3000

