---
title: GUTS
section: 1
header: Manual de Usuario
footer: guts alfa
date: 29 Nov, 2023
---

# NOMBRE
guts - Anime desde la terminal.

# RESUMEN
**guts** [*TÍTULO*] [*CAPÍTULO*]

# DESCRIPCIÓN
**guts** es un script de terminal que permite automatizar el consumo de anime desde la terminal.
Se vale de varias dependencias para automatizar la búsqueda, y la visualización continua de los capítulos.
Su estado es el de alfa, por lo que es posible encontrar fallos en el programa, y que la funcionalidad esté incompleta.

# PARÁMETROS

**TÍTULO**
: el nombre del anime que se busca. No puede contener espacios, pero puede ser parcial.


**CAPÍTULO**
: número del capítulo a obtener. Opcional.

# EJEMPLOS

**guts bersek 1**
: reproduce el primer capítulo de Berserk.

**Guts.sh one**
: muestra una lista numerada y paginada de los animes que coinciden con esa búsqueda.

# CÓDIGOS DE SALIDA

**0**
: funcionamiento normal del script

**1**
: no se han proporcionado los argumentos necesarios

**2**
: la ruta del archivo de la base de datos está ocupada por un directorio

**3**
: la variable de entorno XDG_DATA_HOME está vacía

# AUTORES
MW

# FALLOS
Reporten los fallos y peticiones en: <https://github.com/danifreflow/Guts/issues>
