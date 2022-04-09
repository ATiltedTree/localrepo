
EAPI=8

inherit java-pkg-2 systemd

DESCRIPTION="an API for interacting with Signal Private Messenger"
HOMEPAGE="https://signald.org/"
SRC_URI="https://gitlab.com/signald/signald/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="systemd"

# Gradle deps
RESTRICT="network-sandbox"

RDEPEND="
  virtual/jre:11
  acct-group/signald
  acct-user/signald
"
DEPEND="
  ${RDEPEND}
  virtual/jdk:11
  dev-java/gradle-bin:*
"

src_compile() {
  gradle --gradle-user-home .gradle --console rich --no-daemon installDist
}

src_install() {
  insinto /usr/share
  doins -r build/install/signald
  dosym -r /usr/share/signald/bin/signald /usr/bin/signald

  if use systemd; then
    systemd_dounit debian/signald.service
  fi

  keepdir /var/run/signald
  fowners signald:signald /var/run/signald
}
