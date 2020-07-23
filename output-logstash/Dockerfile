FROM lakoo/docker-nginx-amplify

# fork from https://github.com/spujadas/elk-docker.git
MAINTAINER William Chong <williamchong@lakoo.com>
ENV REFRESHED_AT 2018-05-08


###############################################################################
#                                INSTALLATION
###############################################################################

RUN rm /etc/apt/sources.list.d/nginx-amplify.list

### install Filebeat

ENV FILEBEAT_VERSION 7.1.1


RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && dpkg -i filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && rm filebeat-${FILEBEAT_VERSION}-amd64.deb

###############################################################################
#                                    DATA
###############################################################################

### add dummy HTML file

COPY html /usr/share/nginx/html

### comment out unused configuration
RUN sed -i 's/output\.elasticsearch:/# output\.elasticsearch:/g' /etc/filebeat/filebeat.yml
RUN sed -i 's/hosts: \["elasticsearch:9200"\]/# hosts: \["elasticsearch:9200"\]/g' /etc/filebeat/filebeat.yml


###############################################################################
#                                    START
###############################################################################

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT ["/usr/local/bin/start.sh"]
