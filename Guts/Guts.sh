#!/bin/sh

# Variables globales
BD="$XDG_DATA_HOME/guts/guts.db"


# Funciones
inicializar_base_de_datos () {
  if [ -z "$XDG_DATA_HOME" ]; then
    BD=~"/.guts.db"
  fi
  if [ ! -e "$BD" ]; then
    mkdir -p "${BD%/*}" >/dev/null 2>&1
    echo "Creando Base de Datos en $BD ..."
    sqlite3 "$BD" "CREATE TABLE ultimo_visto (anime TEXT PRIMARY KEY, capitulo INTEGER DEFAULT 0);" >/dev/null 2>&1
  fi
}

# ejemplo: guardar_anime_capitulo one-piece 10
guardar_anime_capitulo () {
  anime="$1"
  capitulo="$2"
  insertar="INSERT INTO ultimo_visto (anime, capitulo) VALUES ('$anime', $capitulo);"
  actualizar="UPDATE ultimo_visto SET capitulo=$capitulo WHERE anime='$anime';"
  sqlite3 "$BD" "$insertar" >/dev/null 2>&1 || sqlite3 "$BD" "$actualizar" >/dev/null 2>&1
}

# ejemplo: reproducir_anime_capitulo one-piece 10
reproducir_anime_capitulo() {
  anime=$1
  capitulo=$2
  respuesta="s"
  anime_formateado="$(echo "$anime" | sed -e "s/^\([a-z]\)/\U\1/g" -e "s/-\([a-z]\)/-\U\1/g" -e "s/-/ /g")"
  titulo="$anime_formateado $capitulo"
  while [ "$respuesta" = "s" ] ;do
    wget -p "https://jkanime.bz/$anime/$capitulo/" -P /tmp > /dev/null 2>&1
    url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"
    rm -rf /tmp/jkanime.bz > /dev/null
    guardar_anime_capitulo "$anime" "$capitulo"
    mpv "$url" --force-media-title="$titulo" --title="$titulo" > /dev/null
    capitulo=$((capitulo+1))
    clear
    printf "Introduce 's' para ver el capítulo %s: " $capitulo
    read -r respuesta
  done
}

mostrar_ayuda() {
  script="$(basename "$0")"

  printf "Uso: %s [OPCIONES] [ARGUMENTOS]" "$script"
  printf "\n\n"
  printf "Reproducir: %s <nombre-del-anime> <capitulo(numero)>" "$script"
  printf "\n"
  printf "\tEjemplo: %s one-piece 10" "$script"
  printf "\n\n"
  printf "Búsqueda: %s <búsqueda>" "$script"
  printf "\n"
  printf "\tEjemplo: %s \"one piece\"" "$script"
  printf "\n\n"
  printf "Continuar: %s -c" "$script"
  printf "\n"
}




# Script
####################################
# Crear base de datos si no existe
inicializar_base_de_datos


if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  mostrar_ayuda
  exit 1
fi


# Buscar un anime
if [ "$#" -eq 1 ] && [ "$1" != "-c" ]; then
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

    # Verificamos que la respuesta es un número y está dentro del rango
    if [ "$respuesta" -eq "$respuesta" ] 2>/dev/null && [ "$respuesta" -ge 1 ] && [ "$respuesta" -le "$(echo "$urls" | wc -l)" ]; then
      anime_seleccionado="$(echo "$urls" | sed "${respuesta}q;d" | cut -d' ' -f2-)"
    elif [ "$respuesta" = "a" ]; then
      [ "$pag" -gt 1 ] && pag=$((pag-1))
    else
      pag=$((pag+1))
      respuesta=n
    fi
  done
  capitulo=1
  reproducir_anime_capitulo "$anime_seleccionado" "$capitulo"
fi


# Continuar viendo un anime
if [ "$#" -eq 1 ] && [ "$1" = "-c" ]; then
  # Obtener los animes guardados (ultimos capitulos reproducidos)
  opciones="$(sqlite3 "$BD" "SELECT * FROM ultimo_visto")"

  # Mostramos las opciones
  clear
  echo "$opciones" | sed -e "s/^\([a-z]\)/\U\1/g" -e "s/-\([a-z]\)/-\U\1/g" -e "s/-/ /g" -e "s/|/ (ultimo: /g" -e "s/$/)/g"| nl -n ln
  printf "Introduce un número de anime: "
  read -r respuesta

  # Verificamos que la respuesta es un número y está dentro del rango
  if [ "$respuesta" -eq "$respuesta" ] 2>/dev/null && [ "$respuesta" -ge 1 ] && [ "$respuesta" -le "$(echo "$opciones" | wc -l)" ]; then
    anime_seleccionado="$(echo "$opciones" | sed "${respuesta}q;d" | cut -d'|' -f1)"
    ultimo_capitulo="$(sqlite3 "$BD" "SELECT capitulo FROM ultimo_visto WHERE anime='$anime_seleccionado';")"
    reproducir_anime_capitulo "$anime_seleccionado" "$((ultimo_capitulo+1))"
  else
    echo "Anime seleccionado incorrecto"
  fi
fi


# Ver el capitulo de un anime
if [ "$#" -eq 2 ];then
  capitulo=$2
  anime_seleccionado=$1
  reproducir_anime_capitulo "$anime_seleccionado" "$capitulo"
fi

