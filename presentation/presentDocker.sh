#!/bin/bash
set -e

if [ "$#" -ne 1 ] ; then
    echo "Usage: $(basename "$0") <hoverCraft presentation>"
    exit
fi

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source "$SCRIPTDIR"/../graphics/build.sh svg
source "$SCRIPTDIR"/../graphics/build.sh png

PRES_DIR=$(dirname "$1")
PRES_FILE=$(basename "$1")

FONT_DIR=$SCRIPTDIR/"../fonts"
GRAPH_DIR=$SCRIPTDIR/"../graphics"

if [[ $(uname) == MINGW64* ]] ; then
    docker run -i --rm -p "9000:9000" \
        -v $(pwd)/$PRES_DIR/:/presentation \
        -v $FONT_DIR/:/presentation/fonts \
        -v $GRAPH_DIR/:/presentation/graphics \
        phpcommunity/hovercraft \
        $PRES_FILE
else
    docker run -it --rm -p "9000:9000" \
        -v $(pwd)/$PRES_DIR/:/presentation \
        -v $FONT_DIR/:/presentation/fonts \
        -v $GRAPH_DIR/:/presentation/graphics \
        phpcommunity/hovercraft \
        $PRES_FILE
        #557f0e \
fi

