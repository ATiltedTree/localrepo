# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a click away!"
HOMEPAGE="https://github.com/ppy/osu"
SRC_URI="https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64"

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND="
	media-video/ffmpeg
	media-libs/libsdl2[video]
	media-libs/libstbi
	media-libs/bass[fx,mix]
	~dev-dotnet/realm-10.8.0
	virtual/dotnet-sdk:6.0
"
RDEPEND="${DEPEND}"

QA_PRESTRIPPED="/usr/lib*/${PN}/osu!"

edotnet() {
	DOTNET_CLI_TELEMETRY_OPTOUT="true" \
	DOTNET_NOLOGO="true" \
	DOTNET_SKIP_FIRST_TIME_EXPERIENCE="true" \
	dotnet $@ || die "dotnet failed"
}

src_unpack() {
	default
	cd "${S}"
	eapply --binary "${FILESDIR}"/disable-updater.patch
	eapply --binary "${FILESDIR}"/net6.patch
	ebegin "Downloading NuGet sources"
	edotnet restore "${S}"/osu.Desktop \
		--use-current-runtime \
		--no-cache \
		>/dev/null
	eend $?
}

src_compile() {
	edotnet build osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		"/property:Version=${PV}"
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"

	edotnet publish osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--no-build \
		--output "${D}"/$dest \
		"/property:Version=${PV}"

	# Remove debugging and documentations
	find "${ED}" -name '*.pdb' -delete || die
	find "${ED}" -name '*.xml' -delete || die

	# Remove bundled libs
	find "${ED}" -name '*.so' -delete || die
	rm "${ED}/$dest"/osu!.deps.json || die

	fperms +x "$dest/osu!"
	dosym -r "$dest/osu!" "/usr/bin/osu"

	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}"/${PN}.xml

	newicon assets/lazer.png ${PN}.png
	domenu "${FILESDIR}"/osu.desktop
}
