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
use Math::Round qw(:all);
use POSIX;

# time in seconds
my $time = 7;

while( my $line = <STDIN> ){
    if($line =~ m/^{DATE\&}/){
        $line =~ s/^{DATE\&}//;
        my $lt = 0;

        if($line =~ m/\(/){
            $lt = int(rand(7)) + 3;
            print $line;
            next;
        }
        else{
            my $c = $line;
            $lt = length($c) / 6;
            $lt = ceil( $lt / 3.6) + 2; 
        }
        
        my $min = $time / 60;
        my $sec = $time % 60;
        printf("[%02d:%02d] ", $min, $sec);
        print $line;

        $time += $lt;
        $min = $lt / 60;
        $sec = $lt % 60;
    }
    else{
        print $line;
    }

}

