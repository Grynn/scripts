Scripts: Grynn's misc. sysadmin scripts
====

## Layout

./ubuntu: scripts that are specific to Ubuntu (or Debian)
./local: sub-module that is not pushed to github, may contain private tokens
./dropbox/upload: Dropbox Uploader (sub-module)

## Cloning 

    git clone https://github.com/grynn/scripts
    git submodule update --init   #Only required if you need dropbox/uploader
