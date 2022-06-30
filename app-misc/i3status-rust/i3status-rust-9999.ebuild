# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

DESCRIPTION="Status command for i3bar/swaybar written in async rust"
HOMEPAGE="https://github.com/greshake/i3status-rust"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greshake/i3status-rust"
else
	SRC_URI="$(cargo_crate_uris)
			https://github.com/greshake/i3status-rust/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 CC0-1.0 MIT MPL-2.0 Unlicense WTFPL-2"
SLOT="0"
IUSE="notmuch maildir pulseaudio"

DEPEND="
	sys-apps/lm-sensors
	pulseaudio? ( media-sound/pulseaudio )
	notmuch? ( net-mail/notmuch )
"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	local myfeatures=(
		$(usev notmuch)
		$(usev maildir)
		$(usev pulseaudio)
	)
	cargo_src_configure --no-default-features
}
