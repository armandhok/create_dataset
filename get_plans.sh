#! /bin/bash

echo "inst_slut, plan" > plans.txt
for i in `cat dependencies.txt`
do  
	inve=$(curl -Ls "http://adela.datos.gob.mx/$i/catalogo.json" | jq '.' | grep -oiE 'plan de apertura institucional .*' | sed -e 's/"//g' -e 's/,//g' | uniq) 
	echo "$i, $inve" >> plans.txt 
done
