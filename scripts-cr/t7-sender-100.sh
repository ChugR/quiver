#!/bin/bash

# Run t7-receiver-100.sh first to ensure empty output dir
# Use the same $1 for a common --output directory

odir=${1:-t7-100}
nmsgs=${2:-100}


quiver-arrow \
    --output ${odir} \
    --count ${nmsgs} \
    --settlement \
    send amqp://127.0.0.1:5672/examples
