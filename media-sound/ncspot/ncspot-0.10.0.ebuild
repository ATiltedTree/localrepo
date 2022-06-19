# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aes-0.6.0
	aes-ctr-0.6.0
	aes-soft-0.6.4
	aesni-0.10.0
	ahash-0.7.6
	aho-corasick-0.7.18
	alsa-0.6.0
	alsa-sys-0.3.1
	async-trait-0.1.56
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.65
	base-x-0.2.10
	base64-0.13.0
	bindgen-0.59.2
	bitflags-1.3.2
	block-0.1.6
	block-buffer-0.9.0
	block-buffer-0.10.2
	bumpalo-3.10.0
	bytecount-0.6.3
	byteorder-1.4.3
	bytes-1.1.0
	cc-1.0.73
	cesu8-1.1.0
	cexpr-0.6.0
	cfg-if-1.0.0
	chrono-0.4.19
	chunked_transfer-1.4.0
	cipher-0.2.5
	clang-sys-1.3.3
	clap-3.1.18
	clap_lex-0.2.0
	clipboard-0.5.0
	clipboard-win-2.2.0
	combine-4.6.4
	const_fn-0.4.9
	convert_case-0.4.0
	cookie-0.15.1
	cookie_store-0.15.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.10
	cpal-0.13.5
	cpufeatures-0.2.2
	crossbeam-channel-0.5.4
	crossbeam-utils-0.8.8
	crypto-common-0.1.3
	crypto-mac-0.11.1
	ctr-0.6.0
	cursive-0.18.0
	cursive_core-0.3.2
	darling-0.13.4
	darling_core-0.13.4
	darling_macro-0.13.4
	dbus-0.9.5
	dbus-tree-0.9.2
	derive-new-0.5.9
	derive_more-0.99.17
	digest-0.9.0
	digest-0.10.3
	dirs-next-1.0.2
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	discard-1.0.4
	downcast-rs-1.2.0
	encoding_rs-0.8.31
	enum-map-2.3.0
	enum-map-derive-0.9.0
	enumset-1.0.11
	enumset_derive-0.6.0
	fastrand-1.7.0
	fern-0.6.1
	fixedbitset-0.4.1
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getrandom-0.2.6
	gimli-0.26.1
	glob-0.3.0
	h2-0.3.13
	half-1.8.2
	hashbrown-0.11.2
	headers-0.3.7
	headers-core-0.2.0
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.1.19
	hmac-0.11.0
	http-0.2.8
	http-body-0.4.5
	httparse-1.7.1
	httpdate-1.0.2
	hyper-0.14.19
	hyper-proxy-0.9.1
	hyper-tls-0.5.0
	ident_case-1.0.1
	idna-0.2.3
	indexmap-1.8.2
	instant-0.1.12
	ioctl-rs-0.2.0
	ipnet-2.5.0
	itoa-1.0.2
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.24
	js-sys-0.3.57
	lazy_static-1.4.0
	lazycell-1.3.0
	lewton-0.10.2
	libc-0.2.126
	libdbus-sys-0.2.2
	libloading-0.7.3
	libm-0.2.2
	libpulse-binding-2.26.0
	libpulse-simple-binding-2.25.0
	libpulse-simple-sys-1.19.2
	libpulse-sys-1.19.3
	librespot-audio-0.4.1
	librespot-core-0.4.1
	librespot-metadata-0.4.1
	librespot-playback-0.4.1
	librespot-protocol-0.4.1
	lock_api-0.4.7
	log-0.4.17
	mac-notification-sys-0.5.0
	mach-0.3.2
	malloc_buf-0.0.6
	maplit-1.0.2
	matches-0.1.9
	maybe-async-0.2.6
	memchr-2.5.0
	memoffset-0.6.5
	mime-0.3.16
	minimal-lexical-0.2.1
	miniz_oxide-0.5.3
	mio-0.8.3
	native-tls-0.2.10
	ncurses-5.101.0
	ndk-0.6.0
	ndk-context-0.1.1
	ndk-glue-0.6.2
	ndk-macro-0.3.0
	ndk-sys-0.3.0
	nix-0.22.3
	nix-0.23.1
	nom-7.1.1
	notify-rust-4.5.8
	num-0.2.1
	num-0.4.0
	num-bigint-0.2.6
	num-bigint-0.4.3
	num-complex-0.2.4
	num-complex-0.4.1
	num-derive-0.3.3
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.2.4
	num-rational-0.4.0
	num-traits-0.2.15
	num_cpus-1.13.1
	num_enum-0.5.7
	num_enum_derive-0.5.7
	num_threads-0.1.6
	numtoa-0.1.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	object-0.28.4
	oboe-0.4.6
	oboe-sys-0.4.5
	ogg-0.8.0
	once_cell-1.12.0
	opaque-debug-0.3.0
	openssl-0.10.40
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-sys-0.9.74
	os_pipe-1.0.1
	os_str_bytes-6.1.0
	owning_ref-0.4.1
	pancurses-0.17.0
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.5
	parking_lot_core-0.9.3
	parse_duration-2.1.1
	pbkdf2-0.8.0
	pdcurses-sys-0.7.1
	peeking_take_while-0.1.2
	percent-encoding-2.1.0
	petgraph-0.6.2
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	platform-dirs-0.3.0
	portaudio-rs-0.3.2
	portaudio-sys-0.1.1
	ppv-lite86-0.2.16
	priority-queue-1.2.2
	proc-macro-crate-1.1.3
	proc-macro-hack-0.5.19
	proc-macro2-1.0.39
	protobuf-2.27.1
	protobuf-codegen-2.27.1
	protobuf-codegen-pure-2.27.1
	psl-types-2.0.10
	publicsuffix-2.1.1
	quote-1.0.18
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_distr-0.4.3
	redox_syscall-0.2.13
	redox_termios-0.1.2
	redox_users-0.4.3
	regex-1.5.6
	regex-syntax-0.6.26
	remove_dir_all-0.5.3
	reqwest-0.11.10
	ring-0.16.20
	rodio-0.15.0
	rspotify-0.11.5
	rspotify-http-0.11.5
	rspotify-macros-0.11.5
	rspotify-model-0.11.5
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	rustc-serialize-0.3.24
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustls-0.20.6
	rustversion-1.0.6
	ryu-1.0.10
	same-file-1.0.6
	schannel-0.1.20
	scopeguard-1.1.0
	sct-0.7.0
	security-framework-2.6.1
	security-framework-sys-2.6.1
	semver-0.9.0
	semver-1.0.10
	semver-parser-0.7.0
	serde-1.0.137
	serde_cbor-0.11.2
	serde_derive-1.0.137
	serde_json-1.0.81
	serde_urlencoded-0.7.1
	sha-1-0.9.8
	sha-1-0.10.0
	sha1-0.6.1
	sha1_smol-1.0.0
	sha2-0.10.2
	shannon-0.2.0
	shell-words-1.1.0
	shlex-1.1.0
	signal-hook-0.3.14
	signal-hook-registry-1.4.0
	slab-0.4.6
	smallvec-1.8.0
	socket2-0.4.4
	spin-0.5.2
	stable_deref_trait-1.2.0
	standback-0.2.17
	stdweb-0.1.3
	stdweb-0.4.20
	stdweb-derive-0.5.3
	stdweb-internal-macros-0.2.9
	stdweb-internal-runtime-0.1.5
	strsim-0.10.0
	strum-0.22.0
	strum-0.24.0
	strum_macros-0.22.0
	strum_macros-0.24.0
	subtle-2.4.1
	syn-1.0.96
	synstructure-0.12.6
	tempfile-3.3.0
	term_size-0.3.2
	termcolor-1.1.3
	termion-1.5.6
	textwrap-0.15.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	thread-id-4.0.0
	time-0.1.44
	time-0.2.27
	time-0.3.9
	time-macros-0.1.1
	time-macros-impl-0.1.2
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.19.2
	tokio-macros-1.8.0
	tokio-native-tls-0.3.0
	tokio-stream-0.1.9
	tokio-util-0.7.3
	toml-0.5.9
	tower-service-0.3.1
	tracing-0.1.35
	tracing-core-0.1.27
	tree_magic_mini-3.0.3
	try-lock-0.2.3
	typenum-1.15.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.0
	unicode-normalization-0.1.19
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.3
	untrusted-0.7.1
	ureq-2.4.0
	url-2.2.2
	uuid-1.1.1
	vcpkg-0.2.15
	vergen-3.2.0
	version_check-0.9.4
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-futures-0.4.30
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	wayland-client-0.29.4
	wayland-commons-0.29.4
	wayland-protocols-0.29.4
	wayland-scanner-0.29.4
	wayland-sys-0.29.4
	web-sys-0.3.57
	webpki-0.22.0
	webpki-roots-0.22.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.24.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.24.0
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.24.0
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.24.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.24.0
	windows_x86_64_msvc-0.36.1
	winreg-0.5.1
	winreg-0.10.1
	winrt-notification-0.5.1
	wl-clipboard-rs-0.6.0
	x11-clipboard-0.3.3
	xcb-0.8.2
	xi-unicode-0.3.0
	xml-rs-0.8.4
	zerocopy-0.6.1
	zerocopy-derive-0.3.1
