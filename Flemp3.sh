#Flemp3 by kibur
#ver. 1.0

#!/bin/bash
debugmode=0
numartist=0
numalbum=0
numsong=0

rm -r ~/Music/mp3s
mkdir ~/Music/mp3s
[ $debugmode -eq 1 ] && pwd

echo "Finding artists..."
echo "	Finding albums..."
for artist in */; do
	((numartist++))
	cd "$artist"
	echo "${artist//\//}"
	for album in */; do
		((numalbum++))
		cd "$album"
		for track in *.flac; do 
			((numsong++))
		done
		cd ..
		echo "	${album//\//}"
	done
	cd ..
done

echo; echo

echo "Found $numartist artist(s) with $numalbum album(s) and $numsong song(s)."
echo "Is that correct? y/n"
read usrchoice
[ $usrchoice -eq "n" ] && exit





for artist in */; do				##ARTIST
	cd "$artist"
	echo "Converting $artist"

	for album in */; do			##ALBUM
		cd "$album"
		echo "Converting $album"

		for track in *.flac; do		##TRACK
			title=`ffprobe -loglevel error -show_entries format_tags=title \
				-of default=noprint_wrappers=1:nokey=1 $track`

			artist=`ffprobe -loglevel error -show_entries format_tags=artist \
				-of default=noprint_wrappers=1:nokey=1 $track`

			printf "	Converting "
			printf "$title " | lolcat
			echo "by $artist..."
			echo   "	File Name:  $track"
		
			ffmpeg -i "$track" -ab 320k -map_metadata 0 -vsync 2 -hide_banner \
				-loglevel error -id3v2_version 3 \
				~/Music/mp3s/${track//flac/mp3} && printf "	\033[32mSuccess!\033[0m\n"
			echo
		done
		cd ..
	done
	cd ..
done
