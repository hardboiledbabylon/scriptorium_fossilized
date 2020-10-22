#!/usr/bin/env bash

LIBRARY=~/scriptorium/LIBRARY

FILES="but_not_for_us"
WEBSITE="www.hardboiledbabylon.com"
EMAIL="authorfunction@hardboiledbabylon.com"
IMPRINT="Hardboiled Babylon"
DEDICATION="For the one left at the altar."
CATCHLINE="Somehow, Harry had stopped halfway between \
                    both windows\ellipsisPeriod"
COPYRIGHT_YEAR="2020"
KEYWORDS=""
SERIAL="0050020200001"
UUID=("11C28A82-2730-4B64-9752-692D49FF4DB9" \
          "41EAD0AC-6820-45BA-964F-D83EF4387AF1")

. "${LIBRARY}/bbuild.shlib"

main "$@"
