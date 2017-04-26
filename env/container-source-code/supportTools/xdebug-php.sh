#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION=1.0.0
SCRIPT_NAME=$(basename "${0}");

################################################################################
# Action Controllers
################################################################################
xdebugAction()
{
  local flag="${1:-0}"
  local ini=$(php --ini | grep -i xdebug | head -1)
  ini=$(echo "$ini" | sed s/,$//)

  if [ ! -f "${ini}" ]; then
      echo "> ERROR: No Xdebug INI file found ..." 1>&2 && return 1
  fi

  if [ "$flag" -eq 0 ]; then
      sed -i'' -e 's/^zend/;zend/g' "${ini}" \
        && echo "> Xdebug DISABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  else
      sed -i'' -e 's/^;zend/zend/g' "${ini}" \
        && echo "> Xdebug ENABLED in ${ini}" \
        || { echo "> ERROR: failed to update ${ini} file ..." 1>&2 && return 1; }
  fi

  local web_php_fpm_pid=`/bin/ps aux | grep "php-fpm: master process" | grep -v "grep" | awk '{print $2}'`

  kill -USR2 1
  kill -USR2 $web_php_fpm_pid
  php -v
}


################################################################################
# Main
################################################################################
main()
{
  xdebugAction "$@"
}
main "${@:-}"

