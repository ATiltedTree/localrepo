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

SRC_SHA="dcb4102b1a6c9e1889d80f8cecf30da00ad16320cbbf14de891db632ebaa0b872501865957429107ade0caef569a2f2ed5ccb70111de7772838b820997f0c36e"
SRC_URI="
	!system-bootstrap? ( ${BOOT_URI} )
	https://dotnetcli.azureedge.net/source-built-artifacts/assets/${BOOT_ARTIFACTS_P}.tar.gz -> dotnet-${BOOT_ARTIFACTS_P}.tar.gz
	https://src.fedoraproject.org/lookaside/pkgs/dotnet6.0/${MY_P}.tar.gz/sha512/${SRC_SHA}/${MY_P}.tar.gz
"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT Apache-2.0 BSD"
SLOT="6.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+dotnet-symlink system-bootstrap"

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
	system-bootstrap? ( >=dev-dotnet/dotnet-sdk-${BOOT_PV} )
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
	use x86 && arch="x86"
	use arm && arch="arm"
	use arm64 && arch="arm64"
	[[ -z "$arch" ]] && die "Architecture not supported by .NET"
	echo "$arch"
}

src_unpack() {
	if use system-bootstrap; then
		# SDK is modified in-place...
		mkdir "${WORKDIR}"/dotnet || die
		cp -a "${BROOT}"/usr/lib/dotnet-sdk-${SLOT}/{host,packs,shared,sdk,dotnet} "${WORKDIR}"/dotnet || die
	else
		mkdir "${WORKDIR}"/dotnet || die
		cd "${WORKDIR}"/dotnet || die
		unpack ${PN}-${BOOT_PV}-$(dotnet_os)-$(dotnet_arch).tar.gz
	fi

	mkdir "${WORKDIR}"/packages || die
	cd "${WORKDIR}"/packages || die
	unpack dotnet-${BOOT_ARTIFACTS_P}.tar.gz

	cd "${WORKDIR}" || die
	unpack ${MY_P}.tar.gz
}

src_prepare() {
	mkdir patches || die
	patch_module() {
		local patch_dir="${S}"/patches/$1
		cp -r "${FILESDIR}"/$1 patches
		cd src/$1.*/
		if ! use elibc_musl; then
			rm $patch_dir/*musl*.patch
		fi
		if [ -z "$(ls -A $patch_dir)" ]; then
			:;
		else
			eapply $patch_dir
		fi
		cd "${S}"
	}

	eapply "${FILESDIR}"/system-bootstrap.patch
	if use elibc_musl; then
		eapply "${FILESDIR}"/musl.patch
	fi
	patch_module command-line-api
	patch_module installer
	patch_module runtime
	patch_module sdk

	default
}

src_compile() {
	rm -r packages/archive

	local mybuildargs=(
		--with-sdk "${WORKDIR}"/dotnet
		--with-packages "${WORKDIR}"/packages
		--

		/p:UseSystemLibraries=true
		/p:TargetRid="gentoo-$(dotnet_arch)"

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
