FROM ubuntu

#VOLUME ["/tsmusic"]

ENV TSBOT_URL https://frie.se/ts3bot/sinusbot-0.9.8.tar.bz2
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.18.1/TeamSpeak3-Client-linux_amd64-3.0.18.1.run

# Download TS3 file and youtube-dl and extract it into /opt.
ADD https://yt-dl.org/downloads/2015.07.18/youtube-dl /opt/ts3soundboard/
RUN chmod 0755 /opt/ts3soundboard/youtube-dl
ADD ${TSBOT_URL} /opt/ts3soundboard/
RUN cd /opt/ts3soundboard && tar -xf /opt/ts3soundboard/sinusbot*.tar.bz2

ADD ${TEAMSPEAK_URL} /opt/ts3soundboard/
RUN cd /opt/ts3soundboard && chmod 0755 TeamSpeak3-Client-linux_amd64-3.0.18.1.run
RUN sed -i 's/^MS_PrintLicense$//' /opt/ts3soundboard/TeamSpeak3-Client-linux_amd64-3.0.18.1.run
RUN cd /opt/ts3soundboard && ./TeamSpeak3-Client-linux_amd64-3.0.18.1.run

# Install prerequisites
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install x11vnc xinit xvfb libxcursor1 libglib2.0-0 xorg openbox

# Copy the plugin and config into the client and update the bot
RUN cp /opt/ts3soundboard/plugin/libsoundbot_plugin.so /opt/ts3soundboard/TeamSpeak3-Client-linux_amd64/plugins
ADD config.ini /opt/ts3soundboard/config.ini
RUN /opt/ts3soundboard/ts3bot -RunningAsRootIsEvilAndIKnowThat -update

# Add a startup script
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 8087
CMD ["/run.sh"]
