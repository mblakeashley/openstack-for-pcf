#!/bin/bash
# Simple ping script to test host network
while getopts ":n:h:" opt; do
    case ${opt} in
        n)
          name=$OPTARG
          ;;
        h )
          host=$OPTARG
          ;;
        : )
          echo "Invalid option: $OPTARG requires an argument" 1>&2
          ;;
     esac
done


while true; do

      until ping -c 1 ${name}; do

            echo "Wating on ${host}, Sleeping for 1 minute.";
            sleep 1m
      done

      echo "... Can Ping ${host}!";
      exit 0
done
