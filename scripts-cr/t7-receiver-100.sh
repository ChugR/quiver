#!/bin/bash

# Run t7-receiver-100.sh first; then run t7-sender-100.sh.
# Use the same $1 for a common --output directory

odir=${1:-t7-100}
nmsgs=${2:-100}

if [ -d ${odir} ]
then
    echo "directory ${odir} already exists. Delete it and rerun this script."
    exit 1
fi

quiver-arrow             \
    --output ${odir} \
    --count ${nmsgs} \
    --settlement \
    --timeout 120000 \
    receive  amqp://127.0.0.1:5676/examples
    
