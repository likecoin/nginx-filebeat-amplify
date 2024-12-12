docker buildx build -t nginx-filebeat-logstash:latest . --platform linux/amd64
docker tag nginx-filebeat-logstash:latest us.gcr.io/likecoin-foundation/nginx-filebeat-logstash:latest
docker -- push us.gcr.io/likecoin-foundation/nginx-filebeat-logstash:latest
