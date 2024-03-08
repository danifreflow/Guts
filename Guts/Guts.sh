#!/bin/sh
# El objetivo de este script es ver anime desde la terminal sin anuncios
# La pagina web a utilizar es jkanime por la limpieza de sus uris




# Funciones


# ejemplo: reproducir_anime_capitulo one-piece 10
reproducir_anime_capitulo() {
  anime=$1
  capitulo=$2
  echo $anime
  echo $capitulo
  sleep 5
  while [ "$respuesta" = "s" ] ;do
    wget -p "https://jkanime.bz/$anime/$capitulo/" -P /tmp > /dev/null #2>&1
    url="$(grep -A 1 video /tmp/jkanime.bz/um.php* | grep url | cut -d "'" -f2 | head -n1)"
    sleep 10
    rm -rf /tmp/jkanime.bz > /dev/null
    mpv "$url" > /dev/null
    capitulo=$((capitulo+1))
    clear
    printf "Introduce 's' para ver el capítulo %s: " $capitulo
    read -r respuesta
  done
  printf "Introduce 'g' para guardar la serie %s en la base de datos: " $anime
  read -r guardar
  if [ "$guardar" = "g" ]; then
    echo "$anime, $capitulo" >> $HOME/.config/Guts/db.txt 
  fi
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
  printf "\n\n"
  printf "Base de datos: %s -d" "$script"
  printf "\n"
  printf "\tEjemplo: %s -d" "$script"
  printf "\n"

}


# Script

if [ ! -d "$HOME/.config/Guts" ]; then
    mkdir -p "$HOME/.config/Guts"
    echo "El directorio $HOME/.config/Guts ha sido creado."
fi


if [ ! -f "$HOME/.config/Guts/db.txt" ]; then
    touch $HOME/.config/Guts/db.txt 
fi

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  mostrar_ayuda
  exit 1
fi

if [ "$#" -eq 1 ]; then
  if [ "$1" = "-d" ]; then
    respuesta=s
    clear
    mapfile -t dataBase < $HOME/.config/Guts/db.txt
    cat $HOME/.config/Guts/db.txt | cut -d ',' -f1 | nl
    read -r numero  
    sed -n "${numero}p" $HOME/.config/Guts/db.txt  | while IFS=',' read -r anime_seleccionado capitulo; do
    # Elimina espacios iniciales y finales
    anime_seleccionado="${anime_seleccionado// /}"
    capitulo="${capitulo// /}"
    # Prueba: Imprime las variables para verificar
    echo "Anime:$anime_seleccionado"
    echo "Capítulo:$capitulo"
    sleep 5
    done
    reproducir_anime_capitulo "$anime_seleccionado" "$capitulo"
  else
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

fi

if [ "$#" -eq 2 ];then
  respuesta=s
  capitulo=$2
  anime_seleccionado=$1
 # if [[ "$capitulo" == "?" ]];then

  #fi
  reproducir_anime_capitulo "$anime_seleccionado" "$capitulo"
fi

