#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="communists"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="This work may have been edited in order to \
                 enhance its commercial viability."
COPYRIGHT_YEAR="2020"
KEYWORDS=""
SERIAL="0090020200001"
UUID=(76A3DCC4-D0DE-4A8B-9C36-983B9AB7249A \
          4664A76B-41F7-496A-A07A-483374E17DF7)

. "${LIBRARY}/bbuild.shlib"

function latex_pre_filter_hook () {
    ${BIN}/setup_hangindent_latex.pl | \
        paba.pl '^{PHANTOM_.+\&}' '' '{MARGIN_END}' | \
        paba.pl '^{TO_MEASURE>}' '' '{<HANG_END}'
}

function epub_pre_filter_hook () {
    ${BIN}/setup_bold_epub.pl
}

function epub_split_hook () {
    fsplit.pl -d '{!!}{@}{epub_break}' 'echo' 'ECHO'
}

function epub_pre_pack_hook () {

    . "${LIBRARY}/boo.shlib"

    boo_prefill "${1}"

    boo_sect_loop 'echo_*'
}

main "$@"
