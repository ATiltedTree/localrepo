# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake xdg

DESCRIPTION='Second installment of the Twitch chat client series "Chatterino"'
HOMEPAGE="https://chatterino.com"

EGIT_REPO_URI="https://github.com/Chatterino/chatterino2"

if [[ "${PV}" != "9999" ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

IUSE="streamlink"


DEPEND="
	dev-qt/linguist-tools
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtmultimedia
	dev-qt/qtnetwork
	dev-qt/qtsvg
	dev-qt/qtwidgets
	dev-libs/boost
	dev-libs/openssl
	streamlink? ( net-misc/streamlink )
	"
