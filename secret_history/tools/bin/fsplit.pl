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

my $i = 0;
my $fh;

if( @ARGV != 3 ){
    die "bad arguments";
}

my $splitmark = qr/$ARGV[0]/;
my $fbase = $ARGV[1];
my $sectname = $ARGV[2];

if( 0 ){
    print "pr: $ARGV[0]\n";
    print "s: $splitmark\n";
    print "f: $fbase\n";
    print "n: $sectname\n";
    exit;
}

my $book = "booki";
my $BOOK = "Book I";

sub print_book {

    my $b = shift;
    my $B = shift;
    my $L = shift;
    my $out;

    my $O = $book . "_section_0000";

    open($out, '>', $O) or die "couldn't open $O";

    print $out "{!!}{@}{split_name}" . $B . "\n";
    print $out "\n$L\n";
    close($out);
}

while(my $line = <STDIN>){

    if( $line =~ /$splitmark/ ){
	if( $line =~ m/^{SHOM_BOOK_I}/ ){
	    next;
	}
	$i++;
	if( $line =~ m/^{SHOM_BOOK_II}/ ){
	    $book = "bookii";
	    $BOOK = "Book II";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}
	if( $line =~ m/^{SHOM_BOOK_III}/ ){
	    $book = "bookiii";
	    $BOOK = "Book III";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}
	if( $line =~ m/^{SHOM_BOOK_IV}/ ){
	    $book = "bookiv";
	    $BOOK = "Book IV";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}
	if( $line =~ m/^{SHOM_BOOK_V}/ ){
	    $book = "bookv";
	    $BOOK = "Book V";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}
	if( $line =~ m/^{SHOM_BOOK_VI}/ ){
	    $book = "bookvi";
	    $BOOK = "Book VI";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}
	if( $line =~ m/^{SHOM_BOOK_VII}/ ){
	    $book = "bookvii";
	    $BOOK = "Book VII";
	    $i = 0;
	    print_book( $book, $BOOK, $line );
	    next;
	}

	my $output_name = sprintf($book . "_" . $fbase . "_%04d", $i);

	if( defined $fh ){
	    close($fh);
	}

	open($fh, '>', $output_name);
	if( $sectname ne "" ){
            print $fh "{!!}{@}{split_name}" . $BOOK . " - " . $sectname . " " . $i . "\n";
	}
    }
    if( $i != 0 ){
	print $fh $line;
    }
}

if( defined $fh ){
    close($fh);
}

