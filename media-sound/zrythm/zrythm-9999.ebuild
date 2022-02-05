# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg gnome2-utils

DESCRIPTION="Zrythm is a digital audio workstation designed to be featureful and easy to use."

HOMEPAGE="https://www.zrythm.org/"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://git.sr.ht/~alextee/zrythm"
	inherit git-r3
else
	SRC_URI="https://git.sr.ht/~alextee/zrythm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=""
fi

LICENSE="AGPL-3"
SLOT="0"

IUSE="portaudio rtaudio sdl jack graphviz guile doc chromaprint pulseaudio alsa soundio X"

# Not packaged
#rtmidi? ( media-libs/rtmidi[alsa?,jack?] )
RDEPEND="
	gui-libs/gtk:4[X?]
	dev-libs/libcyaml
	media-sound/libaudec
	gui-libs/libadwaita:1
	media-libs/lv2
	dev-libs/serd:0
	dev-libs/sord:0
	media-libs/sratom:0
	media-libs/lilv:0
	sci-libs/fftw:3.0[threads]
	x11-libs/gtksourceview:5
	dev-libs/reproc
	dev-libs/libbacktrace
	dev-libs/xxhash
	media-libs/rubberband
	media-libs/libepoxy
	net-misc/curl
	media-libs/vamp-plugin-sdk
	portaudio? ( media-libs/portaudio )
	rtaudio? ( media-libs/rtaudio[alsa?,jack?,pulseaudio?] )
	sdl? ( media-libs/libsdl2[sound] )
	jack? ( virtual/jack )
	graphviz? ( media-gfx/graphviz )
	guile? ( dev-scheme/guile )
	chromaprint? ( media-libs/chromaprint )
	pulseaudio? ( media-sound/pulseaudio )
	alsa? ( media-libs/alsa-lib )
	soundio? ( media-libs/libsoundio[alsa?,jack?,pulseaudio?] )
	X? ( x11-libs/libX11 )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/sassc"

PATCHES=(
	"${FILESDIR}"/execinfo.patch
	"${FILESDIR}"/meson.patch
	"${FILESDIR}"/carlaless.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use doc user_manual)
		-Ddseg_font=false
		-Dextra_optimizations=false
		-Dcheck_updates=false
		-Dopus=true

		$(meson_feature portaudio)
		#$(meson_feature rtmidi)
		-Drtmidi=disabled
		$(meson_feature rtaudio)
		$(meson_feature sdl)
		#$(meson_feature carla) not in repos
		-Dcarla=disabled
		$(meson_feature jack)
		$(meson_feature graphviz)
		$(meson_feature guile)
		$(meson_feature chromaprint)
		$(meson_feature pulseaudio)
		$(meson_feature alsa)
		$(meson_feature soundio)
		$(meson_feature X x11)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	gnome2_schemas_update
}
