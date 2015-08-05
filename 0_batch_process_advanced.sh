mkdir output trash > /dev/null 2>&1

for file in *
do
  if [ ${file: -4} != ".mp3" ] ; then
    continue  # Skip conditions.
  fi
  echo -e "\nCURRENT FILE:    $file"
  read -p "Set song title:  " title
  read -p "Set artist name: " artist
  read -p "Set album arist: " album_artist
  read -p "Set album name:  " album
  read -p "Set song year:   " year
  read -p "Set song genre:  " genre
  read -p "Set the front offset (in seconds): " start_point
  read -p "Set the end point MINUS front offset (MM:SS format): " end_point
  out_file="$artist - $title.mp3"

  if [ "$out_file" = ' - .mp3' ] ; then
    continue # Skip if everything was blank.
  fi

  if [ -f "pic.jpg" ] ; then
    pic="pic.jpg"
  elif [ -f "pic.png" ] ; then
    pic="pic.png"
  fi

  echo -e "\nProcessing..."

  ffmpeg -i "$file" \
  -metadata title="$title" \
  -metadata artist="$artist" \
  -metadata album_artist="$album_artist" \
  -metadata album="$album" \
  -metadata date="$year" \
  -metadata genre="$genre" \
  -codec:a libmp3lame \
  -qscale:a 2 \
  -f mp3 temp.mp3 > /dev/null 2>&1
  
  ffmpeg -i temp.mp3 -codec:a libmp3lame -ab 160k temp2.mp3 > /dev/null 2>&1
  rm temp.mp3

  ffmpeg -ss $start_point \
  -i temp2.mp3 \
  -i "$pic" \
  -map 0:0 -map 1:0 \
  -metadata:s:v title="Album cover" \
  -metadata:s:v comment="Cover (Front)" \
  -to 00:$end_point \
  -acodec copy output/"$out_file" > /dev/null 2>&1

  rm temp2.mp3

  rm "$pic"
  mv "$file" trash
  echo -e "Done!"
done
