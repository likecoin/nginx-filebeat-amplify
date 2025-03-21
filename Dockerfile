FROM nginx:1.26.3

# fork from https://github.com/spujadas/elk-docker.git
MAINTAINER William Chong <williamchong@like.co>
ENV REFRESHED_AT 2021-12-14


###############################################################################
#                                INSTALLATION
###############################################################################

RUN rm /etc/apt/sources.list.d/nginx-amplify.list

### install Filebeat

ENV FILEBEAT_VERSION 7.17.28


RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

# Keep the nginx logs inside the container
RUN unlink /var/log/nginx/access.log \
    && unlink /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && touch /var/log/nginx/error.log \
    && chown nginx /var/log/nginx/*log \
    && chmod 644 /var/log/nginx/*log

# Copy nginx stub_status config
COPY ./conf.d/stub_status.conf /etc/nginx/conf.d

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && dpkg -i filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && rm filebeat-${FILEBEAT_VERSION}-amd64.deb

###############################################################################
#                                    DATA
###############################################################################

### add dummy HTML file

COPY html /usr/share/nginx/html


###############################################################################
#                                    START
###############################################################################

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
