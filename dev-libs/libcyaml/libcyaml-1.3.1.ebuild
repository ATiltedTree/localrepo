# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="C library for reading and writing YAML."
HOMEPAGE="https://github.com/tlsa/libcyaml"
SRC_URI="https://github.com/tlsa/libcyaml/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug static-libs"

src_compile() {
	if use debug; then
		emake VARIANT=debug
	else
		emake VARIANT=release
	fi
}

src_install() {
	if use debug; then
		emake VARIANT=debug DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="/usr" install
	else
		emake VARIANT=release DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="/usr" install
	fi

	if ! use static-libs; then
		rm "${D}"/usr/lib/*.a
	fi
}
