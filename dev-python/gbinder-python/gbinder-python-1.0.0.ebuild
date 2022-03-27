# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for libgbinder"
HOMEPAGE="https://github.com/erfanoabdi/gbinder-python"
SRC_URI="https://github.com/erfanoabdi/gbinder-python/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

distutils_enable_tests pytest

DEPEND="
	${PYTHON_DEPS}
	dev-libs/libgbinder
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/79d40e9e564772973f7f085ed5c48e3fc625e0f5.patch"
)

src_prepare() {
	default
	sed -i -e 's/USE_CYTHON = False/USE_CYTHON = True/' setup.py || die
}
