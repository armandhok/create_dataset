#! /bin/bash

echo "inst_slut, inventario" > inventarios.txt
for i in `cat dependencies.txt`
do  
	inve=$(curl -Ls "http://adela.datos.gob.mx/$i/catalogo.json" | jq '.' | grep -oiE 'Inventario Institucional de Datos .*' | sed -e 's/"//g' -e 's/,//g' | uniq) 
	echo "$i, $inve" >> inventarios.txt 
done
