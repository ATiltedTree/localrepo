# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The GNU C Library Compatibility Layer for musl"
HOMEPAGE="https://git.adelielinux.org/adelie/gcompat"
SRC_URI="https://git.adelielinux.org/adelie/gcompat/-/archive/${PV}/${P}.tar.gz"

LICENSE="NCSA"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="elibc_musl"

RDEPEND="
	sys-libs/libucontext
	sys-libs/obstack-standalone
"
DEPEND="${RDEPEND}"


loader_name() {
	case "$ARCH" in
		arm) _ld="ld-linux.so.3" ;;
		arm64) _ld="ld-linux-aarch64.so.1" ;;
		x86) _ld="ld-linux.so.2" ;;
		amd64) _ld="ld-linux-x86-64.so.2" ;;
		s390)	_ld="ld64.so.1" ;;
		ppc64) _ld="ld64.so.2" ;;
	esac
	
	echo "$_ld"
}

linker_path() {
	case "$ARCH" in
		arm64)	arch="aarch64" ;;
		arm)		arch="arm" ;;
		x86)		arch="i386" ;;
		amd64)		arch="x86_64" ;;
		ppc)		arch="powerpc" ;;
		ppc64)		arch="powerpc64" ;;
		s390)		arch="s390x" ;;
		riscv)	arch="riscv64" ;;
	esac
	
	echo "/lib/ld-musl-$arch.so.1"
}

src_compile() {
	emake \
		WITH_LIBUCONTEXT=1 \
		WITH_OBSTACK=obstack-standalone \
		LINKER_PATH="$(linker_path)" \
		LOADER_NAME="$(loader_name)"
}

src_install() {
	emake \
		LINKER_PATH="$(linker_path)" \
		LOADER_NAME="$(loader_name)" \
		WITH_LIBUCONTEXT=1 \
		WITH_OBSTACK=obstack-standalone \
		DESTDIR="${D}" \
		install

	case "$ARCH" in
		amd64|ppc64le|arm64)
			mkdir "${D}"/lib64
			ln -s "../lib/$(loader_name)" "${D}"/lib64/$(loader_name)
			;;
	esac
}
