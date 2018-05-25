FROM wumvi/nginx.prod
MAINTAINER Vitaliy Kozlenko <vk@wumvi.com>

ADD conf/prom.gate.conf /www/conf/

EXPOSE 9130
