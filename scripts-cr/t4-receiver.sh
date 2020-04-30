#!/bin/bash

# Run t4-receiver.sh first; then run t4-sender.sh.
# Use the same $1 for a common --output directory

odir=${1:-lr}

if [ -d ${odir} ]
then
    echo "directory ${odir} already exists. Delete it and rerun this script."
    exit 1
fi

quiver-arrow             \
    --output ${odir} \
    --count 4000 \
    --settlement \
    --timeout 120000 \
    receive  amqp://127.0.0.1:5674/examples
    
