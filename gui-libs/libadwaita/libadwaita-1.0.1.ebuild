# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala xdg

DESCRIPTION="Building blocks for modern GNOME applications."
HOMEPAGE="https://gitlab.gnome.org/GNOME/libadwaita"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+introspection +vala test examples gtk-doc"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	introspection? ( dev-libs/gobject-introspection:= )
	>=gui-libs/gtk-4.5.0:4
	dev-libs/fribidi
"

RDEPEND="${DEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	virtual/pkgconfig
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
		$(meson_use examples)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
