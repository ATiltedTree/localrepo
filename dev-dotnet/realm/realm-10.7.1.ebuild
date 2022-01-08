# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Realm is a mobile database: a replacement for SQLite & ORMs"
HOMEPAGE="https://github.com/realm/realm-dotnet"

EGIT_REPO_URI="https://github.com/realm/realm-dotnet"
EGIT_COMMIT="${PV}"
inherit git-r3

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

S="${S}/wrappers"

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eapply 	"${FILESDIR}"/install.patch

	pushd realm-core
		eapply "${FILESDIR}"/core
	popd

	cmake_src_prepare
}

src_compile() {
	local mycmakeargs=(
		-DREALM_USE_SYSTEM_OPENSSL=ON
	)

	cmake_src_compile
}
