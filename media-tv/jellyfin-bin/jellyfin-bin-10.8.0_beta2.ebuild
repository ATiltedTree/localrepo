
EAPI=8

MY_PV="${PV/_/-}"

DESCRIPTION="The Free Software Media System"
HOMEPAGE="https://jellyfin.org"
SRC_URI="
  elibc_musl? (
    amd64? ( https://repo.jellyfin.org/releases/server/linux/stable-pre/${MY_PV}/combined/jellyfin_${MY_PV}_amd64-musl.tar.gz )
  )
  !elibc_musl? (
    amd64? ( https://repo.jellyfin.org/releases/server/linux/stable-pre/${MY_PV}/combined/jellyfin_${MY_PV}_amd64.tar.gz )
    arm64? ( https://repo.jellyfin.org/releases/server/linux/stable-pre/${MY_PV}/combined/jellyfin_${MY_PV}_arm64.tar.gz )
  )
"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RESTRICT="strip"

src_install() {
  insinto /opt/jellyfin
  doins -r "jellyfin_${MY_PV}/"*
  dosym -r /opt/jellyfin/jellyfin /usr/bin/jellyfin
}