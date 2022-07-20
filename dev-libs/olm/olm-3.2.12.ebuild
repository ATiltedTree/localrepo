# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake distutils-r1

DESCRIPTION="Implementation of the olm and megolm cryptographic ratchets"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"
SRC_URI="https://gitlab.matrix.org/matrix-org/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="doc test python"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/cffi[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
	)
"

src_prepare() {
	default
	
	cmake_src_prepare
	
	if use python; then
		cd python
		distutils-r1_src_prepare
		cd ..
	fi
}

src_configure() {
	local -a mycmakeargs=(
		-DOLM_TESTS="$(usex test)"
	)

	cmake_src_configure

	if use python; then
		cd python
		distutils-r1_src_configure
		cd ..
	fi
}

src_compile() {
	cmake_src_compile
	
	if use python; then
		cd python
		export LDFLAGS="${LDFLAGS} -L${WORKDIR}/${P}_build"
		distutils-r1_src_compile
		cd ..
	fi
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}

src_install() {
	use doc && DOCS=( README.md docs/{{,meg}olm,signing}.md )

	cmake_src_install

	if use python; then
		cd python
		distutils-r1_src_install
		cd ..
	fi
}
