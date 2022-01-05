# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="EventEmitter using gevent"
HOMEPAGE="https://github.com/rossengeorgiev/gevent-eventemitter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ppc64 ~s390 ~sparc x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

distutils_enable_tests pytest

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	${DEPEND}
	>=dev-python/gevent-1.3.0[${PYTHON_USEDEP}]
"
