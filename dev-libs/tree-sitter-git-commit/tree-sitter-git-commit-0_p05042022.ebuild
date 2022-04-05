# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

COMMIT="318dd72abfaa7b8044c1d1fbeabcd06deaaf038f"

DESCRIPTION="Git commit message grammar for Tree-sitter"
HOMEPAGE="https://github.com/the-mikedavis/tree-sitter-git-commit"
SRC_URI="https://github.com/the-mikedavis/tree-sitter-git-commit/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
