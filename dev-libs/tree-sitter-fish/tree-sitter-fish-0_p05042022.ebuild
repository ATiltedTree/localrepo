# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

COMMIT="d482d70ea8e191c05b2c1b613ed6fdff30a14da0"

DESCRIPTION="Fish shell grammar for Tree-sitter"
HOMEPAGE="https://github.com/ram02z/tree-sitter-fish"
SRC_URI="https://github.com/ram02z/tree-sitter-fish/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
