#!/bin/bash
# Purpose:  Thunar Custom Action. Computes md5sum.
# Command: /usr/local/bin/checksum %f
# Pattern: *.iso;*.ISO;*.img;*.IMG

file="$@"

sum_temp=$(mktemp /tmp/sum.XXXXXXXX)

 md5sum "$file" | tee >(cut -d ' ' -f1 > $sum_temp) |zenity --progress --title="MD5sum" --text="Calculating MD5 for:\n${file##*/}" --pulsate --auto-close

    # If Cancel is clicked then remove temporary file and exit
    if [ "${PIPESTATUS[2]}" -ne "0" ]; then
        rm $sum_temp
        exit 0
    fi

    sum=`cat $sum_temp`
    zenity --info --title="MD5sum" --text="MD5sum : $sum\nFile :          ${file##*/}" --no-wrap
    rm $sum_temp
    exit 0
fi
