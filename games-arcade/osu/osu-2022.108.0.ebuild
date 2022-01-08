# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DOTNET_SLOT=5.0

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a click away!"
HOMEPAGE="https://github.com/ppy/osu"
SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
IUSE=""
RESTRICT="test network-sandbox"

DEPEND="
	media-video/ffmpeg
	media-libs/libsdl2[video]
	media-libs/libstbi
	dev-dotnet/realm
	dev-db/sqlite:3
	virtual/dotnet-sdk:${DOTNET_SLOT}
"
RDEPEND="${DEPEND}"

QA_PREBUILT="/usr/lib*/${PN}/libbass*.so"
QA_PRESTRIPPED="/usr/lib*/${PN}/osu!"

dotnet_runtime() {
	local os=
	if use elibc_glibc; then
		os=linux
	elif use elibc_musl; then
		os=linux-musl
	fi

	local arch=
	case ${ARCH} in
		amd64)
			arch="x64"
			;;
		x86|arm|arm64)
			arch="${ARCH}"
			;;
		*)
			die "unsupported architecture ${ARCH}"
			;;
	esac

	echo "$os-$arch"
}

edotnet() {
	DOTNET_CLI_TELEMETRY_OPTOUT="true" \
	DOTNET_NOLOGO="true" \
	DOTNET_SKIP_FIRST_TIME_EXPERIENCE="true" \
	dotnet $@ || die "dotnet failed"
}

src_prepare() {
	default

	eapply --binary "${FILESDIR}"/disable-updater.patch

	edotnet restore osu.Desktop \
		--runtime $(dotnet_runtime)
}

src_compile() {
	edotnet build osu.Desktop \
		--configuration Release \
		--runtime $(dotnet_runtime) \
		--no-restore \
		--nologo \
		"/property:Version=${PV}"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"

	edotnet publish osu.Desktop \
		--configuration Release \
		--runtime $(dotnet_runtime) \
		--no-self-contained \
		--no-restore \
		--nologo \
		--output "${D}"/$dest \
		"/property:Version=${PV}"

	ln -sf ../libSDL2.so "${D}"/${dest}/libSDL2.so || die "failed to symlink SDL2"
	ln -sf ../libsqlite3.so "${D}"/${dest}/libe_sqlite3.so || die "failed to symlink sqlite"
	ln -sf ../libstbi.so "${D}"/${dest}/libstbi.so || die "failed to symlink stbi"
	ln -sf ../librealm-wrappers.so "${D}"/${dest}/librealm-wrappers.so || die "failed to symlink realm"

	insinto $dest
	fperms +x "$dest/osu!"
	dosym -r "$dest/osu!" "/usr/bin/osu"

	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}"/${PN}.xml

	newicon assets/lazer.png ${PN}.png
	domenu "${FILESDIR}"/osu.desktop
}
