#!/usr/bin/env bash

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

# Generate images for fixed-width teletype sections since
# fixed width fonts are not guaranteed on all ereaders.
# This also ensures a fixed line width.

#invoke with cat file1 file2 | gen_epub_img.sh dir dir

set -x -e

LIBRARY=~/scriptorium/LIBRARY
TARGET=latex

function IF_EXISTS () {
    if test -f "${1}"
    then
        echo "${1}"
    fi    
}

WDIR_BASE="_epub_snips_"

WDIR=$(mktemp -d "${WDIR_BASE}.XXXXXX" || exit 1)

function txt_to_img () {

    local UNICODE=$(IF_EXISTS "${LIBRARY}/unicode/unicode.fisml")
    local GLOBAL_PLACEHOLDERS=$(IF_EXISTS "${LIBRARY}/placeholders.fisml")
    local LOCAL_PLACEHOLDERS=$(IF_EXISTS "${LIB}/placeholders.fisml")
    local TRS_LOCAL=$(IF_EXISTS "${LIB}/${TARGET}/${TARGET}.trs")
    local FISML_LOCAL=$(IF_EXISTS "${LIB}/${TARGET}/${TARGET}.fisml")

    local IN="${1}"

    cat "${IN}" | fisml_unabbrev.pl | \
        fisml_do.pl -f "${GLOBAL_PLACEHOLDERS}" \
                    -f "${LOCAL_PLACEHOLDERS}" | \
	fisml_trs.pl -f "${LIBRARY}/${TARGET}/${TARGET}.trs" \
                     -f "${TRS_LOCAL}" | \
	fisml_do.pl -f "${UNICODE}" \
                    -f "${LIBRARY}/${TARGET}/${TARGET}.fisml" \
                    -f "${FISML_LOCAL}" >"${IN}.latex.body"

    gsed <"${LIB}/${TARGET}/latex_plain.skel" \
	-e "/###BODY###/ r ${IN}.latex.body" \
	-e '/###BODY###/d' \
	>"${IN}.latex"

    mkdir -p fonts
    cp "${LIBRARY}/fonts/"* fonts/
    cp "${LIB}/fonts/"* fonts/

    lualatex -halt-on-error -interaction=nonstopmode "${IN}.latex"

    if test ${3} = "trim"
    then
	local TRIM="-trim"
    else
	local TRIM=""
    fi
    
    convert -density 1800 "${IN}".pdf'[0]' -trim +repage -crop '100%x100%+0+250' $TRIM +repage -bordercolor white -border 72 -flatten -alpha remove -resize 1600x -quality 85 -interlace JPEG -colorspace RGB -strip -sampling-factor 4:2:0 "${2}"

    rm -rf "${IN}".log "${IN}".pdf "${IN}".aux

}

function gen_epub_img () {

    (cd "${WDIR}"

     local IMG="$(basename "${OUT_D}")"

     # read from stdin
     fsnip.pl -io '{TELETYPE[23]*>}' '{<TELETYPE[23]*}'

     for SNIP in snip_*
     do
	 local SNIP_NAME=$(fisml_get_attr.pl "${SNIP}" "snip_name")
	 if test "${SNIP_NAME}" = ""
	 then
	     echo "NO SNIP_NAME DETECTED IN SNIP"
	     exit 1
	 fi
	 txt_to_img "${SNIP}" "${SNIP_NAME}" notrim
	 cp -r "${SNIP_NAME}" "${OUTPUT_DIR}"
     done

    )

}

function cleanup {
    rm -rf "${WDIR}"
}

trap cleanup EXIT

if test $# -ne 2
then
    echo "usage: gen_epu_img.sh output_dir latex_lib_dir"
    exit 1
fi

function full_path () {
    if ! test -d "${1}"
    then
	echo "${1} is not a directory"
	exit 1
    fi
    echo "$(cd "${1}" && pwd)"
}

OUTPUT_DIR=$(full_path "${1}")
LIB=$(full_path "${2}")

gen_epub_img
