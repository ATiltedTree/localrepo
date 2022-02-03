# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A library for reading and sampling audio files."
HOMEPAGE="https://git.sr.ht/~alextee/libaudec"
SRC_URI="https://git.sr.ht/~alextee/libaudec/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-v${PV}"

RDEPEND="
	>=media-libs/libsamplerate-0.1.8
	>=media-libs/libsndfile-1.0.25


"
DEPEND="${RDEPEND}"
