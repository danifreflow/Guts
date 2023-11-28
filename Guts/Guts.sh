#!/bin/bash

# El objetivo de este script es ver anime desde la terminal sin anuncios
# La pagina web a utilizar es jkanime por la limpieza de sus uris
#
#
#
#
#




crear_tabla () {
  local ruta="$XDG_DATA_HOME/.bdgec.db"
  # local ruta="$HOME/.local/share/.bdgec.db"
  local query="CREATE TABLE capos (uri TEXT PRIMARY KEY,numero INTEGER DEFAULT 0);"
  if [[ ! -e "$ruta" ]]; then
    echo "Creando Base de Datos en $ruta ..."
    touch "$ruta"
    sqlite3 "$ruta" "$query"
  elif [[ ! -f "$ruta" ]]; then
    echo "Existe $ruta como directorio. Abortando operación"
    exit 2
  fi
}

add_a_tabla () {
  # local ruta=""$XDG_DATA_HOME"/.bdgec.db"
  local ruta="$HOME/.local/share/.bdgec.db"
  local query="INSERT INTO capos (uri, numero) VALUES ($1, $2)"
  sqlite3 "$ruta" "$query"
}

if [ "$#" -lt 1 ]; then
  echo "Uso: $0 <nombre-del-anime> <capitulo(numero)>"
  crear_tabla
  exit 1
fi

if [ "$#" -lt 2 ]; then
  respuesta=n
  pag=1
  while [[ "$respuesta" == "n" || "$respuesta" == "a" ]] ;do
    echo $pag
    wget  "https://jkanime.bz/buscar/$1/$pag/" -P /tmp > /dev/null 2>&1
    # Falta investigar más; Ver https://www.shellcheck.net/wiki/SC2207
    urls=($(grep -A 1 '<div class="anime__item">' /tmp/index.html | awk -F 'href="' '/<a/{print $2}' | awk -F '"' '{print $1}' | xargs -n 1 basename))
    contador=0
    for url in "${urls[@]}";do
      echo "$contador $url"
      ((contador++))
    done
    rm -rf /tmp/index.html
    
    read -rp "Presiona 'n' para seguir iterando, 'a' para retroceder si no pulsa el numero que quieres ver " respuesta
    if [[ "$respuesta" =~ ^[0-9]+$ ]] && [ "$respuesta" -ge 0 ] && [ "$respuesta" -lt "${#urls[@]}" ]; then
    # Verificar si la respuesta es un número válido y dentro del rango del array
    url_seleccionada="${urls[$respuesta]}"
    # echo "Seleccionaste: $url_seleccionada"
    elif [ "$respuesta" == "a" ];then
      if [ "$pag" -gt 1 ];then
        ((pag--))
      fi
    else
      ((pag++))
      respuesta=n
    fi
  done
  respuesta=s
  capitulo=0
  while [ "$respuesta" == "s" ] ;do
    ((capitulo++))
    wget -p "https://jkanime.bz/$url_seleccionada/$capitulo/" -P /tmp > /dev/null 2>&1

    url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"

    rm -rf /tmp/jkanime.bz > /dev/null

    mpv "$url" > /dev/null
    read -rp "Quiere ver el siguiente capitulo pulse 's' " respuesta
  done

fi


if [ "$#" -eq 2 ];then
  respuesta=s
  capitulo=$2
  while [ "$respuesta" == "s" ] ;do

    wget -p "https://jkanime.bz/$1/$capitulo/" -P /tmp > /dev/null 2>&1

    url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"

    rm -rf /tmp/jkanime.bz > /dev/null

    mpv "$url" > /dev/null
    ((capitulo++))
    read -rp "Quiere ver el siguiente capitulo pulse 's' " respuesta

  done
fi




