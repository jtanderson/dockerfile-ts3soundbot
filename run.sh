#!/bin/bash

rm -rf /tmp/.X*
rm -f /tmp/TS3*

cd /opt/ts3soundboard
LC_ALL="en_US.UTF-8" /usr/bin/xinit /opt/ts3soundboard/ts3bot -RunningAsRootIsEvilAndIKnowThat -- /usr/bin/Xvfb :1 -screen 0 800x600x16 -ac

