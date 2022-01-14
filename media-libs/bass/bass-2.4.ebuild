# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="BASS is an audio library for use in software on several platforms"
HOMEPAGE="https://www.un4seen.com/"
SRC_URI="
	https://www.un4seen.com/files/bass24-linux.zip
	fx? ( https://www.un4seen.com/files/z/0/bass_fx24-linux.zip )
	mix? ( https://www.un4seen.com/files/bassmix24-linux.zip )
"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fx +mix"

S="${WORKDIR}"

QA_PREBUILT="/usr/lib*/libbass*.so"

src_compile() {
	echo
}

install_lib() {
	if use x86; then
		dolib.so lib"$1".so
	elif use amd64; then
		dolib.so x64/lib"$1".so
	else
		die "unsupported arch"
	fi
}

src_install() {
	doheader bass.h
	install_lib bass

	if use fx; then
		doheader C/bass_fx.h
		install_lib bass_fx
	fi
	if use mix; then
		doheader bassmix.h
		install_lib bassmix
	fi
}
