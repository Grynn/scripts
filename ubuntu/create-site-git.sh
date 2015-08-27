#!/bin/bash
#Create a git site that is ready to deploy on push. Only works on Ubuntu

set -o errexit; set -o nounset

if [ $(id -u) -ne 0 ]; then
        echo "Script must be run as root!"
        exit -1
fi

#Check that user git exists
if ! id -u git >/dev/null 2>&1; then
	echo "User git does not exist. Please run install-git.sh prior to running this script"
	exit -1
fi

opt_f=0
while getopts f opt; do
 case $opt in
    f)
      opt_f=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit -1;
      ;;
  esac
done
shift $(expr $OPTIND - 1 )

if test $# -gt 0; then
	SITE=$1
else 
	echo "Usage: `basename $0` site.com"
	exit -1
fi

SITE=~git/"$SITE"
if [ -d "$SITE" ]; then
	echo "$SITE already exists"
	if test $opt_f -eq 0; then
		echo "Refusing to clobber; will exit."
		exit -1
	fi
fi
	

#Create an example site
sudo -Hu git git init --bare "$SITE"
cat > "$SITE/hooks/post-receive" << 'EOF' 
#!/bin/bash

set -e -o nounset

echo "ARGS****************"
read oldrev newrev ref
echo "OLD=$oldrev" "NEW=$newrev" "REF=$ref"
echo "********************"

if [ $ref == "refs/heads/master" ] || [[ $ref == refs/heads/deploy* ]] ; then
	eval "$(git show master:deploy.sh)"
else
	echo "Ignoring push to $ref"
fi
EOF
chmod u+x,go-rwx "$SITE/hooks/post-receive"
chown git:nogroup "$SITE/hooks/post-receive"
