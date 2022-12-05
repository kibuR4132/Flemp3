#Flemp3 by kibur
#ver. 1.1

#!/bin/bash
debugmode=false
numartist=0
numalbum=0
numsong=0

rm -r ~/Music/mp3s
mkdir ~/Music/mp3s

	##  Convert file to mp3 and display so
flac2mp3 () {
	local title=`ffprobe -loglevel error -show_entries format_tags=title \
		-of default=noprint_wrappers=1:nokey=1 "$1"`

	local artist=`ffprobe -loglevel error -show_entries format_tags=artist \
		-of default=noprint_wrappers=1:nokey=1 "$1"`
	
	printf "	Converting "
	printf "$title " | lolcat
	printf "by $artist...\n"
	printf "\tFile Name:  $1\n"
	
	ffmpeg -i "$1" -ab 320k -map_metadata 0 -vsync 2 -hide_banner \
		-loglevel error -id3v2_version 3 \
		~/Music/mp3s/${1//flac/mp3} && printf "	\033[32mSuccess!\033[0m\n"
}

	##  Display Structure
for d0 in *; do
  if [ -d "$d0" ]; then ##  DEPTH 0 Directory Check
    printf "$d0/\n"                      ##  Echo

    cd "$d0"                    ##  Enter and loop
    for d1 in * ; do            ##  DEPTH 1:

      if [ -d "$d1" ]; then     ##  DEPTH 1 Directory Check
        printf "\t$d1/\n"                        ##  Echo

        cd "$d1"                        ##  Enter and loop
        for d2 in *; do                 ##  DEPTH 2:

            if [ -d "$d2" ]; then       ##  DEPTH 2 Directory Check
              printf "\t\t$d2/\n"       ##  Echo
              printf "\t\tfurther depths \
                      not supported :(\n"
            elif [[ "$d2" == *flac ]]; then     ##  DEPTH 2 .flac Check
	      ((numsong++))		## Increment
            fi                          ## d2 fileType check end

        done                    ## Exit DEPTH 2
        cd ..                   ##

      elif [[ "$d1" == *.flac ]]; then  ##  DEPTH 1 .flac Check
	((numsong++))		## Increment
      fi                        ## d1 fileType check end

    done                ## Exit DEPTH 1
    cd ..               ##

                                ##  DEPTH 0 .flac Check
  elif [[ "$d0" == *.flac ]]; then
    ((numsong++))	## Increment
  fi                    ## d0 fileType check end

done                    ## DEPTH 0 END

echo "Found $numsong song(s) in this structure."
echo "Is that correct? y/n"
read usrchoice
! [ ${usrchoice,,} == "y" ] && exit



	##  Go through all files for 3 folder depths
	##  and convert flacs to mp3s
for d0 in *; do		##  DEPTH 0:

  if [ -d "$d0" ]; then	##  DEPTH 0 Directory Check
    printf "$d0\n"			##  Echo
    
    cd "$d0"			##  Enter and loop
    for d1 in * ; do		##  DEPTH 1:

      if [ -d "$d1" ]; then	##  DEPTH 1 Directory Check
        printf "\t$d1\n" 			##  Echo
        
	cd "$d1"			##  Enter and loop
        for d2 in *; do 		##  DEPTH 2:

            if [ -d "$d2" ]; then	##  DEPTH 2 Directory Check
              printf "\t\t$d2 is a dir\n"	##  Echo
              printf "\t\tfurther depths \
		      not supported :(\n"
            elif [[ "$d2" == *flac ]]; then	##  DEPTH 2 .flac Check
              ##printf "\t\t$d2 is a flac\n"	##  Echo
              flac2mp3 "$d2"
            fi				## d2 fileType check end

        done			## Exit DEPTH 2
        cd ..			##
     
      elif [[ "$d1" == *.flac ]]; then	##  DEPTH 1 .flac Check
        ##printf "\t$d1 is a flac\n"		##  Echo
	flac2mp3 "$d1"
      fi			## d1 fileType check end

    done		## Exit DEPTH 1
    cd ..		##
    
				##  DEPTH 0 .flac Check
  elif [[ "$d0" == *.flac ]]; then
    ##printf "$d0 is a flac\n"	##  Echo
    flac2mp3 "$d0"
  fi			## d0 fileType check end

done			## DEPTH 0 END
