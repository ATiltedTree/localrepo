# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} luajit )
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='threads(+)'

inherit lua-single optfeature pax-utils python-r1 meson xdg-utils

DESCRIPTION="Media player based on MPlayer and mplayer2"
HOMEPAGE="https://mpv.io/ https://github.com/mpv-player/mpv"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"
	DOCS=( RELEASE_NOTES )
else
	EGIT_REPO_URI="https://github.com/mpv-player/mpv.git"
	inherit git-r3
	DOCS=()
fi
DOCS+=( README.md DOCS/{client-api,interface}-changes.rst )

# See Copyright in sources and Gentoo bug 506946. Waf is BSD, libmpv is ISC.
LICENSE="LGPL-2.1+ GPL-2+ ISC"
SLOT="0"
IUSE="+alsa aqua archive bluray cdda +cli coreaudio cplugins nvenc doc drm dvb
	dvd +egl gamepad gbm +iconv jack javascript jpeg lcms libcaca libmpv +lua
	openal +opengl pipewire pulseaudio raspberry-pi rubberband sdl sndio
	selinux test tools +uchardet vaapi vdpau vulkan wayland +X +xv zlib zimg"

REQUIRED_USE="
	|| ( cli libmpv )
	aqua? ( opengl )
	nvenc? ( || ( opengl vulkan ) )
	gamepad? ( sdl )
	drm? ( gbm egl opengl )
	lua? ( ${LUA_REQUIRED_USE} )
	opengl? ( || ( aqua egl X raspberry-pi !cli ) )
	raspberry-pi? ( opengl )
	test? ( opengl )
	tools? ( cli )
	uchardet? ( iconv )
	vaapi? ( || ( drm X wayland ) )
	vdpau? ( X )
	vulkan? ( || ( X wayland ) )
	X? ( egl? ( opengl ) )
	xv? ( X )
	${PYTHON_REQUIRED_USE}
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=media-video/ffmpeg-4.0:0=[encode,threads,vaapi?,vdpau?]
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	archive? ( >=app-arch/libarchive-3.4.0:= )
	bluray? ( >=media-libs/libbluray-0.3.0:= )
	cdda? ( dev-libs/libcdio-paranoia
			dev-libs/libcdio:= )
	drm? ( x11-libs/libdrm )
	dvd? (
		>=media-libs/libdvdnav-4.2.0:=
		>=media-libs/libdvdread-4.1.0:=
	)
	egl? ( media-libs/mesa[egl(+),gbm(+)?,wayland(-)?] )
	gamepad? ( media-libs/libsdl2 )
	iconv? (
		virtual/libiconv
		uchardet? ( app-i18n/uchardet )
	)
	jack? ( virtual/jack )
	javascript? ( >=dev-lang/mujs-1.0.0 )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( >=media-libs/lcms-2.6:2 )
	>=media-libs/libass-0.12.1:=[fontconfig,harfbuzz(+)]
	virtual/ttf-fonts
	libcaca? ( >=media-libs/libcaca-0.99_beta18 )
	lua? ( ${LUA_DEPS} )
	openal? ( >=media-libs/openal-1.13 )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-sound/pulseaudio )
	raspberry-pi? ( >=media-libs/raspberrypi-userland-0_pre20160305-r1 )
	rubberband? ( >=media-libs/rubberband-1.8.0 )
	sdl? ( media-libs/libsdl2[sound,threads,video] )
	sndio? ( media-sound/sndio )
	vaapi? ( x11-libs/libva:=[drm?,X?,wayland?] )
	vdpau? ( x11-libs/libvdpau )
	vulkan? (
		>=media-libs/libplacebo-3.104.0:=[vulkan]
		media-libs/shaderc
	)
	wayland? (
		>=dev-libs/wayland-1.6.0
		>=dev-libs/wayland-protocols-1.14
		>=x11-libs/libxkbcommon-0.3.0
	)
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXrandr
		opengl? (
			x11-libs/libXdamage
			virtual/opengl
		)
		xv? ( x11-libs/libXv )
	)
	zlib? ( sys-libs/zlib )
	zimg? ( >=media-libs/zimg-2.9.2 )
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	nvenc? ( >=media-libs/nv-codec-headers-8.2.15.7 )
	dvb? ( virtual/linuxtv-dvb-headers )
"
RDEPEND="${COMMON_DEPEND}
	nvenc? ( x11-drivers/nvidia-drivers[X] )
	selinux? ( sec-policy/selinux-mplayer )
	tools? ( ${PYTHON_DEPS} )
"
BDEPEND="dev-python/docutils
	virtual/pkgconfig
	test? ( >=dev-util/cmocka-1.0.0 )
"

