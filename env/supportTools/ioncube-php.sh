#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION=1.0.0
SCRIPT_NAME=$(basename "${0}");

################################################################################
# Action Controllers
################################################################################
ioncubeAction()
{
  local flag="${1:-0}"
  local ini=$(php --ini | grep -i ioncube | head -1)
  ini=$(echo "$ini" | sed s/,$//)

  if [ ! -f "${ini}" ]; then
      echo "> ERROR: No Ioncube INI file found ..." 1>&2 && return 1
  fi

  if [ "$flag" -eq 0 ]; then
      sed -i'' -e 's/^zend/;zend/g' "${ini}" \
        && echo "> Ioncube DISABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  else
      sed -i'' -e 's/^;zend/zend/g' "${ini}" \
        && echo "> Ioncube ENABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  fi

  reloadPhpFpmIni.sh
}


################################################################################
# Main
################################################################################
main()
{
  ioncubeAction "$@"
}
main "${@:-}"

