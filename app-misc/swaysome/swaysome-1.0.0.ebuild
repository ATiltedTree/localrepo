# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.2.1
	clap-3.0.0-beta.2
	clap_derive-3.0.0-beta.2
	hashbrown-0.9.1
	heck-0.3.2
	hermit-abi-0.1.18
	indexmap-1.6.2
	itoa-0.4.7
	lazy_static-1.4.0
	libc-0.2.93
	os_str_bytes-2.4.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.26
	quote-1.0.9
	ryu-1.0.5
	serde-1.0.123
	serde_derive-1.0.123
	serde_json-1.0.64
	strsim-0.10.0
	swayipc-3.0.0-alpha.3
	swayipc-types-1.0.0-alpha.3
	syn-1.0.69
	termcolor-1.1.2
	textwrap-0.12.1
	thiserror-1.0.24
	thiserror-impl-1.0.24
	unicode-segmentation-1.7.1
	unicode-width-0.1.8
	unicode-xid-0.2.1
	vec_map-0.8.2
	version_check-0.9.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Make sway workspaces work on a per-screen basis"
HOMEPAGE="https://github.com/ATiltedTree/swaysome"
SRC_URI="
	$(cargo_crate_uris)
	https://github.com/ATiltedTree/swaysome/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"
