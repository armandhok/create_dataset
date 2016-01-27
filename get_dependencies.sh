#! /bin/bash

curl -Ls http://adela.datos.gob.mx/api/v1/catalogs | jq '.' | grep -E '"slug": .*,' | awk -F ':' '{print $2}' | sed -e 's/"//g' -e 's/,//g' > dependencies.txt

