#!/usr/bin/env python

# search-retrieve.py - given a query and an output directory, download XML streams from Web of Science

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 14, 2022 - first documentation; based on previous work


# configure
COUNT  = 100
OFFSET = 1
BATCH  = 0

# require
from wos import WosClient
import sys

# sanity check
if len( sys.argv ) != 3 :
	sys.stderr.write( 'Usage: ' + sys.argv[ 0 ] + " <query> <directory>\n" )
	exit()

# initialize
query     = sys.argv[ 1 ]
directory = sys.argv[ 2 ]

# search/retrieve
with WosClient() as client :

	# get metadata
	metadata = client.search( query, count=0 )

	# parse and debug
	queryId = metadata.queryId
	total   = metadata.recordsFound
	sys.stderr.write( "                query id: " + str( queryId ) + "\n" )
	sys.stderr.write( " total number of records: " + str( total )   + "\n" )

	# initialize some more
	count  = COUNT
	offset = OFFSET
	batch  = BATCH
	
	# retrieve, forever
	while True :

		# configure output
		batch = batch + 1
		file  = '%03d' % batch
		file  = "records-" + file + ".xml"
		file  = directory + '/' + file

		# search
		sys.stderr.write( "Retrieving " + str( count ) + " records of " + str( total ) + " starting at record " + str( offset ) + " (" + file + ")\n" )
		results = client.retrieve( queryId, count=count, offset=offset )

		# save; easier with os-level redirection
		handle = open( file, 'w' ) 
		handle.write( results.records ) 
		handle.close() 
		
		# increment and done, conditionally		
		offset = offset + count
		if ( offset > total ) : break

# done
exit()