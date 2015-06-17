#!/bin/bash
# Purpose:  Thunar Custom Action. Calculates hashes.
# Usage:     /usr/local/bin/checksum %f
# Author:    Misko_2083
# Date:       May, 2015
# Version:    1
# Licence GPLv2
# Dependancy: zenity

file="$@"

cp --backup=t "$file" "${file##*/}.backup"
