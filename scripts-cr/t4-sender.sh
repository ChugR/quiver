#!/bin/bash

# Run t4-receiver.sh first to ensure empty output dir
# Use the same $1 for a common --output directory

odir=${1:-lr}

quiver-arrow \
    --output ${odir} \
    --count 4000 \
    --settlement \
    send amqp://127.0.0.1:5672/examples
