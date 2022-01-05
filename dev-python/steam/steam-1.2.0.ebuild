# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Module for interacting with various Steam features"
HOMEPAGE="https://github.com/ValvePython/steam"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="client"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

distutils_enable_tests pytest

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/vdf-3.3[${PYTHON_USEDEP}]
	>=dev-python/cachetools-3.0.0[${PYTHON_USEDEP}]
	client? (
		>=dev-python/gevent-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/gevent-eventemitter-2.1[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
	)
"
