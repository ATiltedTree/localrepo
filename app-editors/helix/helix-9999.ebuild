# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="A post-modern text editor."
HOMEPAGE="https://helix-editor.com/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/helix-editor/helix"
else
	SRC_URI="
		https://github.com/helix-editor/helix/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"

RDEPEND="dev-libs/tree-sitter-meta"

PATCHES=(
	"${FILESDIR}/gentoo.patch"
	"${FILESDIR}/no-lto.patch"
)

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1
	sed -i "s!%%DATADIR%%!${EPREFIX}/usr/share/helix!" helix-loader/src/lib.rs || die
	sed -i "s!%%LIBDIR%%!${EPREFIX}/usr/$(get_libdir)!" helix-loader/src/grammar.rs || die
}

src_install() {
	cargo_src_install --path helix-term

	insinto /usr/share/helix
	doins -r runtime
}
