FROM golang:1.16.0-buster as mother
MAINTAINER Alessandro Parma <alessandro.parma@geosolutionsgroup.com>

WORKDIR /code
#Install the tool for merging the PBF files.
RUN apt update && apt install osmium-tool -yq && mkdir region
COPY ./*.pbf /code/
#RUN osmium merge denmark-latest.osm.pbf finland-latest.osm.pbf iceland-latest.osm.pbf norway-latest.osm.pbf sweden-latest.osm.pbf -o /code/scandinavia-latest.osm.pbf
RUN osmium merge *.pbf -o /code/region/region-latest.osm.pbf

# Final Image.
FROM golang:1.16.0-buster
MAINTAINER Asdrubal Gonzalez <asdrubal.gonzalez@geo-solutions.it>

RUN apt update && apt install -y python3-pip \
      python3-setuptools \
      libprotobuf-dev libleveldb-dev libgeos-dev \
      libpq-dev python3-dev postgresql-client-11 python-setuptools \
      --no-install-recommends

RUN ln -s /usr/lib/libgeos_c.so /usr/lib/libgeos.so

WORKDIR $GOPATH
RUN go get github.com/tools/godep
RUN git clone https://github.com/omniscale/imposm3 src/github.com/omniscale/imposm3
RUN cd src/github.com/omniscale/imposm3 && git checkout tags/v0.11.1 && make update_version && go install ./cmd/imposm/

# Preparing everything for the importer.
ADD requirements.txt /home/requirements.txt
RUN pip3 install -r /home/requirements.txt
ADD importer.py /home/

# Add YAML Mapping file
ADD mapping.yml /home/settings/mapping.yml
COPY --from=mother "/code/region/region-latest.osm.pbf" "/home/settings/region-latest.osm.pbf"

ADD wait-for-postgres.sh /wait-for-postgres.sh
RUN chmod +x /wait-for-postgres.sh
WORKDIR /home
CMD ["/wait-for-postgres.sh", "python3", "-u", "/home/importer.py"]
