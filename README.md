# TS3 Soundbot Dockerfile

This Dockerfile sets up a web-interface soundbot to connect to a Teamspeak 3 Client according to the instructions found [here](https://github.com/flyth/ts3soundbot/wiki/Installation---Debian-&-Ubuntu).

## Setup

1. Clone the Dockerfile: `git clone https://github.com/jtanderson/dockerfile-ts3soundbot.git`.
2. Next, build the image: `docker build -t mytsbot dockerfile-ts3soundbot`.
3. Finally, run it with a name and port exposure: `docker run -d --name ts3bot -p 8087:8087 mytsbot`
