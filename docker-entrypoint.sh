#!/bin/sh

# Set UID/GID if not provided with enviromental variable(s).
if [ -z "$USER_UID" ]; then
	USER_UID=$(cat /etc/passwd | grep workspace | cut -d: -f3)
	echo "USER_UID variable not specified, defaulting to workspace user id ($USER_UID)"
fi

if [ -z "$USER_GID" ]; then
	USER_GID=$(cat /etc/group | grep workspace | cut -d: -f3)
	echo "USER_GID variable not specified, defaulting to workspace user group id ($USER_GID)"
fi

# Look for existing group, if not found create group "workspace" with specified GID.
FIND_GROUP=$(grep ":$USER_GID:" /etc/group)

if [ -z "$FIND_GROUP" ]; then
	usermod -g users workspace
	groupdel workspace
	groupadd -g $USER_GID workspace
fi

# Set "workspace" account's UID.
usermod -u $USER_UID -g $USER_GID --non-unique workspace > /dev/null 2>&1

# Populate "tutorial" directory, and
# change ownership of files in "tutorial" home
if [ ! -d /home/workspace/exercises ]
then
   cp -r /usr/local/src/timeloop-accelergy-exercises/exercises /home/workspace/
   cp -r /usr/local/src/timeloop-accelergy-exercises/baseline_designs /home/workspace/
   chown -R $USER_UID:$USER_GID /home/workspace/exercises
   chown -R $USER_UID:$USER_GID /home/workspace/baseline_designs
fi

# Set shorter prompt name if there is no custom setup in users' own directories
if [ ! -e /home/workspace/.bashrc ]
then
    cp /usr/local/src/.bashrc /home/workspace/.bashrc
fi

# Set default accelergy config file if there is no exsiting one
if [ ! -e /home/workspace/.config/accelergy/accelergy_config.yaml ]
then
    # create necessary directories
    if [ ! -e /home/workspace/.config ]
    then
        mkdir /home/workspace/.config
    fi
    # create necessary directories
    if [ ! -e /home/workspace/.config/accelergy ]
    then
        mkdir /home/workspace/.config/accelergy
    fi
    # infrastructure docker should already have the default config file ready in /usr/local/src
    cp /usr/local/src/accelergy_default_config.yaml /home/workspace/.config/accelergy/accelergy_config.yaml
fi

# Change owner/permissions on "workspace" home folder
chown $USER_UID:$USER_GID /home/workspace
chmod 755 /home/workspace

if [ ! -e /home/workspace/.nointro ]
then
    more /home/workspace/exercises/README.md
fi

# Default environment variable for Timeloop
export TIMELOOP_ACCURATE_READS_WITU=1

#if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]
if [ "$@" != "bash" ] 
then
    echo "Command: >>> $@ <<<"
    exec "$@"
fi

exec su workspace -s "/bin/bash" # -c "$@"
