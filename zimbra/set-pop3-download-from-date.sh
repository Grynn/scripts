#!/bin/bash

set -e

TGT_DATE=${2:-3 days ago}
if [ -z $1 ]; then 
	echo "Usage: `basename $0` account@domain.com [2 days ago]"
	exit -1;
fi

echo zmprov ma ${1} zimbraPrefPop3DownloadSince $(date --date="${TGT_DATE}" "+%Y%m%d%H%M%S"Z)
