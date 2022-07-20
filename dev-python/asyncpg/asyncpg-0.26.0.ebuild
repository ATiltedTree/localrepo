# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )  # doesn't build with pypy3
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A fast PostgreSQL Database Client Library for Python/asyncio"
HOMEPAGE="https://github.com/MagicStack/asyncpg"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

distutils_enable_sphinx docs dev-python/sphinxcontrib-asyncio dev-python/sphinx_rtd_theme

python_compile() {
	if use test; then
		esetup.py build_ext --force --inplace
		rm -r build || die
	fi

	distutils-r1_python_compile
}
