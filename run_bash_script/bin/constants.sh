#!/usr/bin/env bash


##
#/**
#* This has defintions of commonly used constants.
#*/
##

###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     : This script contains declaration of all the constants.                #
#                                                                             #
# Note                                                                        #
#     : 1) Do not modify values of constants declared as final.               #
#       2) Exit code shall always be be greater than 0 and less               #
#          than 256.                                                          #
#                                                                             #
#                                                                             #
###############################################################################
#                             Constant Declarations                           #
###############################################################################

###
# Integer representation of boolean true
# @Type  : Integer
# @Final : true

#/**
#* Integer representation of boolean true
#*/
BOOLEAN_TRUE=1

#/**
#* Integer representation of boolean true
#*/
n1='
'

#/**
#* Integer representation of boolean true
#*/
n2='

'

###
# Integer representation of boolean true
# @Type  : Integer
# @Final : true

#/**
#* Integer representation of boolean true
#*/
INCREMENT_TYPE="increment"

#/**
#* Integer representation of boolean true
#*/
EXECUTION_FAIL_STATUS="Status Update- Script Failed to execute"

#/**
#* Integer representation of boolean true
#*/
EXECUTION_SUCCESS_STATUS="Status Update- Script Executed Successfully"

###
# Integer representation of boolean true
# @Type  : Integer
# @Final : true

#/**
#* Integer representation of boolean true
#*/
FULL_LOAD_TYPE="full-load"


###
# Integer representation of boolean false
# @Type  : Integer
# @Final : true

#/**
#* Integer representation of boolean false
#*/
BOOLEAN_FALSE=0

###
# Constant to represent flag to fail in case of
# some error situation.
# @Type  : Integer
# @Final : true

#/**
#* Constant to represent flag to fail in case of some error situation.
#*/
FAIL_ON_ERROR=1

###
# Constant to represent exit code returned by
# successful execution of command/function
# @Type  : Integer
# @Final : true

#/**
#* Constant to represent exit code returned by successful execution of command/function
#*/
EXIT_CODE_SUCCESS=0

###
# Constant to represent exit code returned by
# un-successful execution of command/function
# @Type  : Integer
# @Final : true

#/**
#* Constant to represent exit code returned by un-successful execution of command/function
#*/
EXIT_CODE_FAIL=1

###
# Constant to represent exit code that should be
# returned when value for a required variable is
# not set.
# @Type  : Integer
# @Final : true

#/**
#* # Constant to represent exit code that should be returned when value for a required variable is not set.
#*/
EXIT_CODE_VARIABLE_NOT_SET=2


###
# Constant to represent exit code that should be
# returned when the file is empty
# not set.
# @Type  : Integer
# @Final : true

#/**
#* Constant to represent exit code that should be returned when the file is empty not set.
#*/
EXIT_CODE_FILE_IS_EMPTY=3


###############################################################################
#                                     End                                     #
###############################################################################