#!/bin/bash
# Purpose:  Thunar Custom Action. Creates Symbolic links.   
# Author:    Misko_2083
# Date:       June, 2015
# Version:    1
# Licence GPLv2
# Dependancy: zenity, pv

file="$@"

ln -s "$file"  ${file##*/}.symlink

if [ $? != 0 ]; then
	zenity --info --title="Symlink" --text="Could not create symlink"
fi
