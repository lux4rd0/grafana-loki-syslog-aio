

## grafana-loki-syslog-aio

<img src="./loki_syslog_aio.png">

## About The Project

This Loki All-In-One example is geared to help you get up and running quickly with a Syslog ingestor and visualization of logs. It uses [Grafana Loki](https://grafana.com/oss/loki/) and Promtail as a receiver for forwarded syslog-ng logs. Essentially:

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

There is also a simple Syslog generator based on Vicente Zepeda Mas's [random-logger](https://github.com/chentex/random-logger) project.

## Prerequisites

- Docker - https://docs.docker.com/install
- Docker Compose - https://docs.docker.com/compose/install

The system that you deploy this to will need access to the Internet to:

- Download the "grafana-piechart-panel" panel plugin on startup
- Build the Generator (optional) docker container (built from centos:7 with yum updates and installation of the Netcat package)

## Using

This was built and tested on Linux CentOS 7. To get started, download the code from this repository and extract it into an empty directory. For example:

    wget https://github.com/lux4rd0/grafana-loki-syslog-aio/archive/main.zip
    unzip main.zip
    cd grafana-loki-syslog-aio-main
    
From that directory, run the docker-compose command:

**Full Example Stack:** Grafana, Loki with s3/MinIO, Promtail, syslog-ng, Prometheus, cAdvisor, node-exporter

    docker-compose -f ./docker-compose.yml up -d

This will start to download all of the needed application containers and start them up. 

*(Optional docker-compose configurations are listed under **Options** below)*

**Grafana Dashboards**

Once all of the docker containers are started up, point your Web browser to the Grafana page, typically http://hostname:3000/ - with hostname being the name of the server you ran the docker-compose up -d command on. The "Syslog Overview" dashboard is defaulted without having to login.

Note: this docker-compose stack is designed to be as easy as possible to deploy and go. Logins have been disabled and the default user has an admin role. This can be changed to an Editor or Viewer role by changing the Grafana environmental variable in the docker-compose.yml file to:

    GF_AUTH_ANONYMOUS_ORG_ROLE: Viewer
    
## Stack Options:

A few other docker-compose files are also available:

**Full Example Stack with Syslog Generator:** Grafana, Loki with s3/MinIO, Promtail, syslog-ng, Prometheus, cAdvisor, node-exporter

    docker-compose -f ./docker-compose-with-generator.yml up -d

**Example Stack without monitoring or Syslog generator**: Grafana, Loki with s3/MinIO, Promtail, syslog-ng

    docker-compose -f ./docker-compose-without-monitoring.yml up -d

**Example Stack without MinIO, monitoring, or Syslog generator:** Grafana, Loki with filesystem, Promtail, syslog-ng

    docker-compose -f ./docker-compose-filesystem.yml up -d

The Syslog Generator configuration with do a local docker build from the configurations location in ./generator

## Configuration Review:

The default Loki storage configuration docker-compose.yml uses S3 storage with MinIO. If you want to use the filesystem instead, either use the different docker-compose configurations listed above or change the configuration directly. An example would be:

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

## Roadmap

See the open issues for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are greatly appreciated.

- Fork the Project
- Create your Feature Branch (git checkout -b feature/AmazingFeature)
- Commit your Changes (git commit -m 'Add some AmazingFeature')
- Push to the Branch (git push origin feature/AmazingFeature)
- Open a Pull Request

## Contact

Dave Schmid - @lux4rd0 - dave@pulpfree.org

Project Link: https://github.com/lux4rd0/grafana-loki-syslog-aio

## Acknowledgements

- Grafana Labs - https://grafana.com/
- Grafana Loki - https://grafana.com/oss/loki/
- Grafana - https://grafana.com/oss/grafana/
- syslog-ng - https://www.syslog-ng.com/
- Random Logger - https://github.com/chentex/random-logger
- Grafana Dashboard Community (Performance Overviews) - https://grafana.com/grafana/dashboards