PATCHES=(
	"${FILESDIR}"/vaapi_cleanup.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	python_setup

	local emesonargs=(
		$(meson_use cli cplayer)
		$(meson_use libmpv)
		$(meson_use test tests)

		$(meson_feature doc html-build)
		-Dpdf-build=disabled
		-Dmanpage-build=enabled

		$(meson_feature cdda)
		$(meson_feature cplugins)
		$(meson_feature dvb dvbin)
		$(meson_feature dvd dvdnav)
		$(meson_feature iconv)
		$(meson_feature javascript)
		$(meson_feature lcms lcms2)
		$(meson_feature archive libarchive)
		-Dlibavdevice=enabled
		$(meson_feature bluray libbluray)
		$(usex lua "-Dlua=${ELUA}" "-Dlua=disabled")
		$(meson_feature rubberband)
		$(meson_feature sdl sdl2)
		$(meson_feature gamepad sdl2-gamepad)
		$(meson_feature uchardet)
		-Dvapoursynth=disabled # Only available in overlays.
		$(meson_feature zimg)
		$(meson_feature zlib)

		# Audio outputs:
		$(meson_feature alsa)
		$(meson_feature coreaudio)
		$(meson_feature jack)
		$(meson_feature openal)
		-Dopensles=disabled
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature sdl sdl2-audio)
		$(meson_feature sndio)

		# Video outputs:
		$(meson_feature libcaca caca)
		$(meson_feature aqua cocoa)
		$(meson_feature drm)
		$(meson_feature egl)
		$(meson_feature gbm)
		$(meson_feature opengl gl)
		$(meson_feature jpeg)
		$(meson_feature raspberry-pi rpi)
		$(meson_feature sdl sdl2-video)
		$(meson_feature vulkan shaderc)
		$(meson_feature vdpau)
		$(meson_feature vaapi)
		$(meson_feature vulkan)
		$(meson_feature wayland)
		$(meson_feature X x11)
		$(meson_feature xv)

		# HWaccels:
		# Automagic Video Toolbox HW acceleration. See Gentoo bug 577332.
		$(meson_feature nvenc cuda-hwaccel)
		$(meson_feature nvenc cuda-interop)
	)

	# Create reproducible non-live builds.
	[[ ${PV} != *9999* ]] && emesonargs+=( -Dbuild-date=false )

	meson_src_configure
}

src_install() {
	meson_src_install

	if use lua; then
		insinto /usr/share/${PN}
		doins -r TOOLS/lua
	fi

	if use cli && use lua_single_target_luajit; then
		pax-mark -m "${ED}"/usr/bin/${PN}
	fi

	if use tools; then
		dobin TOOLS/{mpv_identify.sh,umpv}
		newbin TOOLS/idet.sh mpv_idet.sh
		python_replicate_script "${ED}"/usr/bin/umpv
	fi
}

pkg_postinst() {
	local rv softvol_0_18_1=0 osc_0_21_0=0 txtsubs_0_24_0=0 opengl_0_25_0=0

	for rv in ${REPLACING_VERSIONS}; do
		ver_test ${rv} -lt 0.18.1 && softvol_0_18_1=1
		ver_test ${rv} -lt 0.21.0 && osc_0_21_0=1
		ver_test ${rv} -lt 0.24.0 && txtsubs_0_24_0=1
		ver_test ${rv} -lt 0.25.0 && ! use opengl && opengl_0_25_0=1
	done

	if [[ ${softvol_0_18_1} -eq 1 ]]; then
		elog "Since version 0.18.1 the software volume control is always enabled."
		elog "This means that volume controls don't change the system volume,"
		elog "e.g. per-application volume with PulseAudio."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Volume_in_0.18.1"
		elog
	fi

	if [[ ${osc_0_21_0} -eq 1 ]]; then
		elog "In version 0.21.0 the default OSC layout was changed."
		elog "If you want to restore the previous layout, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#OSC_in_0.21.0"
		elog
	fi

	if [[ ${txtsubs_0_24_0} -eq 1 ]]; then
		elog "Since version 0.24.0 subtitles with .txt extension aren't autoloaded."
		elog "If you want to restore the previous behaviour, please refer to"
		elog
		elog "https://wiki.gentoo.org/wiki/Mpv#Subtitles_with_.txt_extension_in_0.24.0"
		elog
	fi

	if [[ ${opengl_0_25_0} -eq 1 ]]; then
		elog "Since version 0.25.0 the 'opengl' USE flag is mapped to"
		elog "the 'opengl' video output and no longer explicitly requires"
		elog "X11 or Mac OS Aqua. Consider enabling the 'opengl' USE flag."
	fi

	optfeature "URL support" net-misc/yt-dlp

	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
