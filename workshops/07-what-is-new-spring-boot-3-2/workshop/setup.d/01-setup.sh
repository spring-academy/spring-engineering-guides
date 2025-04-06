#!/bin/bash
set -e

# Creating the bin
mkdir -p /home/eduk8s/bin/

# Installing SDKman
curl -s "https://get.sdkman.io" | bash
source "/home/eduk8s/.sdkman/bin/sdkman-init.sh"

# Profile
# Note: Eventhough this is tru, it seems the terminal on educates never executes the .bash_profile
echo "source /home/eduk8s/.sdkman/bin/sdkman-init.sh" >> ~/.bash_profile
