#!/usr/bin/env bash

# Magento 2 Bash UnInstall Script
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# @copyright Copyright (c) 2015 by Yaroslav Voronoy (y.voronoy@gmail.com)
# @license   http://www.gnu.org/licenses/

function askValue()
{
    MESSAGE=$1
    READ_DEFAULT_VALUE=$2
    READVALUE=
    if [ "${READ_DEFAULT_VALUE}" ]
    then
        MESSAGE="${MESSAGE} (default: ${READ_DEFAULT_VALUE})"
    fi
    MESSAGE="${MESSAGE}: "
    read -r -p "$MESSAGE" READVALUE
    if [[ $READVALUE = [Nn] ]]
    then
        READVALUE=''
        return
    fi
    if [ -z "${READVALUE}" ] && [ "${READ_DEFAULT_VALUE}" ]
    then
        READVALUE=${READ_DEFAULT_VALUE}
    fi
}

function askConfirmation() {
    if [ "$FORCE" ]
    then
        return 0;
    fi
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            retval=0
            ;;
        *)
            retval=1
            ;;
    esac
    return $retval
}

function printString()
{
    if [[ "$VERBOSE" -eq 1 ]]
    then
        echo "$@";
    fi
}

function printError()
{
    >&2 echo "$@";
}

function printLine()
{
    if [[ "$VERBOSE" -eq 1 ]]
    then
        printf '%50s\n' ' ' | tr ' ' -
    fi
}

if [ ! -f app/etc/env.php ]
then
    printLine
    printError "Looks like this instance was uninstalled earlier";
    exit 0;
fi

VERBOSE=1
CURRENT_DIR_NAME=$(basename "$(pwd)")

BASE_PATH=${CURRENT_DIR_NAME}

function generateDBName()
{
    if [ "$BASE_PATH" ]
    then
        DB_NAME=magento2_$(echo "$BASE_PATH" | sed "s/\//_/g" | sed "s/[^a-zA-Z0-9_]//g" | tr '[:upper:]' '[:lower:]');
    else
        DB_NAME=magento2_$(echo "$CURRENT_DIR_NAME" | sed "s/\//_/g" | sed "s/[^a-zA-Z0-9_]//g" | tr '[:upper:]' '[:lower:]');
    fi
}

generateDBName

if [ -f ]
then
#    DB_NAME=`grep "dbname" -m1 app/etc/env.php | sed -e 's/\s//g' | sed -e "s/'dbname'=>'//" | sed -e "s/',$//"`
    DB_NAME=`grep "dbname" -m1 app/etc/env.php | sed -e "s/'/ /g" | awk '{print $3}'`
fi

echo $DB_NAME

function runCommand()
{
    local _prefixMessage=$1;
    local _suffixMessage=$2
    if [[ "$VERBOSE" -eq 1 ]]
    then
        echo "${_prefixMessage}${CMD}${_suffixMessage}"
    fi

    # shellcheck disable=SC2086
    eval ${CMD};
}

function mysqlQuery()
{
    CMD="${BIN_MYSQL} -u${DB_USER} --password=${DB_PASSWORD} --execute=\"${SQLQUERY}\"";
    runCommand
}

function delete_db()
{
    SQLQUERY="DROP DATABASE IF EXISTS ${DB_NAME}";
    mysqlQuery
}

function print_db_name()
{
    CMD="echo $DB_NAME";
    runCommand
}

function validateStep()
{
    local _step=$1;
    local _steps="delete_db delete_code delete_dumps delete_pwd"
    if echo "$_steps" | grep -q "$_step"
    then
        if type -t "$_step" &>/dev/null
        then
            return 0;
        fi
    fi
    return 1;
}

function prepareSteps()
{
    local _step;
    local _steps;

    _steps=($(echo "${STEPS[@]}" | tr "," " "))
    STEPS=();

    for _step in "${_steps[@]}"
    do
        if validateStep "$_step"
        then
          addStep "$_step"
        fi
    done
}

function addStep()
{
  local _step=$1
  STEPS+=($_step)
}

function print_code()
{

}

################################################################################

export LC_CTYPE=C
export LANG=C

printString Current Directory: "$(pwd)"

START_TIME=$(date +%s)
addStep "print_db_name"
#addStep "delete_db"

prepareSteps

for step in "${STEPS[@]}"
do
    CMD="${step}"
    runCommand "=> "
done
END_TIME=$(date +%s)
SUMMARY_TIME=$((((END_TIME - START_TIME)) / 60));
printString "$(basename "$0") took $SUMMARY_TIME minutes to complete install/deploy process"

printLine

printString "User: admin"
printString "Pass: 123123q"
