# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="MPV Cast Client for Jellyfin"
HOMEPAGE="https://github.com/jellyfin/jellyfin-mpv-shim"
SRC_URI="https://github.com/jellyfin/jellyfin-mpv-shim/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}
	dev-python/python-mpv[${PYTHON_USEDEP}]
	dev-python/jellyfin-apiclient-python[${PYTHON_USEDEP}]
"
