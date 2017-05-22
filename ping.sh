#!/bin/bash
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

if ! ping -c 1 ${name}
     then
         echo "Wating on ${host}, sleep for 2 minutes";
         sleep 2m
else
     echo "${host} is ready!";
     exit 0
fi
