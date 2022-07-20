# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for mautrix-signal"

ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/mautrix-signal
ACCT_USER_GROUPS=( mautrix-signal signald )

acct-user_add_deps
