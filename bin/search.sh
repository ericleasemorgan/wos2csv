#!/usr/bin/env bash

# search.sh - a three-time front-end to search-retrieve.py

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 14, 2022 - first cut


# configure search script
SEARCHRETRIEVE='./bin/search-retrieve.py'

# configure search queries
SEARCHAPSR='so="AMERICAN POLITICAL SCIENCE REVIEW"'
SEARCHASQ='so="ADMINISTRATIVE SCIENCE QUARTERLY"'
SEARCHECO='so="ECONOMETRICA"'

# configure output directories
DIRECTORYAPSR='./journals/apsr'
DIRECTORYASQ='./journals/asq'
DIRECTORYECO='./journals/eco'

# make sane; create output directories
mkdir -p $DIRECTORYAPSR
mkdir -p $DIRECTORYASQ
mkdir -p $DIRECTORYECO

# do the work; search
$SEARCHRETRIEVE "$SEARCHAPSR" "$DIRECTORYAPSR"
$SEARCHRETRIEVE "$SEARCHASQ"  "$DIRECTORYASQ"
$SEARCHRETRIEVE "$SEARCHECO"  "$DIRECTORYECO"

# done
exit
