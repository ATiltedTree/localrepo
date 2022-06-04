# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Realm is a mobile database: a replacement for SQLite & ORMs"
HOMEPAGE="https://github.com/realm/realm-dotnet"

CORE_SHA="f8f6b3730e32dcc5b6564ebbfa5626a640cdb52a"
CORE_P="realm-core-${CORE_SHA}"
NET_P="realm-dotnet-${PV}"

SRC_URI="
	https://github.com/realm/realm-core/archive/${CORE_SHA}.tar.gz -> ${CORE_P}.tar.gz
	https://github.com/realm/realm-dotnet/archive/refs/tags/${PV}.tar.gz -> ${NET_P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

S="${WORKDIR}/${NET_P}/wrappers"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
DEPEND="
	dev-libs/openssl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	rmdir realm-core || die
	ln -s "${WORKDIR}"/${CORE_P} realm-core || die

	eapply "${FILESDIR}"/install.patch

	cd "${S}"/realm-core
		eapply "${FILESDIR}"/core
	cd "${S}"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DREALM_USE_SYSTEM_OPENSSL=ON
	)

	cmake_src_configure
}
