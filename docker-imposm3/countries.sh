#!/bin/bash

if  [ $# -ge 0 ]
then 
    echo "found $# parameters to download"
    for ct in "$@"
        do
            IFS=':' 
            read -ra ADDR <<< "$ct"  
            if  [ ${#ADDR[@]}  -eq 1 ]
            then
                continent=$(echo ${ADDR[0]} | tr '[:upper:]' '[:lower:]' )
                curl -LO https://download.geofabrik.de/$continent-latest.osm.pbf
            elif  [ ${#ADDR[@]}  -eq 2 ]
            then
                continent=$(echo ${ADDR[0]} | tr '[:upper:]' '[:lower:]' )
                country=$(echo ${ADDR[1]} | tr '[:upper:]' '[:lower:]' )
                curl -LO  https://download.geofabrik.de/$continent/$country-latest.osm.pbf
            else
                echo "Please pass parameter as continent:country e.g. Asia:India"
            fi
        done
else
    echo "Please pass at least continent name ( europe, africa, antarctica, asia, australia-oceania, central-america, north-america, south-america )"
fi