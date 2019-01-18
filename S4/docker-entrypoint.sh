#!/bin/bash

echo "ENTRYPOINT"
until nc -z -v -w30 20.2.4.31 3306 > /dev/null 2>&1
do
	echo "Waiting for db connection..."
	sleep 2
done

echo "is working"


npm run-script start_old