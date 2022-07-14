# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Take control of Steam from your terminal"
HOMEPAGE="https://github.com/ValvePython/steamctl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	~dev-python/steam-1.3.0[${PYTHON_USEDEP},client]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/pyqrcode[${PYTHON_USEDEP}]
	>=dev-python/vpk-1.3.2[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
"
