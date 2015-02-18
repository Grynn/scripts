#/bin/sh

if [ -z "$1" ] || [ ! -f "$1" ]
then
   echo "Usage $(basename $0) filename"
   exit 1
fi

BASENAME=$(basename "$1")
FNAME="${BASENAME%.*}"
FNAME="$FNAME.torrent"
ctorrent -t -u "udp://tracker.publicbt.com:80" -s "$FNAME" "$1"
