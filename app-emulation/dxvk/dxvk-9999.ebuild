# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Vulkan-based implementation of D3D9, D3D10 and D3D11 for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/doitsujin/dxvk"
else
	SRC_URI="
		https://github.com/doitsujin/dxvk/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="+abi_x86_32 +abi_x86_64"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"

RDEPEND="virtual/wine"

pkg_pretend() {
	if use abi_x86_32 && ! has_version "cross-i686-w64-mingw32/gcc"; then
			die "but no compiler to support it was found."
	fi

	if use abi_x86_64 && ! has_version "cross-x86_64-w64-mingw32/gcc"; then
			die "MinGW build was enabled, but no compiler to support it was found."
	fi
}

multilib_src_configure() {
	local emesonargs=(
		--prefix /usr/lib/dxvk/
	)

	if [[ ${ABI} == amd64 ]]; then
		emesonargs+=(
			--cross-file "${S}"/build-win64.txt
			--libdir x64
			--bindir x64
		)
	else
		emesonargs+=(
			--cross-file "${S}"/build-win32.txt
			--libdir x32
			--bindir x32
		)
	fi

	meson_src_configure
}

multilib_src_install_all() {
	find "${ED}" -name '*.a' -delete || die

	insinto /usr/lib/dxvk/
	doins setup_dxvk.sh
	fperms +x /usr/lib/dxvk/setup_dxvk.sh

	dosym -r /usr/lib/dxvk/setup_dxvk.sh /usr/bin/setup_dxvk
}
