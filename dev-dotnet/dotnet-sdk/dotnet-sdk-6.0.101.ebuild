# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs flag-o-matic multiprocessing

DESCRIPTION=".NET SDK (includes .NET Runtime + ASP.NET)"
HOMEPAGE="https://dotnet.microsoft.com/"

MY_PN="dotnet"
MY_P="${MY_PN}-v${PV}"

BOOT_PV="6.0.100"
BOOT_ARTIFACTS_PV="0.1.0-${BOOT_PV}-bootstrap.29"  # See eng/Versions.props
BOOT_ARTIFACTS_P="Private.SourceBuilt.Artifacts.${BOOT_ARTIFACTS_PV}"

BOOT_URI="
	elibc_musl? (
		amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-musl-x64.tar.gz )
		arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-musl-arm.tar.gz )
		arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-musl-arm64.tar.gz )
	)
	!elibc_musl? (
		amd64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-x64.tar.gz )
		arm? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-arm.tar.gz )
		arm64? ( https://dotnetcli.azureedge.net/dotnet/Sdk/${BOOT_PV}/${PN}-${BOOT_PV}-linux-arm64.tar.gz )
	)
"

SRC_SHA="e42d85d4cf5769e38059ea4f546e20452f4975a2ba448f81999deffb8a4e517d098ef23b8576c4654ec7a3b5e35006a90e5bf5ae2808012d3ed068f9d0a7eb90"
SRC_URI="
	${BOOT_URI}
	https://src.fedoraproject.org/lookaside/pkgs/dotnet6.0/${MY_P}.tar.gz/sha512/${SRC_SHA}/${MY_P}.tar.gz
	https://dotnetcli.azureedge.net/source-built-artifacts/assets/${BOOT_ARTIFACTS_P}.tar.gz -> dotnet-${BOOT_ARTIFACTS_P}.tar.gz
"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT Apache-2.0 BSD"
SLOT="6.0"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE="+dotnet-symlink"

RDEPEND="
	app-crypt/mit-krb5
	dev-libs/icu
	<dev-util/lttng-ust-2.13
	sys-libs/libunwind
	dotnet-symlink? ( !dev-dotnet/dotnet-sdk-bin[dotnet-symlink(+)] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/cmake
	dev-vcs/git
"

CHECKREQS_DISK_BUILD="50G"
CHECKREQS_DISK_USR="600M"

dotnet_os() {
	if use elibc_musl; then
		echo linux-musl
	else
		echo linux
	fi
}

dotnet_arch() {
	local arch=""
	use amd64 && arch="x64"
	use arm && arch="arm"
	use arm64 && arch="arm64"
	[[ -z "$arch" ]] && die "Architecture not supported by .NET Core"
	echo "$arch"
}

dotnet_rid() {
	echo "$(dotnet_os)-$(dotnet_arch)"
}

src_unpack() {
	mkdir "${WORKDIR}"/dotnet || die
	cd "${WORKDIR}"/dotnet || die
	unpack ${PN}-${BOOT_PV}-$(dotnet_rid).tar.gz

	mkdir "${WORKDIR}"/packages || die
	cd "${WORKDIR}"/packages || die
	unpack dotnet-${BOOT_ARTIFACTS_P}.tar.gz

	cd "${WORKDIR}" || die
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	mkdir patches || die
	patch_module() {
		cp -r "${FILESDIR}"/$1 patches
		cd src/$1.*/
		if ! use elibc_musl; then
			rm "${S}"/patches/$1/musl.patch
		fi
		eapply "${S}"/patches/$1
		cd "${S}"
	}

	if use elibc_musl; then
		eapply "${FILESDIR}"/musl.patch
	fi
	patch_module aspnetcore
	patch_module command-line-api
	patch_module fsharp
	patch_module installer
	patch_module runtime
	patch_module sdk
	patch_module source-build-reference-packages
	patch_module vstest
	patch_module xliff-tasks

	default
}

src_compile() {
	rm -r packages/archive

	local mybuildargs=(
		--with-sdk "${WORKDIR}"/dotnet
		--with-packages "${WORKDIR}"/packages
		--

		/p:UseSystemLibraries=true
		/p:TargetRid=gentoo-$(dotnet_arch)

		/p:LogVerbosity=normal
		/p:MinimalConsoleLogOutput=false
		/verbosity:normal

		/maxCpuCount:$(makeopts_jobs)
	)

	# Make coreclr work
	if use elibc_musl; then
		append-cxxflags -DENSURE_PRIMARY_STACK_SIZE
	fi

	# For the CLR_* variables, the full path is necessary, see:
	# - src/runtime.*/eng/native/init-compiler.sh
	# - src/runtime.*/eng/native/configuretools.cmake
	# NM, OBJCOPY and OBJDUMP don't seem to be used currently (ver 5.0.203).
	for var in AR CC CXX NM OBJCOPY OBJDUMP RANLIB; do
		local prog="$(tc-get${var})"
		local path="$(type -p "${prog}")"
		[[ -n "${path}" ]] || die "Can't find ${prog} (\${${var}}) in \${PATH}!"
		export CLR_${var}="${path}"
	done

	./build.sh "${mybuildargs[@]}" || die
}

src_install() {
	local dest="/usr/lib/${PN}-${SLOT}"
	local ddest="${ED}/${dest#/}"

	dodir "${dest}"
	tar xf artifacts/*/Release/dotnet-sdk-*.tar.gz -C "${ddest}" || die

	# Unneeded prebuilt things
	rm "${ddest}"/sdk/${PV}/{testhost.x86,vstest.console,TestHost/testhost.x86}

	dosym -r "${dest}"/dotnet /usr/bin/dotnet-${SLOT}

	if use dotnet-symlink; then
		dosym -r /usr/bin/dotnet-${SLOT} /usr/bin/dotnet

		echo "DOTNET_ROOT=\"${EPREFIX}${dest}\"" > "${T}/90${PN}-${SLOT}"
		doenvd "${T}/90${PN}-${SLOT}"
	fi
}
