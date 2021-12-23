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
	ahash-0.6.3
	aho-corasick-0.7.18
	alsa-0.5.0
	alsa-sys-0.3.1
	ansi_term-0.12.1
	array-macro-1.0.5
	arrayref-0.3.6
	arrayvec-0.5.2
	async-io-1.6.0
	async-trait-0.1.52
	atty-0.2.11
	autocfg-1.0.1
	backtrace-0.3.63
	base-x-0.2.8
	base64-0.13.0
	bindgen-0.56.0
	bitflags-1.3.2
	blake2b_simd-0.5.11
	block-0.1.6
	block-buffer-0.9.0
	bumpalo-3.8.0
	byteorder-1.4.3
	bytes-1.1.0
	cache-padded-1.1.1
	cc-1.0.72
	cesu8-1.1.0
	cexpr-0.4.0
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	chunked_transfer-1.4.0
	cipher-0.2.5
	clang-sys-1.3.0
	clap-2.34.0
	clipboard-0.5.0
	clipboard-win-2.2.0
	cloudabi-0.0.3
	combine-4.6.2
	concurrent-queue-1.2.2
	const_fn-0.4.8
	constant_time_eq-0.1.5
	convert_case-0.4.0
	cookie-0.15.1
	cookie_store-0.15.1
	core-foundation-0.9.2
	core-foundation-sys-0.8.3
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.8
	cpal-0.13.4
	cpufeatures-0.2.1
	crossbeam-channel-0.5.1
	crossbeam-utils-0.8.5
	crypto-mac-0.11.1
	ctr-0.6.0
	cursive-0.16.3
	cursive_core-0.2.2
	darling-0.10.2
	darling_core-0.10.2
	darling_macro-0.10.2
	dbus-0.9.5
	dbus-tree-0.9.2
	derivative-2.2.0
	derive-new-0.5.9
	derive_more-0.99.17
	digest-0.9.0
	dirs-1.0.5
	dirs-next-1.0.2
	dirs-sys-next-0.1.2
	discard-1.0.4
	downcast-rs-1.2.0
	encoding_rs-0.8.30
	enum-map-0.6.4
	enum-map-derive-0.4.6
	enumflags2-0.6.4
	enumflags2_derive-0.6.4
	exitfailure-0.5.1
	failure-0.1.8
	failure_derive-0.1.8
	fastrand-1.5.0
	fern-0.6.0
	fixedbitset-0.2.0
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	futures-0.1.31
	futures-0.3.18
	futures-channel-0.3.18
	futures-core-0.3.18
	futures-executor-0.3.18
	futures-io-0.3.18
	futures-lite-1.12.0
	futures-macro-0.3.18
	futures-sink-0.3.18
	futures-task-0.3.18
	futures-util-0.3.18
	generic-array-0.14.4
	getrandom-0.1.16
	getrandom-0.2.3
	gimli-0.26.1
	glob-0.3.0
	h2-0.3.9
	half-1.8.2
	hashbrown-0.11.2
	headers-0.3.5
	headers-core-0.2.0
	heck-0.3.3
	hermit-abi-0.1.20
	hmac-0.11.0
	http-0.2.5
	http-body-0.4.4
	httparse-1.5.1
	httpdate-1.0.2
	hyper-0.14.16
	hyper-proxy-0.9.1
	hyper-tls-0.5.0
	ident_case-1.0.1
	idna-0.2.3
	indexmap-1.7.0
	instant-0.1.12
	ioctl-rs-0.2.0
	ipnet-2.3.1
	itoa-0.4.8
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.24
	js-sys-0.3.55
	lazy_static-0.2.11
	lazy_static-1.4.0
	lazycell-1.3.0
	lewton-0.10.2
	libc-0.2.110
	libdbus-sys-0.2.2
	libloading-0.7.2
	libm-0.2.1
	libpulse-binding-2.25.0
	libpulse-simple-binding-2.24.1
	libpulse-simple-sys-1.19.2
	libpulse-sys-1.19.3
	librespot-audio-0.3.1
	librespot-core-0.3.1
	librespot-metadata-0.3.1
	librespot-playback-0.3.1
	librespot-protocol-0.3.1
	lock_api-0.3.4
	lock_api-0.4.5
	log-0.4.14
	mac-notification-sys-0.3.0
	mach-0.3.2
	malloc_buf-0.0.6
	maplit-1.0.2
	matches-0.1.9
	maybe-async-0.2.6
	memchr-1.0.2
	memchr-2.4.1
	mime-0.3.16
	mime_guess-2.0.3
	miniz_oxide-0.4.4
	mio-0.7.14
	miow-0.3.7
	native-tls-0.2.8
	nb-connect-1.2.0
	ncurses-5.101.0
	ndk-0.3.0
	ndk-0.4.0
	ndk-glue-0.3.0
	ndk-glue-0.4.0
	ndk-macro-0.2.0
	ndk-sys-0.2.2
	nix-0.17.0
	nix-0.18.0
	nix-0.20.0
	nom-3.2.1
	nom-5.1.2
	notify-rust-4.5.5
	ntapi-0.3.6
	num-0.3.1
	num-bigint-0.4.3
	num-complex-0.3.1
	num-derive-0.3.3
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.0
	num_enum-0.5.4
	num_enum_derive-0.5.4
	numtoa-0.1.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	object-0.27.1
	oboe-0.4.4
	oboe-sys-0.4.4
	ogg-0.8.0
	once_cell-1.8.0
	opaque-debug-0.3.0
	openssl-0.10.38
	openssl-probe-0.1.4
	openssl-sys-0.9.71
	os_pipe-0.9.2
	owning_ref-0.4.1
	pancurses-0.16.1
	pancurses-0.17.0
	parking-2.0.0
	parking_lot-0.10.2
	parking_lot-0.11.2
	parking_lot_core-0.7.2
	parking_lot_core-0.8.5
	pbkdf2-0.8.0
	pdcurses-sys-0.7.1
	peeking_take_while-0.1.2
	percent-encoding-2.1.0
	petgraph-0.5.1
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	pkg-config-0.3.23
	platform-dirs-0.3.0
	polling-2.2.0
	portaudio-rs-0.3.2
	portaudio-sys-0.1.1
	ppv-lite86-0.2.15
	priority-queue-1.2.1
	proc-macro-crate-0.1.5
	proc-macro-crate-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.33
	protobuf-2.25.2
	protobuf-codegen-2.25.2
	protobuf-codegen-pure-2.25.2
	psl-types-2.0.10
	publicsuffix-2.1.1
	quote-1.0.10
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_distr-0.4.2
	rand_hc-0.3.1
	redox_syscall-0.1.57
	redox_syscall-0.2.10
	redox_termios-0.1.2
	redox_users-0.3.5
	redox_users-0.4.0
	regex-1.5.4
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	reqwest-0.11.7
	ring-0.16.20
	rodio-0.14.0
	rspotify-0.11.3
	rspotify-http-0.11.3
	rspotify-macros-0.11.3
	rspotify-model-0.11.3
	rust-argon2-0.8.3
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	rustc-serialize-0.3.24
	rustc_version-0.2.3
	rustc_version-0.4.0
	rustls-0.20.2
	rustversion-1.0.6
	ryu-1.0.6
	same-file-1.0.6
	schannel-0.1.19
	scoped-tls-1.0.0
	scopeguard-1.1.0
	sct-0.7.0
	security-framework-2.4.2
	security-framework-sys-2.4.2
	semver-0.9.0
	semver-1.0.4
	semver-parser-0.7.0
	serde-1.0.131
	serde_cbor-0.11.2
	serde_derive-1.0.131
	serde_json-1.0.72
	serde_repr-0.1.7
	serde_urlencoded-0.7.0
	sha-1-0.9.8
	sha1-0.6.0
	sha2-0.9.8
	shannon-0.2.0
	shell-words-1.0.0
	shlex-0.1.1
	signal-hook-0.3.12
	signal-hook-registry-1.4.0
	slab-0.4.5
	smallvec-1.7.0
	socket2-0.4.2
	spin-0.5.2
	stable_deref_trait-1.2.0
	standback-0.2.17
	static_assertions-1.1.0
	stderrlog-0.4.3
	stdweb-0.1.3
	stdweb-0.4.20
	stdweb-derive-0.5.3
	stdweb-internal-macros-0.2.9
	stdweb-internal-runtime-0.1.5
	strsim-0.8.0
	strsim-0.9.3
	structopt-0.3.25
	structopt-derive-0.4.18
	strum-0.22.0
	strum-0.23.0
	strum_macros-0.22.0
	strum_macros-0.23.1
	subtle-2.4.1
	syn-1.0.82
	synstructure-0.12.6
	tempfile-3.2.0
	term_size-0.3.2
	termcolor-1.1.2
	termion-1.5.6
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-0.3.4
	time-0.1.44
	time-0.2.27
	time-macros-0.1.1
	time-macros-impl-0.1.2
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	tokio-1.14.0
	tokio-macros-1.6.0
	tokio-native-tls-0.3.0
	tokio-stream-0.1.8
	tokio-util-0.6.9
	toml-0.5.8
	tower-service-0.3.1
	tracing-0.1.29
	tracing-core-0.1.21
	tree_magic-0.2.3
	try-lock-0.2.3
	typenum-1.14.0
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	unreachable-1.0.0
	untrusted-0.7.1
	ureq-2.3.1
	url-2.2.2
	uuid-0.8.2
	vcpkg-0.2.15
	vec_map-0.8.2
	vergen-3.2.0
	version_check-0.9.3
	void-1.0.2
	waker-fn-1.1.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-futures-0.4.28
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	wasmer_enumset-1.0.1
	wasmer_enumset_derive-0.5.0
	wayland-client-0.27.0
	wayland-commons-0.27.0
	wayland-protocols-0.27.0
	wayland-scanner-0.27.0
	wayland-sys-0.27.0
	web-sys-0.3.55
	webbrowser-0.5.5
	webpki-0.22.0
	webpki-roots-0.22.1
	wepoll-ffi-0.1.2
	widestring-0.4.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.24.0
	windows_i686_gnu-0.24.0
	windows_i686_msvc-0.24.0
	windows_x86_64_gnu-0.24.0
	windows_x86_64_msvc-0.24.0
	winreg-0.5.1
	winreg-0.7.0
	winrt-notification-0.5.0
	wl-clipboard-rs-0.4.1
	x11-clipboard-0.3.3
	xcb-0.8.2
	xi-unicode-0.3.0
	xml-rs-0.8.4
	zbus-1.9.1
	zbus_macros-1.9.1
	zerocopy-0.3.0
	zerocopy-derive-0.2.0
	zvariant-2.10.0
	zvariant_derive-2.10.0
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
	KEYWORDS="~amd64"
fi

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 CC0-1.0 ISC LGPL-3 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
IUSE="X alsa pulseaudio portaudio mpris notify clipboard wayland"

DEPEND="
	sys-libs/ncurses
	dev-libs/openssl

	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	portaudio? ( media-libs/portaudio )
	mpris? ( sys-apps/dbus )
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
