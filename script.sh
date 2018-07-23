#!/bin/bash

user=

#commands to execute separated by semicolon
commands="touch test;touch test1"

for host in $(cat hosts)
	do ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l "$user" "$host" "$commands">output.$host
done
