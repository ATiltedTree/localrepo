# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Symbols-only fonts from nerd fonts"
HOMEPAGE="https://github.com/ryanoasis/nerd-fonts"
COMMIT="2d218ec31e98c959a368fb9bba45c0ee52103c87"
SRC_URI="
	https://github.com/ryanoasis/nerd-fonts/raw/${COMMIT}/10-nerd-font-symbols.conf
	https://github.com/ryanoasis/nerd-fonts/raw/${COMMIT}/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONT_CONF=( "${S}/10-nerd-font-symbols.conf" )

src_unpack() {
	for f in ${A}
	do
		cp "${DISTDIR}/$f" "${S}"
	done
	mv "${S}"/Symbols-2048-em%20Nerd%20Font%20Complete.ttf "${S}"/"Symbols Nerd Font Complete.ttf"
}
