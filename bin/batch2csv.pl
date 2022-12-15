#!/usr/bin/env perl

# batch2csv.pl - given the name of a specifically shaped (Web of Science) XML file, output a stream of CSV

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# December 14, 2022 - "finished" first cut


# configure
use constant TYPE => 'Article';
use constant YEAR => 1990;

# require
use strict;
use Text::CSV;
use XML::XPath;

# get input
my $xml = $ARGV[ 0 ];

# sanity check
if ( ! $xml ) {

	die "Usage: $0 <xml>\n";
	exit;
	
}

# initialize
my $parser = XML::XPath->new( filename => $xml );
my @bibliographics;

# get and process each record; create a list of bibliographics
my $records = $parser->find( '//REC' );
foreach my $record ( $records->get_nodelist ) {

	# parse the easy stuff
	my $uid        = $record->find( './UID' );
	my $year       = $record->find( './static_data/summary/pub_info/@pubyear' )->string_value();
	my $volume     = $record->find( './static_data/summary/pub_info/@vol' );
	my $issue      = $record->find( './static_data/summary/pub_info/@issue' );
	my $page_begin = $record->find( './static_data/summary/pub_info/page/@begin' );
	my $page_end   = $record->find( './static_data/summary/pub_info/page/@end' );
	my $page_count = $record->find( './static_data/summary/pub_info/page/@page_count' );
	my $doctype    = $record->find( './static_data/summary/doctypes/doctype' )->string_value();
	
	# we only want a certain type of document and after a given year
	next if ( $doctype ne TYPE );
	next if ( $year < YEAR );
	
	# authors
	my $names   = $record->find( './static_data/summary/names/name' );
	my @authors = ();
	foreach my $item ( $names->get_nodelist ) {
			
		# get a name and update the list
		my $name = $item->find( './display_name' );
		push( @authors, $name );
			
	}

	# get lead author
	my $lead_author_first = ( split( ', ', @authors[ 0 ] ) )[ 1 ];
	my $lead_author_last  = ( split( ', ', @authors[ 0 ] ) )[ 0 ];
	
	# doi
	my $identifiers = $record->find( './dynamic_data/cluster_related/identifiers/identifier' );
	my $doi         = '';
	foreach my $item ( $identifiers->get_nodelist ) {
		
		# check for specific type
		if ( $item->find( './@type' )->string_value() eq 'xref_doi' ) {
		
			$doi = $item->find( './@value' );
			last;
			
		}
					
	}
		
	# get and process each title; get the title of the article
	my $titles = $record->find( './static_data/summary/titles/title' );	
	my $article_title  = '';
	foreach my $item ( $titles->get_nodelist ) {
		
		# check for specific type
		if ( $item->find( './@type' )->string_value() eq 'item' ) {
		
			$article_title = $item->find( '.' );
			last;
			
		}
					
	}
	
	# get the title of the journal
	my $journal_title  = '';
	foreach my $item ( $titles->get_nodelist ) {
		
		# check for specific type
		if ( $item->find( './@type' )->string_value() eq 'source' ) {
		
			$journal_title = $item->find( '.' );
			last;
			
		}
					
	}

	# create a record, and update the list of records
	my @item = [ $uid, join( '; ', @authors ), $lead_author_first, $lead_author_last, $article_title, $journal_title, $year, $volume, $issue, $page_begin, $page_end, $page_count, $doi, $doctype ];
	push( @bibliographics, @item );
	
	# debug
	warn( "         identifier: $uid\n" );
	warn( "          author(s): " . join( '; ', @authors ) . "\n" );
	warn( "  lead author first: $lead_author_first\n" );
	warn( "   lead author last: $lead_author_last\n" );
	warn( "      article title: $article_title\n" );
	warn( "      journal title: $journal_title\n" );
	warn( "               year: $year\n" );
	warn( "             volume: $volume\n" );
	warn( "              issue: $issue\n" );
	warn( "         page begin: $page_begin\n" );
	warn( "           page end: $page_end\n" );
	warn( "         page count: $page_count\n" );
	warn( "                DOI: $doi\n" );
	warn( "      document type: $doctype\n" );
	warn( "\n" );
	
}

# output
my $csv    = Text::CSV->new ( { binary => 1, auto_diag => 1 } );
my $handle = *STDOUT;
$csv->say( $handle, $_ ) for @bibliographics;

# done
exit;



