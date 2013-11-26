#!/bin/sh

set -e

# --- Command line
refname="$1"
oldrev="$2"
newrev="$3"

# --- Safety check
if [ -z "$GIT_DIR" ]; then
        echo "Don't run this script from the command line." >&2
        echo " (if you want, you could supply GIT_DIR then run" >&2
        echo "  $0 <ref> <oldrev> <newrev>)" >&2
        exit 1
fi

if [ -z "$refname" -o -z "$oldrev" -o -z "$newrev" ]; then
        echo "Usage: $0 <ref> <oldrev> <newrev>" >&2
        exit 1
fi

web="<%= @webpath %>"
app="<%= @repoName %>"

if [ -w "$web" ] ; then
    sudo rm -Rf "$web"
fi

mkdir -p "$web"

# Since the repo is bare, we need to put the actual files someplace
git archive $newrev | tar -x -C $web

echo "Deployed $newrev $refname to $web"

env

cd "$web"

if [ -w "$web/Makefile" ] ; then
    echo "*** Makefile detected. Making App..."
    make
fi

if [ -w "$web/Procfile" ] ; then
    echo "*** Procfile detected"

    if status $app | grep -qc "start/running"; then
        echo "*** Stopping $app app"
        sudo stop $app
    fi

    echo "*** Export app to upstart"
    sudo foreman export --app $app --user root upstart /etc/init

    echo "*** Starting app $app"
    sudo start $app
    tail -f /var/log/$app/*.log
fi

exit 0
