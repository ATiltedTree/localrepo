# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	anyhow-1.0.44
	arrayref-0.3.6
	arrayvec-0.5.2
	atk-0.14.0
	atk-sys-0.14.0
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.3.2
	bitvec-0.19.5
	blake2b_simd-0.5.11
	cairo-rs-0.14.7
	cairo-sys-rs-0.14.0
	cfg-expr-0.8.1
	cfg-if-1.0.0
	constant_time_eq-0.1.5
	crossbeam-utils-0.8.5
	dirs-1.0.5
	either-1.6.1
	field-offset-0.3.4
	freedesktop_entry_parser-1.2.0
	funty-1.1.0
	futures-0.3.17
	futures-channel-0.3.17
	futures-core-0.3.17
	futures-executor-0.3.17
	futures-io-0.3.17
	futures-macro-0.3.17
	futures-sink-0.3.17
	futures-task-0.3.17
	futures-util-0.3.17
	fuzzy-matcher-0.3.7
	gdk-0.14.3
	gdk-pixbuf-0.14.0
	gdk-pixbuf-sys-0.14.0
	gdk-sys-0.14.0
	getrandom-0.1.16
	gio-0.14.8
	gio-sys-0.14.0
	glib-0.14.8
	glib-macros-0.14.1
	glib-sys-0.14.0
	gobject-sys-0.14.0
	gtk-0.14.3
	gtk-layer-shell-0.2.2
	gtk-layer-shell-sys-0.2.3
	gtk-sys-0.14.0
	gtk3-macros-0.14.0
	heck-0.3.3
	itertools-0.8.2
	itertools-0.10.1
	lazy_static-1.4.0
	lexical-core-0.7.6
	libc-0.2.103
	locale-types-0.4.0
	memchr-2.4.1
	memoffset-0.6.4
	nom-6.1.2
	once_cell-1.8.0
	osstrtools-0.2.2
	pango-0.14.8
	pango-sys-0.14.0
	pest-2.1.3
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	pkg-config-0.3.20
	proc-macro-crate-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.7
	proc-macro2-1.0.29
	quote-1.0.10
	radium-0.5.3
	redox_syscall-0.1.57
	redox_users-0.3.5
	regex-1.5.4
	regex-syntax-0.6.25
	rust-argon2-0.8.3
	rustc_version-0.3.3
	ryu-1.0.5
	semver-0.11.0
	semver-parser-0.10.2
	serde-1.0.130
	serde_derive-1.0.130
	slab-0.4.4
	smallvec-1.7.0
	static_assertions-1.1.0
	strum-0.21.0
	strum_macros-0.21.1
	syn-1.0.80
	system-deps-3.2.0
	tap-1.0.1
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-1.1.3
	toml-0.5.8
	ucd-trie-0.1.3
	unicode-segmentation-1.8.0
	unicode-xid-0.2.2
	version-compare-0.0.11
	version_check-0.9.3
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	wyz-0.2.0
	xdg-2.3.0
"

inherit cargo

DESCRIPTION="Simple app launcher for wayland written in rust"
HOMEPAGE="https://github.com/DorianRudolph/sirula"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/DorianRudolph/sirula"
else
	SRC_URI="$(cargo_crate_uris)
			https://github.com/DorianRudolph/sirula/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 CC0-1.0 MIT MPL-2.0 Unlicense WTFPL-2"
SLOT="0"

DEPEND="gui-libs/gtk-layer-shell"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}
