#!/usr/bin/env bash

# batch2csv.sh - a front-end to batch2csv.pl

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distriburted under a GNU Public License

# December 14, 2022 - first cut


# configure
JOURNALS='./journals'
BATCH2CSV='./bin/batch2csv.pl'
CSV='./csv'
EXTENSION='csv'
PATTERN='*.xml'
COMMANDS=''

# process each xml file
while read INPUT; do

	# create output directories and filenames
	BASENAME=$( basename $INPUT .xml )
	DIRNAME=$( dirname $INPUT )
	OUTPUTDIRECTORY=$( echo $DIRNAME | sed s"|$JOURNALS|$CSV|" )
	OUTPUTFILE="$OUTPUTDIRECTORY/$BASENAME.$EXTENSION"
	
	# debug
	#echo $INPUT           >&2
	#echo $BASENAME        >&2
	#echo $DIRNAME         >&2
	#echo $OUTPUTDIRECTORY >&2
	#echo $OUTPUTFILE      >&2
	#echo                  >&2
	
	# create the output directory
	mkdir -p $OUTPUTDIRECTORY
	
	# create a tab-delimited list of arguments to execute later
	COMMAND="$BATCH2CSV\t$INPUT\t$OUTPUTFILE"
	#echo -e $COMMAND >&2
	#echo             >&2
	
	# build up the list of commands
	if [[ $COMMANDS == '' ]]; then
		COMMANDS="$COMMAND"
	else
		COMMANDS="$COMMANDS\n$COMMAND"
	fi
	

# find all xml files
done < <( find $BATCHES -type f -name $PATTERN )

# do the work; submit the work in parallel
echo -e $COMMANDS | parallel --colsep=$'\t' {1} {2} ">" {3}

# done
exit