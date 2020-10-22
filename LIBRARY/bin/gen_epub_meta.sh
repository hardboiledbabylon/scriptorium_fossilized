#!/usr/bin/env bash

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

mkdir META-INF

printf '<?xml version="1.0"?>\n' >META-INF/container.xml
printf '<container version="1.0" ' >>META-INF/container.xml
printf 'xmlns="urn:oasis:names:tc:opendocument:xmlns:container">\n' \
>>META-INF/container.xml
printf '<rootfiles>\n' >>META-INF/container.xml
printf '<rootfile full-path="content.opf" ' >>META-INF/container.xml
printf 'media-type="application/oebps-package+xml"/>\n' \
>>META-INF/container.xml
printf '</rootfiles>\n' >>META-INF/container.xml
printf '</container>\n' >>META-INF/container.xml

printf 'application/epub+zip' >mimetype
