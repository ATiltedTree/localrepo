# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	anyhow-1.0.56
	arc-swap-1.5.0
	autocfg-1.1.0
	bitflags-1.3.2
	bstr-0.2.17
	bytecount-0.6.2
	bytes-1.1.0
	cassowary-0.3.0
	cc-1.0.73
	cfg-if-1.0.0
	chardetng-0.1.17
	chrono-0.4.19
	clipboard-win-4.4.1
	content_inspector-0.2.4
	crossbeam-utils-0.8.8
	crossterm-0.23.1
	crossterm_winapi-0.9.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	either-1.6.1
	encoding_rs-0.8.30
	encoding_rs_io-0.1.7
	error-code-2.3.1
	etcetera-0.3.2
	fern-0.6.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	fuzzy-matcher-0.3.7
	getrandom-0.2.5
	globset-0.4.8
	grep-matcher-0.1.5
	grep-regex-0.1.9
	grep-searcher-0.1.8
	hermit-abi-0.1.19
	idna-0.2.3
	ignore-0.4.18
	itoa-1.0.1
	jsonrpc-core-18.0.0
	lazy_static-1.4.0
	libc-0.2.121
	libloading-0.7.3
	lock_api-0.4.6
	log-0.4.16
	lsp-types-0.92.1
	matches-0.1.9
	memchr-2.4.1
	memmap2-0.3.1
	mio-0.7.14
	mio-0.8.1
	miow-0.3.7
	ntapi-0.3.7
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.1
	once_cell-1.10.0
	parking_lot-0.12.0
	parking_lot_core-0.9.1
	percent-encoding-2.1.0
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	proc-macro2-1.0.36
	pulldown-cmark-0.9.1
	quickcheck-1.0.3
	quote-1.0.15
	rand-0.8.5
	rand_core-0.6.3
	redox_syscall-0.2.11
	redox_users-0.4.0
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	retain_mut-0.1.7
	ropey-1.4.1
	ryu-1.0.9
	same-file-1.0.6
	scopeguard-1.1.0
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_repr-0.1.7
	signal-hook-0.3.13
	signal-hook-mio-0.2.1
	signal-hook-registry-1.4.0
	signal-hook-tokio-0.3.1
	similar-2.1.0
	slab-0.4.5
	slotmap-1.0.6
	smallvec-1.8.0
	smartstring-1.0.1
	socket2-0.4.4
	static_assertions-1.1.0
	str-buf-1.0.5
	str_indices-0.3.1
	syn-1.0.89
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-1.1.4
	threadpool-1.8.1
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	tokio-1.17.0
	tokio-macros-1.7.0
	tokio-stream-0.1.8
	toml-0.5.8
	tree-sitter-0.20.6
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-general-category-0.5.1
	unicode-normalization-0.1.19
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	version_check-0.9.4
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	which-4.2.5
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.32.0
	windows_aarch64_msvc-0.32.0
	windows_i686_gnu-0.32.0
	windows_i686_msvc-0.32.0
	windows_x86_64_gnu-0.32.0
	windows_x86_64_msvc-0.32.0
"

inherit cargo

DESCRIPTION="A post-modern text editor."
HOMEPAGE="https://helix-editor.com/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/helix-editor/helix"
	RESTRICT="network-sandbox"
else
	SRC_URI="
		https://github.com/helix-editor/helix/releases/download/${PV}/${P}-source.tar.xz -> ${P}.tar.xz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64"
	S="${WORKDIR}"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"

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
	sed -i "s!%%DATADIR%%!${EPREFIX}/usr/share/helix!" helix-loader/src/lib.rs || die
	sed -i "s!%%LIBDIR%%!${EPREFIX}/usr/$(get_libdir)!" helix-loader/src/grammar.rs || die
}

src_install() {
	cargo_src_install --path helix-term

	rm -r runtime/grammars/sources || die
	insinto /usr/share/helix
	doins -r runtime
}
