## grafana-loki-syslog-aio

https://github.com/lux4rd0/grafana-loki-syslog-aio/blob/main/loki_syslog_aio.png?raw=true

<img src="./loki_syslog_aio.png">

## About The Project

This Loki All-In-One example is geared to help you get up and running quickly with a Syslog ingestor and visualization of logs. It uses [Grafana Loki](https://grafana.com/oss/loki/) and Promtail as a receiver for forwarded syslog-ng logs. Essentially:

> RFC3164 Network/Compute Devices -> syslog-ng (UDP port 514) ->
> Promtail (port 1514) -> Loki (port 3100) <- Grafana (port 3000)

## Getting Started

The project is built around a pre-configured Docker stack of the following:

 - Grafana
 - Grafana Loki (configured for MinIO)
 - Grafana Promtail
 - syslog-ng

I've extended the stack to include pre-conifgured monitoring with:

- Prometheeus
- Node-Exporter
- cAdvisor

You'll also see a simple Syslog generator based on Vicente Zepeda Mas's [random-logger](https://github.com/chentex/random-logger) project.

## Prerequisites

- Docker - https://docs.docker.com/install
- Docker Compose - https://docs.docker.com/compose/install

## Getting Started

This was built and tested on Linux Centos 7. To get started, download the code from this repository and extract it into an empty directory.

From that directory, run the command:

    docker-compose up -d

This will start to download all of the needed application containers and start them up. It will also perform a local docker build of the generator.

## Options:

I defaulted my configruation of having Loki use S3 storage with MinIO. If you want to use the filesystem instead, use the config/loki-config-filesystem.yml conifguration in the docker-compose.yml file. And example would be:

    volumes:
    - ./config/loki-config-filesystem.ym:/etc/loki/loki-config.yml:ro

**Disabling the syslog generator**

The default deployment starts a syslog generator so that you can see the dashboards in use straight away after startup. If you are using your own devices, you can comment out the *generator* stanza in the docker-compose.yml file. Look for and delete:

      generator:
        build:
          context: ./generator
        container_name: generator
        depends_on:
        - syslog-ng
        networks:
          loki: null

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
