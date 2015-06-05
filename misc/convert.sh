#!/bin/bash

if [ -z "${1}" ]; then 
	echo "Usage: $(basename $0) filename..."
	die
fi

for fn in "$@"; do
	ofn="${fn%.*}.mp4"
	echo "Converting $fn to $ofn"
	ffmpeg -i "${fn}" -y -vprofile baseline -level 3 -vcodec libx264 -g 30 -vf yadif -f mp4 "${ofn}"
done
