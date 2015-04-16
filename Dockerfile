FROM ubuntu

#VOLUME ["/tsmusic"]

ENV TSBOT_URL http://frie.se/ts3bot/ts3soundboardbot-0.9.5.tar.bz2
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.16/TeamSpeak3-Client-linux_amd64-3.0.16.run

# Download TS3 file and extract it into /opt.
ADD ${TSBOT_URL} /opt/
RUN cd /opt && tar -xf /opt/ts3soundboardbot*.tar.bz2

ADD ${TEAMSPEAK_URL} /opt/ts3soundboard/
RUN cd /opt/ts3soundboard && chmod 0755 TeamSpeak3-Client-linux_amd64-3.0.16.run
RUN sed -i 's/^MS_PrintLicense$//' /opt/ts3soundboard/TeamSpeak3-Client-linux_amd64-3.0.16.run
RUN cd /opt/ts3soundboard && ./TeamSpeak3-Client-linux_amd64-3.0.16.run

# Install prerequisites
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install x11vnc xinit xvfb libxcursor1 libglib2.0-0 xorg openbox

# Copy the plugin into the client and update the bot
RUN cp /opt/ts3soundboard/libsoundbot_plugin.so /opt/ts3soundboard/TeamSpeak3-Client-linux_amd64/plugins
RUN /opt/ts3soundboard/ts3bot -update

# Add a startup script
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 8087
CMD ["/run.sh"]

