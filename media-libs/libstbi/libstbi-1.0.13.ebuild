# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="stb_image as a library"
HOMEPAGE="https://github.com/Tom94/stbi-sharp"
SRC_URI="https://github.com/Tom94/stbi-sharp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

S="${WORKDIR}/stbi-sharp-${PV}/libstbi"

BDEPEND="dev-libs/stb"

PATCHES=(
	"${FILESDIR}"/stb.patch
)

src_compile() {
	${CXX} ${CFLAGS} -shared -fPIC src/stbi.cpp -o libstbi.so || die "Failed to compile libstbi"
}

src_install() {
	dolib.so libstbi.so
}
