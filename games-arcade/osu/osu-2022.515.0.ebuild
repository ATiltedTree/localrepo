# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NUGET_PKGS="
	automapper-11.0.1
	clowd.squirrel-2.9.40
	diffplex-1.7.1
	discordrichpresence-1.0.175
	ffmpeg.autogen-4.3.0.1
	fody-6.6.1
	hidsharpcore-1.2.1.1
	htmlagilitypack-1.11.42
	humanizer-2.14.1
	humanizer.core-2.8.26
	humanizer.core-2.14.1
	humanizer.core.af-2.14.1
	humanizer.core.ar-2.14.1
	humanizer.core.az-2.14.1
	humanizer.core.bg-2.14.1
	humanizer.core.bn-bd-2.14.1
	humanizer.core.cs-2.14.1
	humanizer.core.da-2.14.1
	humanizer.core.de-2.14.1
	humanizer.core.el-2.14.1
	humanizer.core.es-2.14.1
	humanizer.core.fa-2.14.1
	humanizer.core.fi-fi-2.14.1
	humanizer.core.fr-2.14.1
	humanizer.core.fr-be-2.14.1
	humanizer.core.he-2.14.1
	humanizer.core.hr-2.14.1
	humanizer.core.hu-2.14.1
	humanizer.core.hy-2.14.1
	humanizer.core.id-2.14.1
	humanizer.core.is-2.14.1
	humanizer.core.it-2.14.1
	humanizer.core.ja-2.14.1
	humanizer.core.ko-kr-2.14.1
	humanizer.core.ku-2.14.1
	humanizer.core.lv-2.14.1
	humanizer.core.ms-my-2.14.1
	humanizer.core.mt-2.14.1
	humanizer.core.nb-2.14.1
	humanizer.core.nb-no-2.14.1
	humanizer.core.nl-2.14.1
	humanizer.core.pl-2.14.1
	humanizer.core.pt-2.14.1
	humanizer.core.ro-2.14.1
	humanizer.core.ru-2.14.1
	humanizer.core.sk-2.14.1
	humanizer.core.sl-2.14.1
	humanizer.core.sr-2.14.1
	humanizer.core.sr-latn-2.14.1
	humanizer.core.sv-2.14.1
	humanizer.core.th-th-2.14.1
	humanizer.core.tr-2.14.1
	humanizer.core.uk-2.14.1
	humanizer.core.uz-cyrl-uz-2.14.1
	humanizer.core.uz-latn-uz-2.14.1
	humanizer.core.vi-2.14.1
	humanizer.core.zh-cn-2.14.1
	humanizer.core.zh-hans-2.14.1
	humanizer.core.zh-hant-2.14.1
	jetbrains.annotations-2021.3.0
	managed-midi-1.9.14
	managedbass-3.1.0
	managedbass.fx-3.1.0
	managedbass.mix-3.1.0
	markdig-0.23.0
	messagepack-2.3.85
	messagepack.annotations-2.3.85
	microsoft.aspnetcore.app.runtime.linux-musl-x64-6.0.5
	microsoft.aspnetcore.connections.abstractions-6.0.5
	microsoft.aspnetcore.http.connections.client-6.0.5
	microsoft.aspnetcore.http.connections.common-6.0.5
	microsoft.aspnetcore.signalr.client-6.0.5
	microsoft.aspnetcore.signalr.client.core-6.0.5
	microsoft.aspnetcore.signalr.common-6.0.5
	microsoft.aspnetcore.signalr.protocols.json-6.0.5
	microsoft.aspnetcore.signalr.protocols.messagepack-6.0.5
	microsoft.aspnetcore.signalr.protocols.newtonsoftjson-6.0.5
	microsoft.bcl.asyncinterfaces-1.0.0
	microsoft.bcl.asyncinterfaces-5.0.0
	microsoft.bcl.asyncinterfaces-6.0.0
	microsoft.codeanalysis.bannedapianalyzers-3.3.3
	microsoft.csharp-4.5.0
	microsoft.csharp-4.7.0
	microsoft.data.sqlite.core-5.0.14
	microsoft.diagnostics.netcore.client-0.2.61701
	microsoft.diagnostics.runtime-2.0.161401
	microsoft.dotnet.platformabstractions-3.1.6
	microsoft.entityframeworkcore-5.0.14
	microsoft.entityframeworkcore.abstractions-5.0.14
	microsoft.entityframeworkcore.analyzers-5.0.14
	microsoft.entityframeworkcore.design-5.0.14
	microsoft.entityframeworkcore.relational-5.0.14
	microsoft.entityframeworkcore.sqlite-5.0.14
	microsoft.entityframeworkcore.sqlite.core-5.0.14
	microsoft.extensions.caching.abstractions-5.0.0
	microsoft.extensions.caching.memory-5.0.0
	microsoft.extensions.configuration.abstractions-5.0.0
	microsoft.extensions.configuration.abstractions-6.0.0
	microsoft.extensions.dependencyinjection-5.0.2
	microsoft.extensions.dependencyinjection-6.0.0
	microsoft.extensions.dependencyinjection-6.0.0-rc.1.21451.13
	microsoft.extensions.dependencyinjection.abstractions-5.0.0
	microsoft.extensions.dependencyinjection.abstractions-6.0.0
	microsoft.extensions.dependencyinjection.abstractions-6.0.0-rc.1.21451.13
	microsoft.extensions.dependencymodel-5.0.0
	microsoft.extensions.features-6.0.5
	microsoft.extensions.logging-5.0.0
	microsoft.extensions.logging-6.0.0
	microsoft.extensions.logging.abstractions-5.0.0
	microsoft.extensions.logging.abstractions-6.0.0
	microsoft.extensions.logging.abstractions-6.0.1
	microsoft.extensions.objectpool-5.0.11
	microsoft.extensions.options-5.0.0
	microsoft.extensions.options-6.0.0
	microsoft.extensions.primitives-5.0.0
	microsoft.extensions.primitives-6.0.0
	microsoft.netcore.app.runtime.linux-musl-x64-6.0.5
	microsoft.netcore.platforms-1.0.1
	microsoft.netcore.platforms-1.1.0
	microsoft.netcore.platforms-2.0.0
	microsoft.netcore.platforms-5.0.0
	microsoft.netcore.targets-1.0.1
	microsoft.netcore.targets-1.1.0
	microsoft.win32.primitives-4.3.0
	microsoft.win32.registry-4.5.0
	microsoft.win32.registry-5.0.0
	mongodb.bson-2.11.3
	mono.posix.netstandard-1.0.0
	netstandard.library-1.6.1
	netstandard.library-2.0.0
	newtonsoft.json-12.0.2
	newtonsoft.json-13.0.1
	nuget.common-5.11.0
	nuget.configuration-5.11.0
	nuget.dependencyresolver.core-5.11.0
	nuget.frameworks-5.11.0
	nuget.librarymodel-5.11.0
	nuget.packaging-5.11.0
	nuget.projectmodel-5.11.0
	nuget.protocol-5.11.0
	nuget.versioning-5.11.0
	nunit-3.13.3
	opentabletdriver-0.6.0.2
	opentabletdriver.configurations-0.6.0.2
	opentabletdriver.native-0.6.0.2
	opentabletdriver.plugin-0.6.0.2
	ppy.localisationanalyser-2022.417.0
	ppy.osu.framework-2022.511.0
	ppy.osu.framework.nativelibs-2022.429.0
	ppy.osu.game.resources-2022.513.0
	ppy.osutk.ns20-1.0.187
	ppy.sdl2-cs-1.0.518-alpha
	realm-10.12.0
	realm.fody-10.12.0
	remotion.linq-2.2.0
	runtime.any.system.collections-4.3.0
	runtime.any.system.diagnostics.tools-4.3.0
	runtime.any.system.diagnostics.tracing-4.3.0
	runtime.any.system.globalization-4.3.0
	runtime.any.system.globalization.calendars-4.3.0
	runtime.any.system.io-4.3.0
	runtime.any.system.reflection-4.3.0
	runtime.any.system.reflection.extensions-4.3.0
	runtime.any.system.reflection.primitives-4.3.0
	runtime.any.system.resources.resourcemanager-4.3.0
	runtime.any.system.runtime-4.3.0
	runtime.any.system.runtime.handles-4.3.0
	runtime.any.system.runtime.interopservices-4.3.0
	runtime.any.system.text.encoding-4.3.0
	runtime.any.system.text.encoding.extensions-4.3.0
	runtime.any.system.threading.tasks-4.3.0
	runtime.any.system.threading.timer-4.3.0
	runtime.debian.8-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.fedora.23-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.fedora.24-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.native.system-4.3.0
	runtime.native.system.io.compression-4.3.0
	runtime.native.system.net.http-4.3.0
	runtime.native.system.security.cryptography.apple-4.3.0
	runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.opensuse.13.2-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.opensuse.42.1-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.osx.10.10-x64.runtime.native.system.security.cryptography.apple-4.3.0
	runtime.osx.10.10-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.rhel.7-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.ubuntu.14.04-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.ubuntu.16.04-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.ubuntu.16.10-x64.runtime.native.system.security.cryptography.openssl-4.3.0
	runtime.unix.microsoft.win32.primitives-4.3.0
	runtime.unix.system.console-4.3.0
	runtime.unix.system.diagnostics.debug-4.3.0
	runtime.unix.system.io.filesystem-4.3.0
	runtime.unix.system.net.primitives-4.3.0
	runtime.unix.system.net.sockets-4.3.0
	runtime.unix.system.private.uri-4.3.0
	runtime.unix.system.runtime.extensions-4.3.0
	sentry-3.17.1
	sharpcompress-0.31.0
	sharpfnt-2.0.0
	sixlabors.imagesharp-2.1.0
	sqlitepclraw.bundle_e_sqlite3-2.0.4
	sqlitepclraw.core-2.0.4
	sqlitepclraw.lib.e_sqlite3-2.0.4
	sqlitepclraw.provider.dynamic_cdecl-2.0.4
	sqlitepclraw.provider.e_sqlite3-2.0.4
	stbisharp-1.1.0
	system.appcontext-4.3.0
	system.buffers-4.3.0
	system.buffers-4.4.0
	system.buffers-4.5.1
	system.collections-4.0.11
	system.collections-4.3.0
	system.collections.concurrent-4.3.0
	system.collections.immutable-1.5.0
	system.collections.immutable-1.7.1
	system.collections.immutable-5.0.0
	system.componentmodel.annotations-5.0.0
	system.console-4.3.0
	system.diagnostics.debug-4.0.11
	system.diagnostics.debug-4.3.0
	system.diagnostics.diagnosticsource-4.3.0
	system.diagnostics.diagnosticsource-5.0.1
	system.diagnostics.diagnosticsource-6.0.0
	system.diagnostics.tools-4.3.0
	system.diagnostics.tracing-4.3.0
	system.dynamic.runtime-4.3.0
	system.formats.asn1-5.0.0
	system.globalization-4.0.11
	system.globalization-4.3.0
	system.globalization.calendars-4.3.0
	system.globalization.extensions-4.3.0
	system.io-4.1.0
	system.io-4.3.0
	system.io.compression-4.3.0
	system.io.compression.zipfile-4.3.0
	system.io.filesystem-4.3.0
	system.io.filesystem.primitives-4.3.0
	system.io.packaging-6.0.0
	system.io.pipelines-6.0.3
	system.linq-4.1.0
	system.linq-4.3.0
	system.linq.expressions-4.1.0
	system.linq.expressions-4.3.0
	system.linq.queryable-4.0.1
	system.memory-4.5.3
	system.memory-4.5.4
	system.net.http-4.3.0
	system.net.nameresolution-4.3.0
	system.net.primitives-4.3.0
	system.net.sockets-4.3.0
	system.numerics.vectors-4.4.0
	system.numerics.vectors-4.5.0
	system.objectmodel-4.0.12
	system.objectmodel-4.3.0
	system.private.uri-4.3.0
	system.reflection-4.1.0
	system.reflection-4.3.0
	system.reflection.emit-4.0.1
	system.reflection.emit-4.3.0
	system.reflection.emit-4.6.0
	system.reflection.emit.ilgeneration-4.0.1
	system.reflection.emit.ilgeneration-4.3.0
	system.reflection.emit.lightweight-4.0.1
	system.reflection.emit.lightweight-4.3.0
	system.reflection.emit.lightweight-4.6.0
	system.reflection.extensions-4.0.1
	system.reflection.extensions-4.3.0
	system.reflection.metadata-1.8.1
	system.reflection.metadata-5.0.0
	system.reflection.primitives-4.0.1
	system.reflection.primitives-4.3.0
	system.reflection.typeextensions-4.1.0
	system.reflection.typeextensions-4.3.0
	system.resources.resourcemanager-4.0.1
	system.resources.resourcemanager-4.3.0
	system.runtime-4.1.0
	system.runtime-4.3.0
	system.runtime.compilerservices.unsafe-4.5.2
	system.runtime.compilerservices.unsafe-4.5.3
	system.runtime.compilerservices.unsafe-4.7.1
	system.runtime.compilerservices.unsafe-5.0.0
	system.runtime.compilerservices.unsafe-6.0.0
	system.runtime.compilerservices.unsafe-6.0.0-rc.1.21451.13
	system.runtime.extensions-4.1.0
	system.runtime.extensions-4.3.0
	system.runtime.handles-4.3.0
	system.runtime.interopservices-4.3.0
	system.runtime.interopservices.runtimeinformation-4.3.0
	system.runtime.numerics-4.3.0
	system.security.accesscontrol-4.5.0
	system.security.accesscontrol-5.0.0
	system.security.claims-4.3.0
	system.security.cryptography.algorithms-4.3.0
	system.security.cryptography.cng-4.3.0
	system.security.cryptography.cng-5.0.0
	system.security.cryptography.csp-4.3.0
	system.security.cryptography.encoding-4.3.0
	system.security.cryptography.openssl-4.3.0
	system.security.cryptography.pkcs-5.0.0
	system.security.cryptography.primitives-4.3.0
	system.security.cryptography.protecteddata-4.4.0
	system.security.cryptography.x509certificates-4.3.0
	system.security.principal-4.3.0
	system.security.principal.windows-4.3.0
	system.security.principal.windows-4.5.0
	system.security.principal.windows-5.0.0
	system.text.encoding-4.0.11
	system.text.encoding-4.3.0
	system.text.encoding.codepages-5.0.0
	system.text.encoding.extensions-4.3.0
	system.text.encodings.web-5.0.0
	system.text.encodings.web-5.0.1
	system.text.encodings.web-6.0.0
	system.text.json-5.0.0
	system.text.json-5.0.2
	system.text.json-6.0.4
	system.text.regularexpressions-4.3.0
	system.threading-4.0.11
	system.threading-4.3.0
	system.threading.channels-6.0.0
	system.threading.tasks-4.0.11
	system.threading.tasks-4.3.0
	system.threading.tasks.extensions-4.3.0
	system.threading.tasks.extensions-4.5.3
	system.threading.tasks.extensions-4.5.4
	system.threading.threadpool-4.3.0
	system.threading.timer-4.3.0
	system.xml.readerwriter-4.3.0
	system.xml.xdocument-4.3.0
	taglibsharp-2.2.0
"

inherit nuget desktop xdg wrapper

DESCRIPTION="A free-to-win rhythm game. Rhythm is just a click away!"
HOMEPAGE="https://github.com/ppy/osu"
SRC_URI="
	https://github.com/ppy/osu/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(nuget_pkg_uris)
"
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

src_prepare() {
	default

	addpredict $(dirname $(dotnet --list-sdks | grep -o "\[.*\]" | sed 's/\[//' | sed 's/\]//'))
}

src_configure() {
	edotnet restore osu.Desktop \
		--use-current-runtime \
		--source "$(nuget_registry)"
}

src_compile() {
	edotnet build osu.Desktop \
		--configuration Release \
		--use-current-runtime \
		--no-self-contained \
		--no-restore \
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
