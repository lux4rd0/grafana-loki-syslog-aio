## grafana-loki-syslog-aio

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

The system that you deploy this to will need access to the Internet to:

- Download the "grafana-piechart-panel" panel plugin on startup
- Build the Generator (optional) docker container (built from centos:7 with yum updates and installation of the Netcat package)

## Getting Started

This was built and tested on Linux Centos 7. To get started, download the code from this repository and extract it into an empty directory. For example:

    wget https://github.com/lux4rd0/grafana-loki-syslog-aio/archive/main.zip
    unzip main.zip
    cd grafana-loki-syslog-aio-main
    
From that directory, run the command:

    docker-compose up -d

This will start to download all of the needed application containers and start them up. It will also perform a local docker build of the generator.

Once all of the docker containers are started up, point your Web browser to the Grafana page, typically http://hostname:3000/ - with hostname being the name of the server you ran the docker-compose up -d command on. The "Syslog Overview" Dashboard is defaulted without having to login.

Note: this docker-compose stack is designed to be as easy as possible to deploy and go. Logins have been disabled and the default user only has a viewer role. This can be changed to an Admin role by changing the Grafana environmental variable in the docker-compose.yml file to:

    GF_AUTH_ANONYMOUS_ORG_ROLE: Admin

## Options:

The default Loki storage configruation uses S3 storage with MinIO. If you want to use the filesystem instead, use the config/loki-config-filesystem.yml conifguration in the docker-compose.yml file. An example would be:

    volumes:
    - ./config/loki-config-filesystem.ym:/etc/loki/loki-config.yml:ro

**Changing MinIO Keys**

MinIO configruations also default the Access Key and Secret Key at startup. If you want to change them, you'll need to update two files:

./docker-compose.yml

      MINIO_ACCESS_KEY: minio123
      MINIO_SECRET_KEY: minio456
      
./config/loki-config-s3.yml

     aws:
      s3: s3://minio123:minio456@minio.:9000/loki

**Disabling The Syslog Generator**

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
