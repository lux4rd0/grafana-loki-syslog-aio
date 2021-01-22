#FROM alpine:3.12
FROM centos:7
RUN yum update -y
RUN yum install -y nc
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "10", "500" ]
