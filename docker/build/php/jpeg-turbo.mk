SHELL := /bin/bash
.DEFAULT_GOAL := make_jpeg-turbo
url_jpeg-turbo = http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-${VERSION_JPGTURBO}.tar.gz 
build_dir_jpeg-turbo = ${DEPS}/jpeg-turbo

fetch_jpeg-turbo:
	mkdir -p ${build_dir_jpeg-turbo}
	${CURL} -Ls ${url_jpeg-turbo} | tar $(shell ${TARGS} ${url_jpeg-turbo}) ${build_dir_jpeg-turbo} --strip-components=1

configure_jpeg-turbo:
	cd ${build_dir_jpeg-turbo} && \
	$(CMAKE)-DCMAKE_INSTALL_PREFIX=${TARGET} \
      -DCMAKE_BUILD_TYPE=RELEASE  \
      -DENABLE_STATIC=FALSE       \
      -DCMAKE_INSTALL_DOCDIR=${TARGET}/share/doc/libjpeg-turbo-2.0.1 \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib  

build_jpeg-turbo:
	cd ${build_dir_jpeg-turbo} && \
	$(CMAKE)--build . && \
  	$(CMAKE)--build . --target install

version_jpeg-turbo:
	cat ${VERSIONS_FILE} | ${JQ} --unbuffered --arg jpeg-turbo ${VERSION_JPGTURBO} '.libraries += {jpeg-turbo: $$$jpeg-turbo}' > ${VERSIONS_FILE}

make_jpeg-turbo: fetch_jpeg-turbo configure_jpeg-turbo build_jpeg-turbo version_jpeg-turbo
