#!/bin/bash

echo "Run this from the directory with the Gifs"

#echo "Downloading Grite from Github"
#wget "https://github.com/niallVR/Grite/releases/download/V1.0/Grite.exe" -O "../Grite.exe"

echo "Generating a list of Gifs"
ls -l *.gif | awk '{print $9}' > "../listgifs" 
ls -l *.gif | awk '{print $9}' | rev | cut -c 5- | rev | awk '{print $0 ".png"}' > "../listpngs"


for i in {1..151}
do
	namegif=$(head -n $i "../listgifs" | tail -n 1)
	namepng=$(head -n $i "../listpngs" | tail -n 1)
	echo "Converting $namegif"
	montage -coalesce $namegif -tile x1 -geometry +0+0 -alpha On -background "rgba(0, 0, 0, 0.0)" -quality 100 $namepng
done

echo "Done"
