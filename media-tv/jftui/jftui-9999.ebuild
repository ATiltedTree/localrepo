# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Jellyfin Terminal User Interface"
HOMEPAGE="https://github.com/Aanok/jftui"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aanok/jftui"
else
	SRC_URI="https://github.com/Aanok/jftui/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Unlicense"
SLOT="0"

RDEPEND="
	net-misc/curl
	media-video/mpv[libmpv]
	dev-libs/yajl
"
DEPEND="${RDEPEND}"
