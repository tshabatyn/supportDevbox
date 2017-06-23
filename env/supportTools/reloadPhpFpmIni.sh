#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION=1.0.0
SCRIPT_NAME=$(basename "${0}");

################################################################################
# Action Controllers
################################################################################
reloadPhpFpmIni()
{
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
  reloadPhpFpmIni "$@"
}
main "${@:-}"

