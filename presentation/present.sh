#!/bin/bash
set -e

if [ "$#" -ne 1 ] ; then
    echo "Usage: $(basename "$0") <hoverCraft presentation>"
    exit
fi

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PRES_DIR=$(dirname "$(pwd)/$1")
PRES_FILE=$(basename "$(pwd)/$1")

cd "$SCRIPTDIR"/../graphics/
source "$SCRIPTDIR"/../graphics/build.sh svg
source "$SCRIPTDIR"/../graphics/build.sh png

FONT_DIR=$SCRIPTDIR/"../fonts"
GRAPH_DIR=$SCRIPTDIR/"../graphics"

cp -r $FONT_DIR $PRES_DIR
cp -r $GRAPH_DIR $PRES_DIR

cd $PRES_DIR

echo "Hovercraft on 127.0.0.1:9005"
if [[ $(uname) == MINGW64* ]] ; then
     hovercraft -N -p "0.0.0.0:9005" \
        $PRES_FILE
else
    hovercraft -N -p "0.0.0.0:9005" \
        $PRES_FILE
fi


