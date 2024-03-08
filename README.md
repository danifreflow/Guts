# Guts
## IMPORTANTE
Necesito ayuda actualmente en el script , estoy implementando una base de datos que es un archivo de texto pero cuando hago las peticiones me da el siguiente error
en el **wget**
```
--2024-03-08 12:05:37--  https://jkanime.bz///
Cargado certificado CA '/etc/ssl/certs/ca-certificates.crt'
Resolviendo jkanime.bz (jkanime.bz)... 104.21.86.206, 172.67.136.207, 2606:4700:3033::ac43:88cf, ...
Conectando con jkanime.bz (jkanime.bz)[104.21.86.206]:443... conectado.
Petición HTTP enviada, esperando respuesta... 301 Moved Permanently
Localización: https://jkanime.net/ [siguiendo]
--2024-03-08 12:05:38--  https://jkanime.net/
Resolviendo jkanime.net (jkanime.net)... 172.67.73.66, 104.26.6.237, 104.26.7.237, ...
Conectando con jkanime.net (jkanime.net)[172.67.73.66]:443... conectado.
Petición HTTP enviada, esperando respuesta... 403 Forbidden
2024-03-08 12:05:38 ERROR 403: Forbidden.
```
Por favor si alquien sabe a que se debe que me avise , puesto que las mismas peticiones si funcionan cuando haces la busqueda directa, muchas Gracias

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
- sqlite

Actualmente recibe dos parametros de entrada **"titulo-del-anime-sin-espacion" "num-capitulo"**
Ejemplo para ver primer capitulo de bersek
```bash
./Guts.sh bersek 1
```
tambien hace busquedas de animes y te redirige al primer capitulo
```bash
./Guts.sh one
1
0 ah-my-goddess-2
1 baka-to-test-to-shoukanjuu-christmas-special
2 bayonetta-bloody-fate
3 c-the-money-of-soul-and-possibility-control
4 campione
5 chuukan-kanriroku-tonegawa
6 clione-no-akari
7 cutie-honey-universe
8 dr-stone
9 dr-stone-new-world
10 dr-stone-new-world-part-2
11 dr-stone-ryuusui
Presiona 'n' para seguir iterando, 'a' para retroceder si no pulsa el numero que quieres ver n
2
0 dr-stone-stone-wars
1 dragon-ball-z-movie-01-the-deadzone
2 evangelion-1-11-you-are-not-alone
3 fairy-gone
4 fairy-gone-2nd-season
5 ghost-in-the-shell-arise-border4-ghost-stands-alone
6 isekai-one-turn-kill-neesan-ane-douhan-no-isekai-seikatsu-hajimemashita
7 isekai-wa-smartphone-to-tomo-ni
8 isekai-wa-smartphone-to-tomo-ni-2
9 jojo-no-kimyou-na-bouken-part-6-stone-ocean
10 lv1-maou-to-one-room-yuusha
11 majin-bone
Presiona 'n' para seguir iterando, 'a' para retroceder si no pulsa el numero que quieres ver n
3
0 norn9-nornnonet
1 one-outs
2 one-piece
3 one-piece-3d2y-ace-no-shi-wo-koete-luffy-nakama-tono-chikai
4 one-piece-film-z
5 one-piece-film-gold
6 one-piece-film-red
7 one-piece-movie-14-stampede
8 one-piece-recap
9 one-piece-special-glorious-island
10 one-piece-adventure-of-nebulandia
11 one-piece-episode-of-luffy-hand-island-no-bouken
Presiona 'n' para seguir iterando, 'a' para retroceder si no pulsa el numero que quieres ver
```
[ejemplo](https://github.com/danifreflow/Guts/blob/main/Guts/assets/recording.gif)

## TO -DO
Este script esta sin acabar por que no he tenido tiempo, pero acepto mejoras
- [x] Buscar series desde el script
- [x] que sea paginable (es decir poder avanzar entre las distintas partes de la busqueda)
- [ ] guardar en el ordenador el capitulo por el que vas dependiendo de la serie
- [x] al imprimir los titulos poder hacer que te lleve a uno pulsando el numero al que pertenece, usar n para paginar
- [x] pasar de un capitulo al siguiente al terminar el mismo
- [ ] dar opcion de descargar capitulos
- [x] dar opcion de buscar los capitulos de una serie específica
