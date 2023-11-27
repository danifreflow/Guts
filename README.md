# Guts

![imagen-guts](https://github.com/danifreflow/Guts/blob/main/Guts/assets/guts.png)

Este Script esta basado en el video de youtube de [anime desde terminal](https://www.youtube.com/watch?v=IHDqzGno4Y4) 
de [Houman](https://houmanr.xyz/) , tambien se inspira en proyectos angloparlantes como
[ani-cli](https://github.com/pystardust/ani-cli)

## Funcionamineto del script
El script tiene las siguientes dependencias 
- grep
- wget
- mpv
- awk
- xargs

Actualmente recibe dos parametros de entrada **"titulo-del-anime-sin-espacion" "num-capitulo"**
Ejemplo para ver primer capitulo de bersek
```bash
./Guts.sh bersek 1
```
[ejemplo](https://github.com/danifreflow/Guts/blob/main/Guts/assets/recording.webm)

## TO -DO
Este script esta sin acabar por que no he tenido tiempo, pero acepto mejoras
- [x] Buscar series desde el script
- [x] que sea paginable (es decir poder avanzar entre las distintas partes de la busqueda)
- [ ] guardar en el ordenador el capitulo por el que vas dependiendo de la serie
- [x] al imprimir los titulos poder hacer que te lleve a uno pulsando el numero al que pertenece, usar n para paginar
- [ ] pasar de un capitulo al siguiente al terminar el mismo
- [ ] dar opcion de descargar capitulos
