#!/usr/bin/env bash
# El objetivo de este script es ver anime desde la terminal sin anuncios
# La pagina web a utilizar es jkanime por la limpieza de sus uris
#
#
#
#
#




# Funciones
crear_tabla () {
  if [[ -z "$XDG_DATA_HOME" ]]; then
    exit 3
  fi
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
  # acepta dos valores, la uri y el número
  # la uri es $respuesta_seleccionada, por ejemplo
  # y el numero es el capitulo que se está reproduciendo, por ejemplo
  local ruta="$XDG_DATA_HOME/.bdgec.db"
  # local ruta="$HOME/.local/share/.bdgec.db"
  local query="INSERT INTO capos (uri,numero) VALUES ('$1', $2);"
  sqlite3 "$ruta" "$query"
}

# ejemplo: reproducir_anime_capitulo one-piece 10
reproducir_anime_capitulo() {
  while [ "$respuesta" = "s" ] ;do
    wget -p "https://jkanime.bz/$1/$2/" -P /tmp > /dev/null 2>&1
    url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"
    rm -rf /tmp/jkanime.bz > /dev/null
    mpv "$url" > /dev/null
    ((capitulo++))
    clear
    printf "Introduce 's' para ver el capítulo %s: " $capitulo
    read -r respuesta
  done
}

mostrar_ayuda() {
  script="$(basename "$0")"

  printf "Uso: %s [ARGUMENTOS]" "$script"
  printf "\n\n"
  printf "Reproducir: %s <nombre-del-anime> <capitulo(numero)>" "$script"
  printf "\n"
  printf "\tEjemplo: %s one-piece 10" "$script"
  printf "\n\n"
  printf "Búsqueda: %s <búsqueda>" "$script"
  printf "\n"
  printf "\tEjemplo: %s \"one piece\"" "$script"
  printf "\n"
}


# Script
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  mostrar_ayuda
  exit 1
fi

if [ "$#" -eq 1 ]; then
  respuesta=n
  pag=1
  while [ "$respuesta" = "n" ] || [ "$respuesta" = "a" ] ;do
    # Obtenemos urls
    wget  "https://jkanime.bz/buscar/$1/$pag/" -P /tmp > /dev/null 2>&1
    urls=$(grep -A 1 '<div class="anime__item">' /tmp/index.html | awk -F 'href="' '/<a/{print $2}' | awk -F '"' '{print $1}' | xargs -n 1 basename)
    rm -rf /tmp/index.html

    # Mostramos las opciones
    clear
    echo "Página $pag"
    echo "$urls" | sed -e "s/^\([a-z]\)/\U\1/g" -e "s/-\([a-z]\)/-\U\1/g" -e "s/-/ /g" | nl -n ln

    # Leemos la respuesta del usuario
    printf "Introduce un número de anime, 'n' para ir a la siguiente página o 'a' para ir a la anterior: "
    read -r respuesta

    # Verificamos si la respuesta es un número y está dentro del rango
    if [ "$respuesta" -eq "$respuesta" ] 2>/dev/null && [ "$respuesta" -ge 1 ] && [ "$respuesta" -le "$(echo "$urls" | wc -l)" ]; then
      anime_seleccionado="$(echo "$urls" | sed "${respuesta}q;d" | cut -d' ' -f2-)"
    elif [ "$respuesta" = "a" ]; then
      [ "$pag" -gt 1 ] && pag=$((pag-1))
    else
      pag=$((pag+1))
      respuesta=n
    fi
  done
  respuesta=s
  capitulo=1
  reproducir_anime_capitulo "$anime_seleccionado" "$capitulo"
fi

if [ "$#" -eq 2 ];then
  respuesta=s
  capitulo=$2
  anime_seleccionado=$1
  reproducir_anime_desde "$anime_seleccionado" "$capitulo"
fi

