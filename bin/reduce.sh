#!/usr/bin/env bash

# reduce.sh - create a single, master CSV file from all the previously created CSV files

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under the GNU Public License

# December 14, 2022 - first cut; better to send output to STDOUT


# configure
CSV='./csv'
PATTERN='*.csv'
HEADER='identifier,authors,lead_author_first,lead_author_last,article_title,journal_title,year,volume,issue,page_begin,page_end,page_count,doi,type'
CITATIONS='./citations.csv'

# initialize the output
echo $HEADER > $CITATIONS

# find all CSV files and output each one
find $CSV -type f -name "$PATTERN" -exec cat {} >> $CITATIONS \;

# done
exit
