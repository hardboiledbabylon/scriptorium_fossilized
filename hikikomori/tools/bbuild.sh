#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="american_hikikomori"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="To a post office box filling somewhere with {sc>}ISP{<sc} \
               copyright notices, body siezed up into singular convulsion."
COPYRIGHT_YEAR="2020"
KEYWORDS=""
SERIAL="0100020200001"
UUID=(4F2027F8-7F89-4DFA-A88D-2314812A4895 \
          E3D2D928-F1F5-4E23-8C4B-E0D58474F019)

. "${LIBRARY}/bbuild.shlib"

function latex_pre_filter_hook () {
    ${BIN}/setup_hangindent_latex.pl | \
        paba.pl '^{HANGWIDTH>}' '' '{<HANG_END}' | \
        rmspcpttn.pl -Q '{DROP_FIX1}'
}

function epub_pre_filter_hook () {
    ${BIN}/setup_bold_epub.pl
}

function epub_split_hook () {
    fsplit.pl -d '{!!}{@}{epub_break}' 'section' 'Section'
}

function epub_pre_pack_hook () {

    . "${LIBRARY}/boo.shlib"

    boo_prefill "${1}"

    echo 'squeak.html||Squeak'
    echo 'section_0001.html||Section 1'
    echo 'section_0002.html||Section 2'
    echo 'section_0003.html||Section 3'
    echo 'section_0004.html||Section 4'
    echo 'section_0005.html||Section 5'
    echo 'potm1.html||Piece of the Moon 1'
    echo 'section_0006.html||Later'
    echo 'section_0007.html||Section 6'
    echo 'potm2.html||Piece of the Moon 2'
    echo 'section_0008.html||Much Later'
    echo 'section_0009.html||Section 7'
    echo 'potm3.html||Piece of the Moon 3'
    echo 'section_0010.html||Way Later'
    echo 'section_0011.html||Section 8'
    
}

main "$@"
