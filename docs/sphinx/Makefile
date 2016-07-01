help:
	@echo "make html|pdf|linkcheck|all|clean"

all: html pdf linkcheck

configure: build/CMakeCache.txt
build/CMakeCache.txt: CMakeLists.txt conf.py.in
	rm -rf build && \
	mkdir build && \
	cd build && \
	cmake -G "Unix Makefiles" -DDOC_VERSION_MAJOR=X -DDOC_VERSION_MINOR=Y -DDOC_VERSION_PATCH=Z ..

html: configure
	cd build && \
	make doc-html

pdf: configure
	cd build && \
	make doc-pdf

linkcheck: configure
	cd build && \
	make doc-linkcheck

clean:
	rm -rf build

.PHONY: all html pdf configure clean
