#!/bin/bash

echo -e "Run this from the directory with the Spritesheets (PNGs)\n"
echo "Generating a list of PNGs"
ls -l *.png | awk '{print $9}' > "../listpngs"

echo -e "\n\n"
echo "Please enter the godot directory where the spritesheets currently are"
echo "Some examples are:"
echo -e "res://Combat/Weapons\nres://characters\nres://"
read spritesheetpath #"res://Pokemon/forward/"


part1="
[gd_scene load_steps=4 format=2]
"

#[ext_resource path=\"res://Pokemon/forward/alakazam.png\" type=\"Texture\" id=1]

part2="
[sub_resource type=\"Animation\" id=1]
resource_name = \"Default\"
"

#length = 8.1

part3="
loop = true
tracks/0/type = \"value\"
tracks/0/path = NodePath(\".:frame\")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/keys = {
\"update\": 1,
"

#"times": PoolRealArray( 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 5, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 6, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 7, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8 ),
#"transitions": PoolRealArray( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ),
#"values": [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80 ]


part4="
}

[sub_resource type=\"Animation\" id=2]
length = 0.001
tracks/0/type = \"value\"
tracks/0/path = NodePath(\".:frame\")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/keys = {
\"times\": PoolRealArray( 0 ),
\"transitions\": PoolRealArray( 1 ),
\"update\": 0,
\"values\": [ 0 ]
}

[node name=\"AnimatedSprite\" type=\"Sprite\"]
texture = ExtResource( 1 )
"
 
# position = Vector2( 0, -34.5 )
# hframes = 10
# vframes = 9

part5="

[node name=\"AnimationPlayer\" type=\"AnimationPlayer\" parent=\".\"]
autoplay = \"Default\"
anims/Default = SubResource( 1 )
anims/RESET = SubResource( 2 )
"


for i in $(seq 1 $(cat ../listpngs | wc -l) )
do
	namegif=$(head -n $i "../listgifs" | tail -n 1)
	namepng=$(head -n $i "../listpngs" | tail -n 1)
	name=$(echo $namepng | rev | cut -c 5- | rev)
	nametscn="${name}.tscn"

	echo "Converting $namepng"
	
	frames=$(gifsicle $namegif -I | head -n 1 | awk '{print $3}')
	frametime_multiplier=$(gifsicle $namegif -I | tail -n 3 | head -n 1 | awk '{print $4}' | rev | cut -c 2- | rev)
	#framesminusone=$(gifsicle $namegif -I | tail -n 2 | head -n | awk '{print $3}' | cut -c 2-)

	gif_dimensionx=$(file $namegif | awk '{print $7}')
	gif_dimensiony=$(file $namegif | awk '{print $9}')

	png_dimensionx=$(file $namepng | awk '{print $5}')
	png_dimensiony=$(file $namepng | awk '{print $7}' | rev | cut -c 2- | rev)

	hframes=$(expr $png_dimensionx / $gif_dimensionx)
	vframes=$(expr $png_dimensiony / $gif_dimensiony)

	cat > $nametscn <<< $part1
	
	echo "[ext_resource path=\"${spritesheetpath}$namepng\" type=\"Texture\" id=1]" >> $nametscn

	cat >> $nametscn <<< $part2
	
	echo "length = 0$(echo "$frames * $frametime_multiplier" | bc -l)" >> $nametscn

	cat >> $nametscn <<< $part3

	times="\"times\": PoolRealArray( "
	transitions="\"transitions\": PoolRealArray( "
	values="\"values\": [ "

	for i in $(seq 0 $(echo "$frames - 1" | bc -l ) )
	do
		tmp="0$(echo "$i * $frametime_multiplier" | bc -l), "
		times="${times}$tmp"
		tmp="1, "
		transitions="${transitions}$tmp"
		tmp="${i}, "
		values="${values}$tmp"
	done

	times="$( echo $times | rev | cut -c 2- | rev) ),"
	transitions="$( echo $transitions | rev | cut -c 2- | rev) ),"
	values="$( echo $values | rev | cut -c 2- | rev) ]"

	echo $times >> $nametscn
	echo $transitions >> $nametscn
	echo $values >> $nametscn
	
	cat >> $nametscn <<< $part4

	echo "position = Vector2( 0, -0$(echo "$gif_dimensiony / 2" | bc -l) )" >> $nametscn
	echo "hframes = $hframes" >> $nametscn
	echo "vframes = $vframes" >> $nametscn
	
	cat >> $nametscn <<< $part5

done


echo "Done"
