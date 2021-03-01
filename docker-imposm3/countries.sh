#!/bin/bash
COUNTRIES=('sweden' 'denmark' 'norway' 'finland' 'iceland')

for country in "${COUNTRIES[@]}"
do
  curl -LO http://download.geofabrik.de/europe/${country}-latest.osm.pbf
done
