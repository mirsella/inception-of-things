#!/bin/bash

# Healthcheck -> just checking when the page is requestable

i=0

while [ -z "$(curl -s 127.0.0.1)" ]
do
	echo "Page not up: $i second(s)"
	i=$((i+1))
	sleep 1
done

echo "Page Up!"

exit 0