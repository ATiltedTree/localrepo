# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nuget.eclass
# @MAINTAINER:
# me@atiltedtree.dev
# @AUTHOR:
# Tilmann Meyer <me@atiltedtree.dev>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: common functions and variables for dotnet/nuget builds

if [[ -z ${_NUGET_ECLASS} ]]; then
_NUGET_ECLASS=1


case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS src_unpack

NUGET_VENDOR="${WORKDIR}/nuget"

PKG_REGEX='^([a-zA-Z0-9_\.\-]+)-([0-9]+\.[0-9]+\.[0-9]+.*)$'

# @ECLASS-VARIABLE: NUGET_PKGS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# bash string containing all crates package wants to download
# used by nuget_pkg_uris()
# Example:
# @CODE
# CRATES="
# metal-1.2.3
# bar-4.5.6
# iron_oxide-0.0.1
# "
# inherit cargo
# ...
# SRC_URI="$(nuget_pkg_uris)"
# @CODE

# @FUNCTION: nuget_pkg_uris
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
# Uses first argument as crate list.
# If no argument provided, uses CRATES variable.
nuget_pkg_uris() {
	local pkg pkgs

	if [[ -n ${@} ]]; then
		pkgs="$@"
	elif [[ -n ${NUGET_PKGS} ]]; then
		pkgs="${NUGET_PKGS}"
	else
		eerror "NUGET_PKGS variable is not defined and nothing passed as argument"
		die "Can't generate SRC_URI from empty input"
	fi

	for pkg in ${pkgs}; do
		local name version url
		[[ $pkg =~ $PKG_REGEX ]] || die "Could not parse name and version from pkg: $pkg"
		name="${BASH_REMATCH[1]}"
		version="${BASH_REMATCH[2]}"
		url="https://www.nuget.org/api/v2/package/${name}/${version} -> ${pkg}.nupkg"
		echo "${url}"
	done
}

# @FUNCTION: nuget_src_unpack
# @DESCRIPTION:
# Unpacks the package and the nuget registry
nuget_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${NUGET_VENDOR}" || die
	mkdir -p "${S}" || die

	local archive shasum pkg
	for archive in ${A}; do
		case "${archive}" in
			*.nupkg)
				pkg=${archive/.nupkg/}
				[[ $pkg =~ $PKG_REGEX ]] || die "Could not parse name and version from pkg: $pkg"
				name="${BASH_REMATCH[1]}"
				version="${BASH_REMATCH[2]}"
				ln -s "${DISTDIR}/${archive}" "${NUGET_VENDOR}/${name}.${version}.nupkg" || die
				;;
			*)
				unpack ${archive}
				;;
		esac
	done
}

# @FUNCTION: nuget_registry
# @DESCRIPTION:
# Print the location of the nuget registry
nuget_registry() {
	echo "${NUGET_VENDOR}"
}

fi
