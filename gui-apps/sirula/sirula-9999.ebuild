# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
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
