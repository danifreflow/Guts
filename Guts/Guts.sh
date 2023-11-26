#!/bin/bash

# El objetivo de este script es ver anime desde la terminal sin anuncios
# La pagina web a utilizar es jkanime por la limpieza de sus uris
#
#
#
if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <nombre-del-anime> <capitulo(numero)>"
  exit 1
fi

if [ "$#" -lt 2 ]; then
  wget  "https://jkanime.bz/buscar/$1/1/" -P /tmp > /dev/null 2>&1
  urls=($(grep -A 1 '<div class="anime__item">' /tmp/index.html | awk -F 'href="' '/<a/{print $2}' | awk -F '"' '{print $1}' | xargs -n 1 basename))
  contador=0
  for url in "${urls[@]}";do
    echo "$contador $url"
    ((contador++))
  done
  rm -rf /tmp/index.html
fi


if [ "$#" -eq 2 ];then
 wget -p "https://jkanime.bz/$1/$2/" -P /tmp > /dev/null 2>&1

 url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"

 rm -rf /tmp/jkanime.bz > /dev/null

 mpv "$url" > /dev/null

fi



