#!/bin/bash

# Can be an array, e.g.: COUNTRIES=('great-britain' 'italy')
COUNTRIES=('great-britain' 'ireland-and-northern-ireland')

for country in "${COUNTRIES[@]}"
do
  curl -LO http://download.geofabrik.de/europe/${country}-latest.osm.pbf
done

