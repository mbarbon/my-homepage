#!/usr/bin/perl -w

use strict;
use warnings;
use Text::Markdown qw(markdown);
use File::Slurp qw(read_file write_file);
use MIME::Parser;
use XML::Writer;
use File::Basename qw(basename);

my( $md, $out ) = @ARGV;
my $parser = MIME::Parser->new;
$parser->output_to_core( 1 );
my $entity = $parser->parse_open( $md );
my $head = $entity->head;
my $xml;
my $html = markdown( join '', @{$entity->body} );
my $wr = XML::Writer->new
             ( OUTPUT => \$xml,
               UNSAFE => 1,
               DATA_MODE => 1,
               DATA_INDENT => 2,
               );

sub _g {
    my $v = $head->get( $_[0] );
    chomp $v if defined $v;

    return $v;
}

$html =~ s[<(?!xhtml:)(\w+)][<xhtml:$1]g;
$html =~ s[</(?!xhtml:)(\w+)][</xhtml:$1]g;

$wr->xmlDecl();
$wr->startTag( 'item', 'xmlns:xhtml' => 'http://www.w3.org/1999/xhtml' );
$wr->dataElement( 'title', _g( 'title' ) )
  if defined _g( 'title' );
$wr->dataElement( 'description', _g( 'description' ) )
  if defined _g( 'description' );
if( defined _g( 'date' ) && defined _g( 'date-rfc822' ) ) {
    $wr->dataElement( 'date', _g( 'date' ),
                      rfc822 => _g( 'date-rfc822' ) );
}
$wr->dataElement( 'id', basename( $md, '.md' ) );
$wr->startTag( 'content' );
$wr->raw( $html );
$wr->endTag( 'content' );
$wr->endTag( 'item' );

write_file( $out, $xml );
