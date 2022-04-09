# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A Matrix-WhatsApp puppeting bridge"
HOMEPAGE="https://maunium.net/go/mautrix-whatsapp"
SRC_URI="https://github.com/mautrix/whatsapp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/whatsapp-${PV}"

RESTRICT="network-sandbox"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="dev-libs/olm"
BDEPEND="
	dev-lang/go
	dev-libs/olm
"
RDEPEND="
	${DEPEND}
	acct-group/mautrix-whatsapp
	acct-user/mautrix-whatsapp
"

src_compile() {
	./build.sh -o "${S}"/mautrix-whatsapp
}

src_install() {
	dobin mautrix-whatsapp
	insinto /etc/${PN}
	newins example-config.yaml ${PN}.yaml
	fperms -R 0640 /etc/${PN}/
	fowners -R root:mautrix-whatsapp /etc/${PN}/

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	fi
}
