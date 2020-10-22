#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="dogma1_thursday_and_friday \
       dogma2_you_cant_revolutionize_the_world \
       dogma3_terminal_dogma"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="Death, as we may call that unreality, is \
            the most terrible thing, and to keep that \
            which is dead so demands the greatest force of all."
COPYRIGHT_YEAR="2020"
KEYWORDS=""
UUID=(5FC0CCC8-5C64-4A40-AEFB-415036070043 \
      E3AB9D80-2799-4ECA-8C89-AFA8274A3139)

. "${LIBRARY}/bbuild.shlib"

function epub_split_hook () {
    fsplit.pl '^{CHAPTER_P.}|{CHAPTER_UNMARKED}' 'chapter' 'Chapter'
}

main "$@"
