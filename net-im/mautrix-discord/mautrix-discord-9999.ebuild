# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A Matrix-Discord puppeting bridge"
HOMEPAGE="https://go.mau.fi/mautrix-discord/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mautrix/discord"
else
	SRC_URI="https://github.com/mautrix/discord/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/discord-${PV}"
	KEYWORDS="~amd64"
fi

RESTRICT="network-sandbox"

LICENSE="AGPL-3"
SLOT="0"
IUSE="systemd"

DEPEND="dev-libs/olm"
BDEPEND="
	dev-lang/go
	dev-libs/olm
"
RDEPEND="
	${DEPEND}
	acct-group/mautrix-discord
	acct-user/mautrix-discord
	net-im/synapse
"

src_prepare() {
	default
	sed -i "s#./logs#/var/log/${PN}#" example-config.yaml || die
}

src_compile() {
	./build.sh -o "${S}"/mautrix-discord
}

src_install() {
	dobin mautrix-discord
	insinto /etc/${PN}
	newins example-config.yaml config.yaml
	fowners -R mautrix-discord:mautrix-discord /etc/${PN}/

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
}