"

inherit cargo

DESCRIPTION="ncurses Spotify client written in Rust using librespot"
HOMEPAGE="https://github.com/hrkfdn/ncspot"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hrkfdn/${PN}.git"
else
	SRC_URI="$(cargo_crate_uris)
			 https://github.com/hrkfdn/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="
	|| ( Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT )
	|| ( Apache-2.0 BSD-2 MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 ISC MIT )
	|| ( Apache-2.0 MIT )
	|| ( Apache-2.0 MIT ZLIB )
	|| ( LGPL-3 MPL-2.0 )
	|| ( MIT Unlicense )
	Apache-2.0
	BSD-2
	BSD
	CC0-1.0
	MIT
	MPL-2.0"
SLOT="0"
IUSE="X alsa pulseaudio portaudio mpris notify clipboard wayland"

DEPEND="
	sys-libs/ncurses
	dev-libs/openssl

	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	portaudio? ( media-libs/portaudio )
	mpris? ( sys-apps/dbus )
	notify? ( sys-apps/dbus )
	clipboard? (
		X? ( x11-libs/libxcb )
		wayland? ( gui-apps/wl-clipboard )
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local myfeatures=(
		cursive/pancurses-backend

		$(usev alsa alsa_backend)
		$(usev pulseaudio pulseaudio_backend)
		$(usev portaudio portaudio_backend)

		$(usev mpris)
		$(usev notify)
		$(usev clipboard $(usev X share_clipboard))
		$(usev clipboard $(usev wayland wayland_clipboard))
	)
	cargo_src_configure --no-default-features
}