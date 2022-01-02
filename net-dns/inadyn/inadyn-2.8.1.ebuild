# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dynamic DNS client with SSL/TLS support"
HOMEPAGE="https://troglobit.com/projects/inadyn/"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 arm64"
IUSE="+ssl"

DEPEND="
	dev-libs/confuse
	ssl? ( dev-libs/openssl )
"

src_prepare() {
	default

	econf $(use_enable ssl openssl)
}
