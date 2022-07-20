# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 systemd

DESCRIPTION="A Matrix-Signal puppeting bridge"
HOMEPAGE="https://docs.mau.fi/bridges/python/signal/index.html"
SRC_URI="https://github.com/mautrix/signal/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/signal-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd qrcode"

# stickers? ( dev-python/signalstickers-client[${PYTHON_USEDEP}] )
DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/commonmark[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/mautrix[${PYTHON_USEDEP},qrcode?]
	dev-python/asyncpg[${PYTHON_USEDEP}]
	dev-python/phonenumbers[${PYTHON_USEDEP}]
	acct-group/mautrix-signal
	acct-user/mautrix-signal
	net-im/synapse
	net-im/signald
"

src_prepare() {
	default
	sed -i "s#./logs#/var/log/${PN}#" mautrix_signal/example-config.yaml || die
}

src_install() {
	distutils-r1_src_install
	rm "${D}"/usr/example-config.yaml
	insinto /etc/${PN}
	newins mautrix_signal/example-config.yaml config.yaml
	fowners -R mautrix-signal:mautrix-signal /etc/${PN}/

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
}
