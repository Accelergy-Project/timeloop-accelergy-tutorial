#!/bin/sh

if [ ! -d /home/tutorial/exercises ]
then
   cp -r /usr/local/share/tutorial/exercises /home/tutorial
fi

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]
then
    # docker run bash -c 'echo hi'
    cd /home/tutorial
    exec bash "$@"
fi

cd /home/tutorial
exec "$@"

