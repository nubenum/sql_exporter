FROM quay.io/prometheus/golang-builder AS builder

# Get sql_exporter
ADD .   /go/src/github.com/free/sql_exporter
WORKDIR /go/src/github.com/free/sql_exporter

# Do makefile
RUN apt-get update && apt-get install -y libxml2
RUN make

# Make image and copy build sql_exporter
FROM        debian:stable-slim

RUN apt-get update && apt-get install -y libxml2

ENV LD_LIBRARY_PATH=/bin/clidriver/lib
COPY        --from=builder /go/src/github.com/ibmdb/go_ibm_db/installer/clidriver/  /bin/clidriver/
COPY        --from=builder /go/src/github.com/free/sql_exporter/sql_exporter  /bin/sql_exporter

EXPOSE      9399
ENTRYPOINT  [ "/bin/sql_exporter" ]
