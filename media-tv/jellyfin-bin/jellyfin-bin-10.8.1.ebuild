
EAPI=8

MY_PV="${PV/_/-}"

BASE_URI="https://repo.jellyfin.org/releases/server/linux/stable"

if [[ ${PV} == *_beta* ]] ; then
  BASE_URI+="-pre/${MY_PV}"
fi

DESCRIPTION="The Free Software Media System"
HOMEPAGE="https://jellyfin.org"
SRC_URI="
  elibc_musl? (
    amd64? ( $BASE_URI/server/jellyfin-server_${MY_PV}_linux-amd64-musl.tar.gz )
  )
  !elibc_musl? (
    amd64? ( $BASE_URI/server/jellyfin-server_${MY_PV}_linux-amd64.tar.gz )
    arm64? ( $BASE_URI/server/jellyfin-server_${MY_PV}_linux-arm64.tar.gz )
  )
  web? ( $BASE_URI/web/jellyfin-web_${MY_PV}_portable.tar.gz )
"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 arm64"

IUSE="+web"

RESTRICT="strip"

src_install() {
  insinto /opt/jellyfin
  doins -r "jellyfin-server_${MY_PV}/"*
  if use web; then
    insinto /opt/jellyfin/jellyfin-web
    doins -r "jellyfin-web_${MY_PV}/"*  
  fi
  
  fperms +x /opt/jellyfin/jellyfin
  dosym -r /opt/jellyfin/jellyfin /usr/bin/jellyfin
}