# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="BASS is an audio library for use in software on several platforms"
HOMEPAGE="https://www.un4seen.com/"
SRC_URI="
	https://www.un4seen.com/files/bass24-linux.zip -> ${P}.zip
	fx? ( https://www.un4seen.com/files/z/0/bass_fx24-linux.zip -> ${PN}-fx-${PV}.zip )
	mix? ( https://www.un4seen.com/files/bassmix24-linux.zip -> ${PN}-mix-${PV}.zip )
	arm64? (
		https://www.un4seen.com/files/bass24-linux-arm.zip -> ${PN}-arm-${PV}.zip
		fx? ( https://www.un4seen.com/files/z/0/bass_fx24-linux-arm.zip -> ${PN}-arm-fx-${PV}.zip )
	)
	arm? (
		https://www.un4seen.com/files/bass24-linux-arm.zip -> ${PN}-arm-${PV}.zip
		fx? ( https://www.un4seen.com/files/z/0/bass_fx24-linux-arm.zip -> ${PN}-arm-fx-${PV}.zip )
	)
"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+fx +mix"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

QA_PREBUILT="/usr/lib*/libbass*.so"

src_compile() {	:; }

install_lib() {
	if use x86; then
		:;
	elif use amd64; then
		cd "x64" || die
	elif use arm64; then
		cd "aarch64" || die
	elif use arm; then
		cd "hardfp" || die
	else
		die "unsupported arch"
	fi

	if use elibc_musl; then
		patchelf --replace-needed libc.so.6 libc.so lib$1.so
		patchelf --remove-needed libdl.so.2 lib$1.so
		patchelf --remove-needed libm.so.6 lib$1.so
		patchelf --remove-needed libpthread.so.0 lib$1.so
		patchelf --remove-needed librt.so.1 lib$1.so
	fi
	dolib.so lib$1.so
	cd "${S}" || die
}

src_install() {
	doheader bass.h
	install_lib bass

	if use fx; then
		doheader C/bass_fx.h
		install_lib bass_fx
		patchelf --replace-needed libstdc++.so.6 libc++.so.1 "${D}"/usr/$(get_libdir)/libbass_fx.so
	fi
	if use mix; then
		doheader bassmix.h
		install_lib bassmix
	fi
}
