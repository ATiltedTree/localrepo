# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NUGET_PKGS=""

inherit nuget desktop xdg wrapper

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a click away!"
HOMEPAGE="https://github.com/ppy/osu"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ppy/osu"
else
	SRC_URI="
		https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz
		$(nuget_pkg_uris)
	"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT CC-BY-NC-4.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND="
	media-video/ffmpeg
	media-libs/libsdl2[video]
	media-libs/libstbi
	media-libs/bass[fx,mix]
	~dev-dotnet/realm-10.10.0
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
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
		cd "${S}"
		edotnet restore osu.Desktop --use-current-runtime --packages "$(nuget_registry)"
	else
		nuget_src_unpack
	fi
}

src_prepare() {
	default

	addpredict $(dirname $(dotnet --list-sdks | grep -o "\[.*\]" | sed 's/\[//' | sed 's/\]//'))
}

src_configure() {
	edotnet restore osu.Desktop \
		--use-current-runtime \
		--source "$(nuget_registry)"
}

version() {
	if [[ "${PV}" != "9999" ]]; then
		echo "/property:Version=${PV}"
	fi
}

src_compile() {
	edotnet build osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--no-restore \
		$(version)
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}"

	edotnet publish osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--no-build \
		--output "${D}"/$dest \
		$(version)

	# Remove debugging and documentations
	find "${ED}" -name '*.pdb' -delete || die
	find "${ED}" -name '*.xml' -delete || die

	# Remove bundled libs
	find "${ED}" -name '*.so' -delete || die
	rm "${ED}/$dest"/osu!.deps.json || die

	fperms +x "$dest/osu!"

	# Disable update notifications
	make_wrapper osu "env OSU_EXTERNAL_UPDATE_PROVIDER=1 $dest/osu!"

	# Create a desktop entry
	make_desktop_entry \
		"/usr/bin/osu %F" "osu!" "osu" "Game;ArcadeGame;" \
		"MimeType=application/x-osu-beatmap;application/x-osu-skin;x-scheme-handler/osu"

	# Install mime types
	insinto "/usr/share/mime/packages"
	doins "${FILESDIR}"/${PN}.xml

	# Install icon
	newicon assets/lazer.png ${PN}.png
}
