#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="shom_vol1 shom_vol2 shom_vol3"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="To S., who saved this book from its Author Function."
COPYRIGHT_YEAR="2020"
KEYWORDS=""
UUID=(1447A98A-049F-44F7-B1E2-B32099FF8EAC \
          766781A-DC65-4DF5-A21A-1AAEF8FC9025)

. "${LIBRARY}/bbuild.shlib"

function epub_pre_split_hook {
    fisml_footnoter.pl -NAq
}

function epub_post_split_hook {

    for s in *
    do
	if ${FGREP_CMD} -e '{::IMAGE::EMAIL::}' \
                        -e '{::NOT_SIGN::}' \
		        -e '{::IMAGE::WARNING::}' "${s}" >/dev/null
	then
	    ${SEDi_CMD} -e '/^{SECTION}/d' "${s}"
	fi
    done

    for s in *
    do
	if ${FGREP_CMD} -e '{::IMAGE::BKUPS::}' \
		        -e '{::IMAGE::GITLOG::}' \
		        -e '{::IMAGE::SCRIPT::}' \
		        -e '{::IMAGE::TOOTFRUIT::}' "${s}" >/dev/null
	then
	    ${SEDi_CMD} -e 's/^{SECTION}/{SECTION_ALT}/' "${s}"
	fi
    done

    for i in ii iii iv v vi vii
    do
        if test -f "book${i}_section_0000"
        then
            mv "book${i}_section_0000" "book${i}"
        fi
    done

}

function latex_pre_filter_hook () {
    fisml_footnoter.pl -NAx | \
	${BIN}/isplit.pl '{SECTION}' '{SHOM_BOOK_.+?}' '{SECTION>}' '{<SECTION}'
}

function epub_split_hook () {
    fsnip.pl '{TELETYPE[23]*>}' '{<TELETYPE[23]*}' | \
	${BIN}/fsplit.pl '^{<*SECTION[2>]*}|^{SHOM_BOOK_.+?}' \
              'section' 'Section'
}

function epub_pre_pack_hook () {

    . "${LIBRARY}/boo.shlib"

    boo_prefill_builtin_subtitle "${1}"

    if test -f booki_section_0001.html
    then
        boo_sect_loop 'booki_section_*.html'
        echo 'bookii.html||Book II' 
        boo_sect_loop 'bookii_section_*.html'
    fi
    if test -f bookiii.html
    then
        echo 'bookiii.html||Book III' 
        boo_sect_loop 'bookiii_section_*.html'
        echo 'bookiv.html||Book IV' 
        boo_sect_loop 'bookiv_section_*.html'
    fi
    if test -f bookv.html
    then
        echo 'bookv.html||Book V' 
        boo_sect_loop  'bookv_section_*.html'
        echo 'bookvi.html||Book VI' 
        boo_sect_loop 'bookvi_section_*.html'
        echo 'bookvii.html||Book VII' 
        boo_sect_loop 'bookvii_section_*.html'
    fi
}

main "$@"
