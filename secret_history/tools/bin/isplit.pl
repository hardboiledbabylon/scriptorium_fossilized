#!/usr/bin/env perl

# Copyright © 2017 by D. F. Hall <authorfunction@hardboiledbabylon.com>

# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.

# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
# OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

use utf8;

use strict;
use warnings;
use open qw(:std :utf8);

use constant FALSE => 1==0;
use constant TRUE => not FALSE;

if( @ARGV != 4 ){
    die "bad arguments";
}

my $splitmark = qr/$ARGV[0]/;
my $splitmark_alt_end = qr/$ARGV[1]/;
my $open_rep = $ARGV[2];
my $close_rep = $ARGV[3];


if( 0 ){
    print "arg0: $ARGV[0]\n";
    print "s: $splitmark\n";
    print "sae: $splitmark_alt_end\n";
    print "or: $open_rep\n";
    print "cr: $close_rep\n";
    exit;
}

my $opening = FALSE;
my $line;

while($line = <STDIN>){

    if( $line !~ /$splitmark/ ){
	print $line;
    }
    else{
	print $open_rep . "\n";
	last;
    }
}

my $ALT_END = FALSE;

while($line = <STDIN>){

    if( $line =~ /$splitmark_alt_end/ ){
	print $close_rep . "\n\n";
	print $line;
	$ALT_END = TRUE;
    }
    elsif( $line =~ /$splitmark/ ){
	if( $ALT_END == TRUE ){
	    $ALT_END = FALSE;
	    print $open_rep . "\n";
	}
	else{
	    print $close_rep . "\n\n" . $open_rep . "\n";
	}
    }
    else{
	print $line;
    }
}

print $close_rep . "\n\n"
