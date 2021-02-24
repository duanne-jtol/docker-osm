FROM golang:buster
MAINTAINER Etienne Trimaille <etienne.trimaille@gmail.com>

ENV BF_DOWNLOAD_URL http://download.geofabrik.de/europe/sweden-latest.osm.pbf
RUN apt update && apt install -y python3-pip \
      libprotobuf-dev libleveldb-dev libgeos-dev \
      libpq-dev python3-dev postgresql-client-11 python-setuptools \
      --no-install-recommends

RUN ln -s /usr/lib/libgeos_c.so /usr/lib/libgeos.so

WORKDIR $GOPATH
RUN go get github.com/tools/godep
RUN git clone https://github.com/omniscale/imposm3 src/github.com/omniscale/imposm3
RUN cd src/github.com/omniscale/imposm3 && make update_version && go install ./cmd/imposm/

ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt

ADD importer.py /home/

# Add YAML Mapping file
ADD mapping.yml /home/settings/mapping.yml
# Add Sweden PBF for initial import
ADD $BF_DOWNLOAD_URL /home/settings/sweden-latest.osm.pbf

ADD wait-for-postgres.sh /wait-for-postgres.sh
RUN chmod +x /wait-for-postgres.sh
WORKDIR /home
CMD ["/wait-for-postgres.sh", "python3", "-u", "/home/importer.py"]
