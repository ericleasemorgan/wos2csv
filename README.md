

# Web of Science to CSV (wos2csv)

TL;DNR - Given one or more queries, search Web of Science, download results, and output a CSV file of bibliographics. Such is an example of how I practice librarianship and digital scholarship.


## Requirements

To use this system one needs a few things, which are all installable on any desktop computer:

  1. a sane version of Bash, complete with a very cool utility called [GNU Parallel](https://www.gnu.org/software/parallel/)
  2. Python, and specifically a module called [wos](https://wos.readthedocs.io) 
  3. Perl, and specifically two modules called [Text::CSV](https://metacpan.org/pod/Text::CSV) and [XML::XPath](https://metacpan.org/pod/XML::XPath)


## Usage

Here is how to make the system go:

  1. edit [`./bin/search.sh`](https://github.com/ericleasemorgan/wos2csv/blob/main/bin/search.sh) to configure the desired Web of Science queries and denote where results will be saved
  2. run [`./bin/search.sh`](https://github.com/ericleasemorgan/wos2csv/blob/main/bin/search.sh), and this will result is the caching of many XML files
  3. run [`./bin/batch2csv.sh`](https://github.com/ericleasemorgan/wos2csv/blob/main/bin/batch2csv.sh) thus looping through the XML files and creating a corresponding set of CSV files
  4. run [`./bin/reduce.sh`](https://github.com/ericleasemorgan/wos2csv/blob/main/bin/reduce.sh) to concatenate all the CSV files into a single CSV file (./citations.csv) complete with a header row denoting the following fields: identifier, authors, lead_author_first, lead_author_last, article_title, journal_title, year, volume, issue, page_begin, page_end, page_count, doi, and type
  5. done


## Librarianship and digital scholarship

Such is an example of how I practice librarianship and digital scholarship.

Students and faculty members come to me and say things like "I would like to create a collection of ______, and then I would like some help when it comes to analyzing the same." In this particular case, I believe the faculty member wants to learn to what degree gender and institutional affiliation affect academic success. To that end the citations exported by this system will be (programmatically) augmented with gender values, institutional affiliations, and maybe ranks. Once that is done correlations will be sought and the research question will be addressed. 

I consider this work to be in the realm of librarianship. I am creating collections, organizing them, preserving them (somewhat), and disseminating them back out again, albeit to a very small audience. I am also supporting digital scholarship -- the process of answering research questions with the help of computer technology.

Professional fun in the 21st Century.

--- 
Eric Lease Morgan &lt;[emorgan@nd.edu](mailto:emorgan@nd.edu)&gt; <br />
December 15, 2022

