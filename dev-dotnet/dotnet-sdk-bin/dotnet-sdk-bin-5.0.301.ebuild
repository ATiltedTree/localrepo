# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV="${PV}"

DESCRIPTION=".NET is a free, cross-platform, open-source developer platform"
HOMEPAGE="https://dotnet.microsoft.com/"
LICENSE="MIT"

URI_BASE="https://dotnetcli.azureedge.net/dotnet/Sdk/${MY_PV}/dotnet-sdk-${MY_PV}-linux"

SRC_URI="
	elibc_glibc? (
		amd64? ( ${URI_BASE}-x64.tar.gz )
		arm? ( ${URI_BASE}-arm.tar.gz )
		arm64? ( ${URI_BASE}-arm64.tar.gz )
	)
	elibc_musl? (
		amd64? ( ${URI_BASE}-musl-x64.tar.gz )
		arm? ( ${URI_BASE}-musl-arm.tar.gz )
		arm64? ( ${URI_BASE}-musl-arm64.tar.gz )
	)
"

SLOT="5.0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+dotnet-symlink"
QA_PREBUILT="*"
RESTRICT+=" splitdebug"
RDEPEND="
	app-crypt/mit-krb5:0/0
	<dev-util/lttng-ust-2.13.0:0
	sys-libs/zlib:0/1
	dotnet-symlink? ( !dev-dotnet/dotnet-sdk[dotnet-symlink(+)] )
"

S=${WORKDIR}

src_install() {
	local dest="opt/${PN}-${SLOT}"
	dodir "${dest%/*}"

	{ mv "${S}" "${ED}/${dest}" && mkdir "${S}" && fperms 0755 "/${dest}"; } || die
	dosym "../../${dest}/dotnet" "/usr/bin/dotnet-bin-${SLOT}"

	if use dotnet-symlink; then
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet"
		dosym "../../${dest}/dotnet" "/usr/bin/dotnet-${SLOT}"

		# set an env-variable for 3rd party tools
		echo "DOTNET_ROOT=/${dest}" > "${T}/90${PN}-${SLOT}" || die
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
