FROM ubuntu

#VOLUME ["/tsmusic"]

#ENV TSBOT_URL http://frie.se/ts3bot/
ENV TSBOT_URL https://www.sinusbot.com/dl/
#ENV TSBOT_FILE sinusbot-0.9.8.tar.bz2
ENV TSBOT_FILE sinusbot-beta.tar.bz2
#ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.18.2/
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.19.4/
ENV TEAMSPEAK_FILE TeamSpeak3-Client-linux_amd64-3.0.19.4.run

# Download TS3 file and extract it into /opt.
ADD ${TSBOT_URL}${TSBOT_FILE} /opt/
RUN mkdir /opt/ts3soundboard
RUN cd /opt && tar -xf /opt/${TSBOT_FILE} -C /opt/ts3soundboard
RUN rm /opt/${TSBOT_FILE}

ADD ${TEAMSPEAK_URL}${TEAMSPEAK_FILE} /opt/ts3soundboard/
RUN cd /opt/ts3soundboard && chmod 0755 ${TEAMSPEAK_FILE}
RUN sed -i 's/^MS_PrintLicense$//' /opt/ts3soundboard/${TEAMSPEAK_FILE}
RUN cd /opt/ts3soundboard && ./${TEAMSPEAK_FILE}

# Install prerequisites
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install x11vnc xinit xvfb libxcursor1 libglib2.0-0 xorg openbox qt5-default

# Copy the plugin into the client and update the bot
RUN cp /opt/ts3soundboard/plugin/libsoundbot_plugin.so /opt/ts3soundboard/TeamSpeak3-Client-linux_amd64/plugins
RUN cp /opt/ts3soundboard/config.ini.dist /opt/ts3soundboard/config.ini
#RUN cd /opt/ts3soundboard && ./ts3bot -update -RunningAsRootIsEvilAndIKnowThat

# Add a startup script
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 8087
CMD ["/run.sh"]

