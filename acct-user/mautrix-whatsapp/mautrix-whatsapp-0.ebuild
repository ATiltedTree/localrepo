# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for mautrix-whatsapp"

ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/mautrix-whatsapp
ACCT_USER_GROUPS=( mautrix-whatsapp )

acct-user_add_deps
