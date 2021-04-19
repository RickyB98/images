#!/bin/bash
cd /home/container

# Output Current Java Version
java -version

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

DEPLOY_FILE=deploy.conf

if test -f "$DEPLOY_FILE"; then
    if grep -q DEPLOY_ON $DEPLOY_FILE; then
        if ! command -v npm &> /dev/null; then
            # Install curl, git and node
            apt update
            apt install -y curl
            curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
            apt update
            apt install -y jq git gcc g++ make
            apt install nodejs
            npm install npm@7.10.0 -g
        fi
        MODIFIED_DEPLOY=`eval echo $(echo ${DEPLOY} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
        # Run deployment script
        eval ${MODIFIED_DEPLOY}
    fi
    if ! grep -q ALWAYS $DEPLOY_FILE; then
        echo 'DEPLOY_OFF' > $DEPLOY_FILE
    fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
