#!/bin/bash
# Purpose:  Thunar Custom Action. Calculates hashes.
# Usage:     /usr/local/bin/checksum %f
# Author:    Misko_2083
# Date:       May, 2015
# Version:    1.2
# Licence GPLv2
# Dependancy: zenity, pv

file="$@"

# Check that the user didn't select directory
if [ -d "$file" ]; then
	zenity --error --text="'$file' is a directory. Checksum cannot handle directories."
	exit
fi

MD5=(`echo "" | awk '{print "TRUE","MD5", $0}'`)
SHA1=(`echo "" | awk '{print "FALSE","SHA-1", $0}'`)
SHA224=(`echo "" | awk '{print "FALSE","SHA-224", $0}'`)
SHA256=(`echo "" | awk '{print "FALSE","SHA-256", $0}'`)
SHA384=(`echo "" | awk '{print "FALSE","SHA-384", $0}'`)
SHA512=(`echo "" | awk '{print "FALSE","SHA-512", $0}'`)

selection=$(zenity --list --radiolist --height=300 --title="Checksum" --text="File:  <b>${file##*/}</b>\nPick the hash function." --column="Pick" --column="Hash" "${MD5[@]}" "${SHA1[@]}" "${SHA224[@]}" "${SHA256[@]}" "${SHA384[@]}" "${SHA512[@]}")

# If Cancel is clicked then exit
if [ $? != "0" ]; then
    exit 0
fi

# Creates a temp file to store the hash sum
sum_temp=$(mktemp /tmp/sum.XXXXXXXX)


# If there is a pipe file removes it
if [[ -p /tmp/checksum_fifo ]]; then
	rm /tmp/checksum_fifo || `zenity --error --text="<tt>Could not remove <i>/tmp/checksum_fifo</i>\nCheck the file permissions.</tt>" && exit 1`
fi

# Create a named pipe for storing percentage from pv
mkfifo --mode=0666 /tmp/checksum_fifo

echo $selection | grep "MD5" > /dev/null
if [ $? = 0 ];then
   # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | md5sum 2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating MD5 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="MD5sum" --text="MD5sum : $sum\nFile :          ${file##*/}" --no-wrap
    
    #Cleanup
    rm $sum_temp
    exit 0
fi

echo $selection | grep "SHA-1" > /dev/null
if [ $? = 0 ];then
    # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | sha1sum 2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating SHA-1 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="SHA-1" --text="SHA-1: $sum\nFile :    ${file##*/}" --no-wrap

    #Cleanup
    rm $sum_temp
    exit 0
fi

echo $selection | grep "SHA-224" > /dev/null
if [ $? = 0 ];then
   # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | sha224sum  2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating SHA-224 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="SHA-224" --text="SHA-224 : $sum\nFile :         ${file##*/}" --no-wrap

    #Cleanup
    rm $sum_temp
    exit 0
fi

echo $selection | grep "SHA-256" > /dev/null
if [ $? = 0 ];then
    # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | sha256sum 2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating SHA-256 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="SHA-256" --text="SHA-256 : $sum\nFile :          ${file##*/}" --no-wrap

    #Cleanup
    rm $sum_temp
    exit 0
fi

echo $selection | grep "SHA-384" > /dev/null
if [ $? = 0 ];then
    # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | sha384sum 2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating SHA-384 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="SHA-384" --text="SHA-384 : $sum\nFile :         ${file##*/}" --no-wrap

    #Cleanup
    rm $sum_temp
    exit 0
fi

echo $selection | grep "SHA-512" > /dev/null
if [ $? = 0 ];then
    # Creates a subshell and sends progress to the named pipe
   ( pv -n "$file" | sha512sum 2>&1 | tee >(cut -d ' ' -f1 > $sum_temp) ) 2>/tmp/checksum_fifo &
	PVPID=$!

    # Creates a subshell and reads progress from the named pipe
   ( zenity --progress --title="MD5sum" --text="Calculating SHA-512 for:\n${file##*/}" --percentage=0 --auto-close </tmp/checksum_fifo;
	
	# If Cancel is clicked 
	if [ $? = 1 ];then
		# Kill the sum process
		kill $PVPID;
		# Removes the tmp file and the pipe
		rm $sum_temp;
		rm /tmp/checksum_fifo
		# Kill off this app
		killall checksum;
		
	fi;
	# Removes the pipe file
	rm /tmp/checksum_fifo ) &
	ZENPID=$!

   #Wait until progressbar process finishes
   wait $ZENPID
    
    #Displays results
    sum=`cat $sum_temp`
    zenity --info --title="SHA-512" --text="SHA-512 : $sum\nFile :           ${file##*/}" --no-wrap

    #Cleanup
    rm $sum_temp
    exit 0
fi
