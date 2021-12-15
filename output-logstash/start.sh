#!/bin/sh

# Variables
logstash_hosts=""
logstash_ca=""

# Launch nginx
echo "starting nginx ..."
nginx -g "daemon off;" &

nginx_pid=$!

test -n "${LOGSTASH_HOSTS}" && \
    logstash_hosts=${LOGSTASH_HOSTS}

test -n "${LOGSTASH_CA}" && \
    logstash_ca=${LOGSTASH_CA}

echo "starting filebeat ..."
filebeat modules enable nginx
if [ -n "${logstash_hosts}" ]; then
    if [ -n "${logstash_ca}" ]; then
        filebeat -E output.logstash.hosts="${logstash_hosts}" \
        -E output.logstash.ssl.enabled=true \
        -E output.logstash.ssl.certificate_authorities="${logstash_ca}" &
    else
        filebeat -E output.logstash.hosts="${logstash_hosts}" \
        -E output.logstash.ssl.enabled=false &
    fi
fi

wait ${nginx_pid}

echo "nginx master process has stopped, exiting."
