# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Toml grammar for Tree-sitter"
HOMEPAGE="https://github.com/ikatyang/tree-sitter-toml"
SRC_URI="https://github.com/ikatyang/tree-sitter-toml/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
