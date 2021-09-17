
## grafana-loki-syslog-aio

<center><img src="https://github.com/lux4rd0/grafana-loki-syslog-aio/blob/main/loki_syslog_aio.png"></center>

## About The Project

This Loki Syslog All-In-One example is geared to help you get up and running quickly with a Syslog ingestor and visualization of logs. It uses [Grafana Loki](https://grafana.com/oss/loki/) and Promtail as a receiver for forwarded syslog-ng logs. I wrote an [introductory blog post](https://labs.lux4rd0.com/2021/01/oldskool-syslog-meets-newskool-loki/) about how this AIO project came about as well (pesky intermittent network issues!!) 

<center><img src="https://github.com/lux4rd0/grafana-loki-syslog-aio/blob/main/loki_syslog_aio_overview_sized.png"></center>

*Note that this All In One is geared towards getting network traffic from legacy syslog (RFC3164 UDP port 514) into Loki via [syslog-ng](https://www.syslog-ng.com/) and [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/).*

Essentially:

> RFC3164 Network/Compute Devices -> syslog-ng (UDP port 514) ->
> Promtail (port 1514) -> Loki (port 3100) <- Grafana (port 3000)

## Getting Started

The project is built around a pre-configured Docker stack of the following:

 - [Grafana](https://grafana.com/oss/grafana/)
 - [Grafana Loki](https://grafana.com/oss/loki/) (configured for [MinIO](https://min.io/))
 - [Grafana Promtail](https://grafana.com/docs/loki/latest/clients/promtail/)
 - [syslog-ng](https://www.syslog-ng.com/)

The stack has been extended to include pre-configured monitoring with:

- [Prometheus](https://grafana.com/oss/prometheus/)
- [Node-Exporter](https://github.com/prometheus/node_exporter)
- [cAdvisor](https://github.com/google/cadvisor)

A simple Syslog generator is included based on Vicente Zepeda Mas's [random-logger](https://github.com/chentex/random-logger) project.

## Prerequisites

- [Docker](https://docs.docker.com/install)
- [Docker Compose](https://docs.docker.com/compose/install)

## Using

This project is built and tested on Linux CentOS 7. To get started, download the code from this repository and extract it into an empty directory. For example:

    wget https://github.com/lux4rd0/grafana-loki-syslog-aio/archive/main.zip
    unzip main.zip
    cd grafana-loki-syslog-aio-main
    
From that directory, run the docker-compose command:

**Full Example Stack:** Grafana, Loki with s3/MinIO, Promtail, syslog-ng, Prometheus, cAdvisor, node-exporter

    docker-compose -f ./docker-compose.yml up -d

This will start to download all of the needed application containers and start them up. 

*(Optional docker-compose configurations are listed under **Options** below)*

**Grafana Dashboards**

Once all of the docker containers are started up, point your Web browser to the Grafana page, typically http://hostname:3000/ - with hostname being the name of the server you ran the docker-compose up -d command on. The "Loki Syslog AIO - Overview" dashboard is defaulted without having to log in.

*Note: this docker-compose stack is designed to be as easy as possible to deploy and go. Logins have been disabled, and the default user has an admin role. This can be changed to an Editor or Viewer role by changing the Grafana environmental variable in the docker-compose.yml file to:*

    GF_AUTH_ANONYMOUS_ORG_ROLE: Viewer
    
**Getting Started With Loki**

Here are some additional resources you might find helpful if you're just getting started with Loki:

- [Getting started with Grafana and Loki in under 4
   minutes](https://grafana.com/go/webinar/loki-getting-started/)
- [An (only slightly technical) introduction to Loki](https://grafana.com/blog/2020/05/12/an-only-slightly-technical-introduction-to-loki-the-prometheus-inspired-open-source-logging-system/)
- [Video tutorial: Effective troubleshooting queries with Grafana
   Loki](https://grafana.com/blog/2021/01/07/video-tutorial-effective-troubleshooting-queries-with-grafana-loki/)

## Stack Options:

A few other docker-compose files are also available:

**Full Example Stack with Syslog Generator:** Grafana, Loki with s3/MinIO, Promtail, syslog-ng, Prometheus, cAdvisor, node-exporter, Syslog Generator

    docker-compose -f ./docker-compose-with-generator.yml up -d

**Example Stack without monitoring or Syslog generator**: Grafana, Loki with s3/MinIO, Promtail, syslog-ng

    docker-compose -f ./docker-compose-without-monitoring.yml up -d

**Example Stack without MinIO, monitoring, or Syslog generator:** Grafana, Loki with the filesystem, Promtail, syslog-ng

    docker-compose -f ./docker-compose-filesystem.yml up -d

The *Syslog Generator* configuration will need access to the Internet to do a local docker build from the configurations location in ./generator. It'll provide some named hosts and random INFO, WARN, DEBUG, ERROR logs sent over to syslog-ng/Loki.

<center><img src="https://github.com/lux4rd0/grafana-loki-syslog-aio/blob/main/loki_syslog_aio_overview_generator_sized.png"></center>

## Configuration Review:

The default Loki storage configuration docker-compose.yml uses S3 storage with MinIO. If you want to use the filesystem instead, use the different docker-compose configurations listed above or change the configuration directly. An example would be:

    volumes:
    - ./config/loki-config-filesystem.ym:/etc/loki/loki-config.yml:ro

**Changing MinIO Keys**

The MinIO configurations default the Access Key and Secret Key at startup. If you want to change them, you'll need to update two files:

./docker-compose.yml

      MINIO_ACCESS_KEY: minio123
      MINIO_SECRET_KEY: minio456
      
./config/loki-config-s3.yml

     aws:
      s3: s3://minio123:minio456@minio.:9000/loki

## Changed Default Configurations In syslog-ng and Promtail

To set this example All In One project up, the following configurations have been added to the docker-compose.yml. If you already have syslog-ng running on your deployment server - make similar changes below and comment out the docker container stanza.

#### SYSLOG-NG CONFIGURATION (docker container listens on port 514)

**# syslog-ng.conf**

    source s_local {
        internal();
    };
    
    source s_network {
        default-network-drivers(
        );
    };
    
    destination d_loki {
        syslog("promtail" transport("tcp") port("1514"));
    };
    
    log {
            source(s_local);
            source(s_network);
            destination(d_loki);
    };

> Note: the above "`promtail`" configuration for `destination d_loki` is
> the *hostname* where Promtail is running. Is this example, it happens
> to be the Promtail *docker container* name that I configured for the
> All-In-One example.

#### PROMTAIL CONFIGURATION (docker container listens on port 1514)

 **# promtail-config.yml**

    server:
      http_listen_port: 9080
      grpc_listen_port: 0
    
    positions:
      filename: /tmp/positions.yaml
    
    clients:
      - url: http://loki:3100/loki/api/v1/push
    
    scrape_configs:
    
    - job_name: syslog
      syslog:
        listen_address: 0.0.0.0:1514
        idle_timeout: 60s
        label_structured_data: yes
        labels:
          job: "syslog"
      relabel_configs:
        - source_labels: ['__syslog_message_hostname']
          target_label: 'host'

## Contributing

Contributions make the open source community such a fantastic place to learn, inspire, and create. Any contributions you make are greatly appreciated.

- Fork the Project
- Create your Feature Branch (git checkout -b feature/AmazingFeature)
- Commit your Changes (git commit -m 'Add some AmazingFeature')
- Push to the Branch (git push origin feature/AmazingFeature)
- Open a Pull Request

## Contact

Dave Schmid - [@lux4rd0](https://twitter.com/lux4rd0) - dave@pulpfree.org

Project Link: https://github.com/lux4rd0/grafana-loki-syslog-aio

## Acknowledgements

- Grafana Labs - https://grafana.com/
- Grafana Loki - https://grafana.com/oss/loki/
- Grafana - https://grafana.com/oss/grafana/
- syslog-ng - https://www.syslog-ng.com/
- Random Logger - https://github.com/chentex/random-logger
- Grafana Dashboard Community (Performance Overviews) - https://grafana.com/grafana/dashboards
