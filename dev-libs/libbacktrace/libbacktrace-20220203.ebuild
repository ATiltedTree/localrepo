# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="https://foo.example.org/"

COMMIT="332522e19991b9d8afb4c808fb30f6a7c1bbe22c"
SRC_URI="https://github.com/ianlancetaylor/libbacktrace/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
