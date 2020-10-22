#!/usr/bin/env perl

# Copyright © 2019 by D. F. Hall <authorfunction@hardboiledbabylon.com>

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

use strict;
use warnings;
use utf8;
use open qw(:std :utf8);

my $match_p;
my $match_s;

while( my $line = <STDIN> ){
    if($line =~ m/^\[/){
        if($line !~ m/^\[\{i\>\}/){
            if($line =~ m/^(\[.+?\])/){
                $match_p = $1;
                print "{b>}" . $match_p . "{<b}";
                $line =~ s/^\[.+\]//;
            }
        }
    }

    print $line;
}

