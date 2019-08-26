#!/bin/bash
###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     :
#                                                                             #
#                                                                             #
#                                                                             #
###############################################################################
#                           Identify Script Home                              #
################################################################################
#Find the script file home

pushd . > /dev/null

SCRIPT_DIRECTORY="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_DIRECTORY}" ]);
do
  cd "`dirname "${SCRIPT_DIRECTORY}"`"
  SCRIPT_DIRECTORY="$(readlink "`basename "${SCRIPT_DIRECTORY}"`")";
done
cd "`dirname "${SCRIPT_DIRECTORY}"`" > /dev/null
SCRIPT_DIRECTORY="`pwd`";
popd  > /dev/null
MODULE_HOME="`dirname "${SCRIPT_DIRECTORY}"`"
###############################################################################
#                           Import Dependencies                               #
###############################################################################

#Load common dependencies

. ${SCRIPT_DIRECTORY}/bin/constants.sh
. ${SCRIPT_DIRECTORY}/bin/common_functions.sh

###############################################################################
#                                Implementation                               #
###############################################################################


 SCRIPT_NAME=$1

 fn_assert_variable_is_set "SCRIPT_NAME" "${SCRIPT_NAME}"

 SCRIPT_TYPE=$2

 fn_assert_variable_is_set "SCRIPT_TYPE" "${SCRIPT_TYPE}"

 SCRIPT_PATH=$2

 fn_assert_variable_is_set "SCRIPT_PATH" "${SCRIPT_PATH}"

 TARGET_MAIL=$3

 fn_assert_variable_is_set "TARGET_MAIL" "${TARGET_MAIL}"

 fn_run_modular_bash_script \
    ${SCRIPT_NAME} \
    ${SCRIPT_PATH} \
    ${SCRIPT_TYPE} \
    ${TARGET_MAIL}

