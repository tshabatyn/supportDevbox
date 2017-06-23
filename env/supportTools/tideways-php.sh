#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION=1.0.0
SCRIPT_NAME=$(basename "${0}");

################################################################################
# Action Controllers
################################################################################
tidewaysAction()
{
  local flag="${1:-0}"
  local ini=$(php --ini | grep -i tideways | head -1)
  ini=$(echo "$ini" | sed s/,$//)

  if [ ! -f "${ini}" ]; then
      echo "> ERROR: No Tideways profiler INI file found ..." 1>&2 && return 1
  fi

  if [ "$flag" -eq 0 ]; then
      sed -i'' -e 's/^extens/;extens/g' "${ini}" \
      && sed -i 's%^auto_prepend_file%;auto_prepend_file%g' /usr/local/etc/php/php.ini \
        && echo "> Tideways profiler DISABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  else
      sed -i'' -e 's/^;extens/extens/g' "${ini}" \
      && sed -i 's%^;auto_prepend_file%auto_prepend_file%g' /usr/local/etc/php/php.ini \
        && echo "> Tideways profiler ENABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  fi

  reloadPhpFpmIni.sh

}
################################################################################
# Main
################################################################################
main()
{
  tidewaysAction "$@"
}
main "${@:-}"

