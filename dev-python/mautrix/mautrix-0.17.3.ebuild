# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )  # doesn't build with pypy3
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Python 3 asyncio Matrix framework"
HOMEPAGE="https://github.com/mautrix/python"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="metrics e2be qrcode"

# sqlite? ( dev-python/aiosqlite[${PYTHON_USEDEP}] )
DEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
	metrics? ( dev-python/prometheus_client[${PYTHON_USEDEP}] )
	e2be? (
		dev-libs/olm[${PYTHON_USEDEP},python]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/unpaddedbase64[${PYTHON_USEDEP}]
	)
	qrcode? (
		dev-python/qrcode[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	)
"
