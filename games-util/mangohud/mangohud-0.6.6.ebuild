# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A overlay for monitoring FPS, temperatures, CPU/GPU load and more"
HOMEPAGE="https://github.com/flightlessmango/MangoHud"
SRC_URI="https://github.com/flightlessmango/MangoHud/releases/download/v${PV}/MangoHud-v${PV}-Source.tar.xz -> ${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
IUSE="X dbus wayland video_cards_amdgpu mangoapp"

KEYWORDS="~amd64"

S="${WORKDIR}/MangoHud-v${PV}"

DEPEND="
	dev-util/glslang
	media-libs/mesa
	x11-libs/libdrm[video_cards_amdgpu?]
	mangoapp? ( media-libs/glew )
	dbus? ( sys-apps/dbus )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/vulkan-headers
"

src_configure() {
	local emesonargs=(
		-Duse_system_vulkan=enabled
		-Dwith_xnvctrl=disabled
		-Dappend_libdir_mangohud=false
		-Dprepend_libdir_vk=false
		$(meson_use mangoapp)
		$(meson_feature X with_x11)
		$(meson_feature wayland with_wayland)
		$(meson_feature dbus with_dbus)
		$(meson_feature video_cards_amdgpu with_libdrm_amdgpu)
	)

	meson_src_configure
}
