# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Japanese input method for Sway using libanthy"
HOMEPAGE="https://github.com/tadeokondrak/anthywl"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tadeokondrak/anthywl"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="ISC"
SLOT="0"
IUSE="ipc +man"

DEPEND="
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-libs/libscfg
	x11-libs/libxkbcommon
	app-i18n/anthy
	x11-libs/cairo
	x11-libs/pango
	ipc? ( dev-libs/libvarlink )
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( app-text/scdoc )"

PATCHES=(
	"${FILESDIR}/ipc.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_feature ipc)
		$(meson_feature man man-pages)
	)

	meson_src_configure
}
