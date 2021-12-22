# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DOTNET_SLOT=5.0

DESCRIPTION="rhythm is just a *click* away!"
HOMEPAGE="https://github.com/ppy/osu"
if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ppy/osu.git"
else
	SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
IUSE=""
RESTRICT="test network-sandbox"

DEPEND="
	media-video/ffmpeg
	media-libs/libsdl2[video,gles2]
	dev-db/sqlite:3
	virtual/dotnet-sdk:${DOTNET_SLOT}
"
RDEPEND="${DEPEND}"

QA_PREBUILT="/usr/lib*/${PN}/libbass*.so"
QA_PRESTRIPPED="/usr/lib64/${PN}/osu!"

case ${ARCH} in
	amd64)
		RUNTIME="linux-x64"
		;;
	x86)
		RUNTIME="linux-x86"
		;;
	arm)
		RUNTIME="linux-arm"
		;;
	arm64)
		RUNTIME="linux-arm64"
		;;
	*)
		ewarn "unsupported architecture ${ARCH}"
		;;
esac

edotnet() {
	DOTNET_CLI_TELEMETRY_OPTOUT="true" \
	DOTNET_NOLOGO="true" \
	DOTNET_SKIP_FIRST_TIME_EXPERIENCE="true" \
	dotnet $@ || die "dotnet failed"
}

src_prepare() {
	default

	edotnet restore osu.Desktop \
		--runtime $RUNTIME
}

src_compile() {
	local version=""
	if ! [[ ${PV} = "9999" ]]; then
		version="/property:Version=${PV}"
	fi

	edotnet publish osu.Desktop \
		--configuration Release \
		--runtime $RUNTIME \
		--no-self-contained \
		--no-restore \
		--nologo \
		${version}
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"
	local output="osu.Desktop/bin/Release/net$DOTNET_SLOT/$RUNTIME/publish"

	rm $output/lib{SDL2,e_sqlite3}.so || die "could not remove SDL2 and sqlite vendored libs"

	insinto $dest
	doins -r $output/**

	dosym "../libSDL2.so" "$dest/libSDL2.so"
	dosym "../libsqlite3.so" "$dest/libe_sqlite3.so"

	fperms +x "$dest/osu!"
	dosym -r "$dest/osu!" "/usr/bin/osu"

	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}"/${PN}.xml

	newicon assets/lazer.png ${PN}.png
	make_desktop_entry "/usr/bin/osu %F" "osu!" "${PN}" "Game;ArcadeGame" "MimeType=application/x-osu-beatmap;application/x-osu-skin;x-scheme-handler/osu"
}
