#!/usr/bin/env bash

for md in guts.*.md; do
  salida=${md//\.md/}
  pandoc "$md" -s -t man -o "$salida"
done
