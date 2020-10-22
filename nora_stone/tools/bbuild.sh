#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="nora_stone"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="Extra! Extra!  Have you heard?  Have you heard about the man who had his Robots taken away from him by the people he wanted to set free?"
COPYRIGHT_YEAR="2020"
KEYWORDS=""
SERIAL="0040020200001"
UUID=(F089054A-8DF5-4AE4-9DDC-994F6C034F3F \
          F2236254-4546-47DD-AF97-3CF6F7D46C5E )

. "${LIBRARY}/bbuild.shlib"

function epub_split_hook {
    fsplit.pl '{SECTION}' 'section' ''
}

function epub_post_split_hook {
    echo '{!!}{@}{split_name}Epilogue (1st Part)' >epilogue_1
    cat section_0001 >>epilogue_1
    rm section_0001
    echo '{!!}{@}{split_name}Break' >break
    echo '{CONCEPT_BREAK}' >>break
    echo '{!!}{@}{split_name}Epilogue (2nd Part)' >epilogue_2
    ${SED_CMD} -e 's/^{SECTION}/{PADDING}/' \
	       -e '/^{CONCEPT_BREAK}/d' <section_0002 >>epilogue_2
    rm section_0002
}

function epub_pre_pack_hook () {

    . "${LIBRARY}/boo.shlib"

    boo_prefill "${1}"
    echo 'epilogue_1.html||Epilogue (1st Part)'
    echo 'break.html||Break'
    echo 'epilogue_2.html||Epilogue (2nd Part)'

}

main "$@"
