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

# will create metadata.opf & toc.ncx in the current directory
# from the contents of a .boo file


use strict;
use warnings;
use utf8;
use open qw(:std :utf8);
use POSIX qw(strftime);

my $UNKNOWN="UNKNOWN_INFO";
my $TITLE="";
my $SUB="";
my $UUID="";
my $AUTH="";
my $PUBLISHER="";
my $WEB="";
my $SUBJECT="";
my $DESC="";
my $RIGHTS="";
my $ID=$UUID;
my $DATE=strftime("%F", gmtime());
my $COVER_IMG="cover.jpg";
my $COVER_PAGE="cover.html";

(my $content_opf_preamble = q{<?xml version="1.0"?>

<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="dcidid" version="2.0">

<metadata xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:opf="http://www.idpf.org/2007/opf">
});

(my $toc_preamble = q{<?xml version="1.0"?>
<!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN" 
"http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">

<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">

<head>
});

sub xml_escape {
    my $n = shift;
    $n =~ s/\&/\&amp\;/g;
    $n =~ s/\</\&lt\;/g;
    $n =~ s/\>/\&gt\;/g;
    $n =~ s/\"/\&quot\;/g;
    $n =~ s/\'/\&apos\;/g;
    return $n;
}
                       
sub mimetype {
    my $n = shift;
    if( $n =~ m/\.xhml$/ ){
        return("application/xhtml+xml");
    }
    if( $n =~ m/\.html$/ ){
        return("application/xhtml+xml");
    }
    if( $n =~ m/\.jpg$/ ){
        return("image/jpeg");
    }
    if( $n =~ m/\.css$/ ){
        return("text/css");
    }
    die "unknown file mime type."
}
    
my $input_file;

if( @ARGV > 1 ){
    die "Too many file argument, can only handle one at a time.";
}
elsif( @ARGV == 1 ){
    open($input_file, '<', $ARGV[0]) or die "Couldn't open input: $ARGV[0]";
}
else{
    $input_file = *STDIN;
}

my @BOOS;
my %BOOC;
my %FILES;
my $idn = 0;
my $linen = 0;

my @files = glob( '*');

foreach my $f ( @files ){
    $FILES{$f}{"id"} = "id" . $idn;
    $FILES{$f}{"name"} = $f;
    $FILES{$f}{"text"} = "";
    $idn++;
}

while( my $line = <$input_file> ){

    $linen++;

    $line =~ s/^\s+//;
    $line =~ s/\s+$//;

    if( $line =~ m/^$/ ){
        next;
    }

    # command
    if( $line =~ m/^\!(isbn|title|sub|auth|cover_img|cover_page):(.*)/ ){
        if( $1 eq "isbn" ){
            $UUID = xml_escape($2);
        }
        elsif( $1 eq "title" ){
            $TITLE = xml_escape($2);
        }
        elsif( $1 eq "sub" ){
            $SUB = xml_escape($2);
        }
        elsif( $1 eq "auth" ){
            $AUTH = xml_escape($2);
        }
        elsif( $1 eq "cover_img" ){
            $COVER_IMG=$2;
        }
        elsif( $1 eq "cover_page" ){
            $COVER_PAGE=$2;
        }
        else{
            die "unrecognized command: $1 on line: $linen";
        }
        next;
    }

    $line =~ s/^\\\!/\!/;

    if( $line =~ m/(.+?)\|\|(.+)/ ){
        push @BOOS, $1;
        $BOOC{$1} = $2;
    }
    else{
        die "bad boo at line: $linen.";
    }
}

foreach my $ENT ( keys %BOOC ){
    if( exists $FILES{$ENT} ){
        $FILES{$ENT}{"text"} = xml_escape($BOOC{$ENT});
    }
}

#this only has one date field
#technically it should append a new date
#when a new version in created
#so there is a version history
(my $content_opf_meta = qq{  <dc:title>$TITLE</dc:title>
  <dc:language xsi:type="dcterms:RFC3066">en</dc:language>
  <dc:identifier id="dcidid" opf:scheme="URI">$UUID</dc:identifier>
  <dc:subject>$SUBJECT</dc:subject>
  <dc:description>$DESC</dc:description>
  <dc:relation>$WEB</dc:relation>
  <dc:creator>$AUTH</dc:creator>
  <dc:publisher>$PUBLISHER</dc:publisher>
  <dc:date xsi:type="dcterms:W3CDTF">$DATE</dc:date>
  <dc:rights>$RIGHTS</dc:rights>
  <meta name="cover" content="$FILES{$COVER_IMG}{id}"/>
</metadata>

});

(my $toc_meta = qq{  <meta name="dtb:uid" content="$UUID"/>
  <meta name="dtb:depth" content="2"/>
  <meta name="dtb:totalPageCount" content="0"/>
  <meta name="dtb:maxPageNumber" content="0"/>
</head>

<docTitle>
  <text>$TITLE</text>
</docTitle>

});

open( my $opf, '>', "content.opf") or die "couldn't create content.opf";

print $opf $content_opf_preamble;
print $opf $content_opf_meta;

print $opf "<manifest>\n";
print $opf "  <item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\" />\n";

foreach my $k ( keys %FILES ){
    print $opf "  <item id=\"" . $FILES{$k}{"id"} . "\" href=\"" . $k . "\" media-type=\"" . mimetype($k) ."\" />\n";
}

print $opf "</manifest>\n\n";

print $opf "<spine toc=\"ncx\">\n";

foreach my $ENT ( @BOOS ){
    print $opf "  <itemref idref=\"" . $FILES{$ENT}{"id"} . "\" />\n";
}

print $opf "</spine>\n\n";

print $opf "<guide>" . "\n" . "<reference href=\"" . $COVER_PAGE . "\" type=\"cover\"/>" . "\n" . "</guide>" . "\n\n";

print $opf "</package>\n";

close($opf);

open( my $toc, '>', "toc.ncx") or die "couldn't create toc.ncx";

my $play = 1;

print $toc $toc_preamble;
print $toc $toc_meta;

print $toc "<navMap>\n";

foreach my $ENT ( @BOOS ){
    print $toc "  <navPoint id=\"navPoint-" . $play . "\" playOrder=\"" . $play . "\">\n";
    print $toc "    <navLabel>\n";
    print $toc "      <text>" . $FILES{$ENT}{"text"} . "</text>\n";
    print $toc "    </navLabel>\n";
    print $toc "    <content src=\"" . $FILES{$ENT}{"name"} . "\"/>\n";
    print $toc "  </navPoint>\n";
    $play++;
}

print $toc "</navMap>\n\n</ncx>\n";

close($toc);
