# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

COMMIT="8ea81bbf4c92f95b33cf3aeaa9bd348f07d4b6ab"

DESCRIPTION="Git rebase file grammar for Tree-sitter"
HOMEPAGE="https://github.com/the-mikedavis/tree-sitter-git-rebase"
SRC_URI="https://github.com/the-mikedavis/tree-sitter-git-rebase/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}/src"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
