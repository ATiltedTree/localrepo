# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit linux-info python-single-r1 desktop systemd

DESCRIPTION="Waydroid uses a container-based approach to boot a full Android system."
HOMEPAGE="https://waydro.id"
SRC_URI="https://github.com/waydroid/waydroid/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	app-containers/lxc
	net-firewall/nftables
	net-dns/dnsmasq
	$(python_gen_cond_dep '
		dev-python/gbinder-python[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	${DEPEND}
"

CONFIG_CHECK="
	~ANDROID
	~ANDROID_BINDERFS
	~ANDROID_BINDER_IPC
	~ASHMEM
"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	mv data/Waydroid.desktop . || die
	mv data/AppIcon.png . || die

	sed -i -e 's#tools_src = .*#tools_src = "/usr/share/waydroid/"#' tools/config/__init__.py || die
	sed -i -e 's#/usr/lib/waydroid/data/AppIcon.png#waydroid#' Waydroid.desktop || die
	sed -i -e 's/tools/waydroid/g' waydroid.py tools/**/*.py || die
}

src_install() {
	python_moduleinto waydroid
	python_domodule tools/*
	python_newscript waydroid.py waydroid

	insinto /usr/share/waydroid
	doins -r data

	domenu Waydroid.desktop
	newicon AppIcon.png waydroid.png

	systemd_dounit debian/waydroid-container.service
}
