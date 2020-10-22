#!/bin/bash

# Copyright © 2020 by D. F. Hall <authorfunction@hardboiledbabylon.com>

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

set -e -x
set -o pipefail

LIBRARY=~/scriptorium/LIBRARY
MEDIA=""
SHOWFRAME=""
COPYING=""
COPYRIGHT=""

PDF_OUTLINE=""

SED_CMD='gsed'
GREP_CMD='ggrep'

rm -rf _output_
mkdir _output_

### ARGS

while test "${1}" != ""
do
    case "${1}" in
        -outline)
            PDF_OUTLINE="-dNoOutputFonts"
            ;;
        print)
            MEDIA='print'
            ;;
        web)
            MEDIA='web'           
            ;;
        showframe)
            SHOWFRAME='showframe'
            ;;
        copying)
            COPYING='copying'
            ;;
        copyright)
            COPYRIGHT='copyright'
            ;;
	*)
	    echo "unknown option: $1"
	    exit 1
	    ;;
    esac
    shift
done

# copyright automatically determines media type
if test -n "${COPYRIGHT}"
then
   MEDIA=web
   SHOWFRAME=""
fi

if test "${MEDIA}" = ""
then
    echo 'need media (print|web)'
    exit 1
fi

### ARGS

if ! test -f what.info
then
    echo 'need what.info'
    exit 1
fi

TITLE="$(${GREP_CMD} '^TITLE=..*' what.info | \
               ${SED_CMD} -e 's/TITLE=//')"
OUTPUT="$(${GREP_CMD} '^OUTPUT=..*' what.info | \
                ${SED_CMD} -e 's/OUTPUT=//')"

if test "${OUTPUT}" = "" -o "${TITLE}" = ""
then
    echo 'what.info needs output_name & title'
    exit 1
fi


if test "${MEDIA}" != "print"
then
    PRINT_TARG='\let\isPRINT=n '
fi

if test -n "${SHOWFRAME}"
then
    FRAME_ARG='\let\doSHOWFRAME=y '
fi

if test -n "${COPYING}"
then
    COPY_ARG='\let\doCOPYING=y '
fi

if test -n "${COPYRIGHT}" 
then
    COPYRIGHT_ARG='\let\doFRONTMATTER=n '
fi

TEX_TARG="${PRINT_TARG}${FRAME_ARG}${COPY_ARG}${COPYRIGHT_ARG}\input"

lualatex -halt-on-error -interaction=nonstopmode \
         -jobname=__output \
         "${TEX_TARG}" main.tex


if test "${MEDIA}" = "print"
then
    # warning if /usr/local/ghostscript/X.XX/lib/PDFX_def.ps
    # exists it overrides the file of the same name
    # in the current directory, so be sure to use a
    # name other than PDFX_def.ps
    ${SED_CMD} <"${LIBRARY}/latex/PDFX_def.ps" \
               -e "s/###TITLE###/${TITLE}/" \
               >pdfx.ps

    # ghostscript only produces pdf/x-3 but most places
    # seem to accept it in place of pdf/x-1a
    # no profile should be embedded for enteriors
    # that are just text
    #
    # OR if -outline is specified
    # do that instead to sidestep font issues completely.
    # However, this will be __much__ slower, and the file
    # size will be __much__ larger.  But, still, sometimes
    # it's necessary.
    gs -SDEVICE=pdfwrite -sOutputFile=__output.pdfx \
       -sColorConversionStrategy=Gray -dNOPAUSE \
       -dBATCH -dPDFX ${PDF_OUTLINE} pdfx.ps __output.pdf
    
    cp __output.pdfx __output.pdf

    NPAGES=$(pdfinfo __output.pdf | \
                       grep Pages | \
                       sed 's/^Pages: *//')
    
    if (( "${NPAGES}" % 2 != 0 ))
    then
        echo "PAGE COUNT OF PRINT BOOKS SHOULD BE DIVISIBLE BY 2"
        exit 1
    fi
else
    # since pdf_web covers are usually stored at
    # 300dpi, downscale to decrease file size
    # pdf 1.4 seems generally smaller than 1.3
    gs -dNOPAUSE -dBATCH  -sDEVICE=pdfwrite \
       -dPDFSETTING=/ebook -dCompatibilityLevel=1.4 \
       -dColorImageDownsampleType=/Bicubic \
       -dGrayImageDownsampleType=/Bicubic \
       -dMonoImageDownsampleType=/Bicubic \
       -sOutputFile=__output.pdfa __output.pdf

    cp __output.pdfa __output.pdf
fi

cp __output.pdf _output_/"${OUTPUT}.pdf"

