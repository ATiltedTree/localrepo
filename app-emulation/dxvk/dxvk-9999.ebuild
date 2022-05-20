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

BDEPEND="dev-util/mingw64-toolchain[${MULTILIB_USEDEP}]"
RDEPEND="virtual/wine"

src_configure() {
	PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local arch=
	if [[ ${ABI} == amd64 ]]; then
		arch="64"
	else
		arch="32"
	fi

	local emesonargs=(
		--prefix /usr/lib/dxvk/
		--cross-file "${S}"/build-win$arch.txt
		--libdir x$arch
		--bindir x$arch
	)

	meson_src_configure
}

multilib_src_install_all() {
	find "${ED}" -name '*.a' -delete || die

	insinto /usr/lib/dxvk/
	doins setup_dxvk.sh
	fperms +x /usr/lib/dxvk/setup_dxvk.sh

	dosym -r /usr/lib/dxvk/setup_dxvk.sh /usr/bin/setup_dxvk
}
