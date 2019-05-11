#!/bin/sh

if [ $# -ne 1 ] ; then
    echo "Usage: build.sh <format>"
    echo "Example: build.sh png"
    exit 1
fi

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

for file in $MYDIR/*.gv ; do
    eval "dot -T$1 $file > ${file%.*}.$1"
done

