# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A terminal iptv player written in bash"
HOMEPAGE="https://github.com/Roshan-R/termv"
SRC_URI="https://github.com/Roshan-R/termv/archive/refs/tags/v1.2.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-misc/curl
	media-video/mpv
	app-misc/jq
	app-shells/fzf
"

src_compile() {
	:;
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr/bin
}
