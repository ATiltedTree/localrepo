# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

COMMIT="ca750e5bbc86e5716ccf4eb9e44493b14043ec4c"

DESCRIPTION="Diff grammar for Tree-sitter"
HOMEPAGE="https://github.com/the-mikedavis/tree-sitter-diff"
SRC_URI="https://github.com/the-mikedavis/tree-sitter-diff/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
