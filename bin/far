#!/bin/sh
set -e

exe=$(basename $0)

die() {
    echo 1>&2 "$1"
    exit 1
}

usage() {
    cat 1>&2 <<-USAGE
usage: $exe [ACK_OPTIONS] FIND REPLACE [FILES]

Examples:
    # A simple, recursive, find and replace
    $exe perl ruby

    # A simple, recursive, file-type specific, find and replace
    $exe --ruby Rails Sinatra

    # A simple, non-recursive, find and replace in src/
    $exe --python -n foo bar src/

See also:
    ack(1), perl(1)
USAGE
    exit 1
}

ACKOPTS=
while echo "$1" | grep -q "^-"; do
    ACKOPTS="$ackopts $1"
    shift
done

[ "$#" -lt 2 ] &&
    usage

from="$1" ; shift
to="$1" ; shift
src=$(ack -l $ACKOPTS "$from" $@)

perl -p -i -e "s/$from/$to/g" $src
