#!/bin/bash

#
# start.bash
#

PIDFILE="/var/run/haproxy.pid"

echo "Setting up LB"

until nc -z -v -w30 20.2.3.11 3000 > /dev/null 2>&1
do
	echo "Waiting for S1 connection..."
	sleep 2
done

echo "S1 ON"

until nc -z -v -w30 20.2.3.12 3000 > /dev/null 2>&1
do
	echo "Waiting for S1 connection..."
	sleep 2
done

echo "S2 ON"

until nc -z -v -w30 20.2.3.13 3000 > /dev/null 2>&1
do
	echo "Waiting for S1 connection..."
	sleep 2
done

echo "S3 ON"

until nc -z -v -w30 20.2.3.14 3000 > /dev/null 2>&1
do
	echo "Waiting for S1 connection..."
	sleep 2
done

echo "S4 ON"
exec haproxy -d -f /etc/haproxy/haproxy.cfg
