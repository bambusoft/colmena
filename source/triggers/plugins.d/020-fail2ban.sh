#!/usr/bin/env bash

# Official COLMENA Trigger Script
# ================================================
# This file is part of colmena security project
# Copyright (C) 2010-2022, Mario Rodriguez < colmena (at) bambusoft.com >
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# OS VERSIONS tested:
#	Ubuntu 18.04 32bit and 64bit
#	Ubuntu 20.04 64bit
#
#  Official website: http://colmena.bambusoft.com

. /etc/colmena/colmena.cfg
. /usr/share/colmena/functions.sh

if [ -z "$GLOBALS_LOADED" ]; then
	echo "Unable to load config file"
	exit 1
fi

if [ -z "$FUNCTIONS_LOADED" ]; then
	echo "Unable to load functions file"
	exit 1
fi

is_opt "--test"
if [ "$ISOPTION" = "true" ]; then
	FAIL2BAN_LOG="$vlogt/fail2ban.log"
fi
is_opt "--rotated"
if [ "$ISOPTION" = "true" ]; then
	FAIL2BAN_LOG="${FAIL2BAN_LOG}.1"
fi

SCRIPT_NAME=$(basename "$0")
echo "# Trigger: [fail2ban] $SCRIPT_NAME" | tee -a $COLMENA_LOG_FILE
echo "# List: [BL]" | tee -a $COLMENA_LOG_FILE
if [ -f "$FAIL2BAN_LOG" ]; then
	grep " Ban" $FAIL2BAN_LOG | egrep -v "(Restore|flushBan)" | sed -e 's@^.* Ban @@g' | sort -u
fi
