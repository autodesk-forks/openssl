#!/bin/sh
# 


if [ .$1. = .. ]; then
	echo usage: ./adsk_install_mac.sh  \<install_path\> \<Min OS X Version supported: eg. ., 10.8, 10,9, .\>
	exit
fi
if [ .$2. = .. ]; then
	echo usage: ./adsk_install_mac.sh  \<install_path\> \<Min OS X Version supported: eg. ., 10.8, 10,9, .\>
	exit
fi

	rm -rf $1

	chmod -RLH -f u+w .
	make clean
	./Configure  shared no-idea no-mdc2 no-rc5 no-ssl2 no-ssl3 darwin64-x86_64-cc --prefix=$1 --openssldir=$1 
	sed -ie "s/^CFLAG= -/CFLAG=  -mmacosx-version-min=$2 -/" "Makefile"
	make depend
	make
	sudo make install


