# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a click away!"
HOMEPAGE="https://github.com/ppy/osu"
SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND="
	media-video/ffmpeg
	media-libs/libsdl2[video]
	media-libs/libstbi
	media-libs/bass[fx,mix]
	=dev-dotnet/realm-10.8.0
	dev-db/sqlite:3
	virtual/dotnet-sdk:5.0
"
RDEPEND="${DEPEND}"

QA_PRESTRIPPED="/usr/lib*/${PN}/osu!"

dotnet_runtime() {
	local os=linux
	if use elibc_musl; then
		os="$os-musl"
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

src_unpack() {
	default
	ebegin "Downloading NuGet sources"
	edotnet restore "${S}"/osu.Desktop \
		--runtime $(dotnet_runtime) \
		>/dev/null
	eend $?
}

src_prepare() {
	default

	eapply --binary "${FILESDIR}"/disable-updater.patch
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
		--no-build \
		--nologo \
		--output "${D}"/$dest \
		"/property:Version=${PV}"

	# Remove debugging and documentations
	find "${ED}" -name '*.pdb' -delete || die
	find "${ED}" -name '*.xml' -delete || die

	# Remove bundled libs
	rm "${ED}/$dest"/*.json || die
	rm "${ED}/$dest"/lib{MonoPosixHelper,SDL2,stbi,realm-wrappers,bass,bassmix,bass_fx}.so || die

	# Replace bundled sqlite with system sqlite
	ln -sf ../libsqlite3.so "${ED}/$dest"/libe_sqlite3.so || die "failed to symlink sqlite"

	# Setup the runtimeconfig
	insinto "$dest"
	newins "${FILESDIR}"/runtimeconfig.json osu!.runtimeconfig.json

	fperms +x "$dest/osu!"
	dosym -r "$dest/osu!" "/usr/bin/osu"

	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}"/${PN}.xml

	newicon assets/lazer.png ${PN}.png
	domenu "${FILESDIR}"/osu.desktop
}
