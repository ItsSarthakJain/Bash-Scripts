#!/usr/bin/env bash

function fn_run_modular_bash_script(){

    SCRIPT_NAME=$1

    fn_assert_variable_is_set "SCRIPT_NAME" "${SCRIPT_NAME}"

    SCRIPT_TYPE=$2

    fn_assert_variable_is_set "SCRIPT_TYPE" "${SCRIPT_TYPE}"

    TARGET_MAIL=$3

    fn_assert_variable_is_set "TARGET_MAIL" "${TARGET_MAIL}"

    declare -a MODULE_LIST

    if [[ "${SCRIPT_TYPE}" = "${INCREMENT_TYPE}" ]];then

        MODULE_LIST=(setup ingest export cleanup)

    elif [[ "${SCRIPT_TYPE}" = "${FULL_LOAD_TYPE}" ]];then

        MODULE_LIST=(ingest export)

    else

        fn_exit_with_failure_message "1" "${SCRIPT_NAME} Failed to Execute as ${SCRIPT_TYPE} is not correcly Assigned" "${TARGET_MAIL}"

    fi

    exit_code=$?

    if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

            fn_exit_with_failure_message "1" "${SCRIPT_NAME} Failed to Execute" "${TARGET_MAIL}"

    else

            fn_exit_with_success_message "0" "${SCRIPT_NAME} Executed Successfully" "${TARGET_MAIL}"

    fi

}

function fn_run_bash_script(){

    SCRIPT_NAME=$1

    fn_assert_variable_is_set "SCRIPT_NAME" "${SCRIPT_NAME}"

    SCRIPT_PATH=$2

    fn_assert_variable_is_set "SCRIPT_PATH" "${SCRIPT_PATH}"

    TARGET_MAIL=$3

    fn_assert_variable_is_set "TARGET_MAIL" "${TARGET_MAIL}"

    TIMESTAMP=`date "+%Y-%m-%d|%H:%M:%S" `

    LOG_FILE=${SCRIPT_NAME::-3}-${TIMESTAMP}.log

    time sh ${SCRIPT_PATH}/${SCRIPT_NAME}>>${LOG_FILE}

    exit_code=$?

    if [[ "${SCRIPT_TYPE}" != "${EXIT_CODE_SUCCESS}" ]];then

            fn_exit_with_failure_message "1" "${SCRIPT_NAME} Failed to Execute" "${TARGET_MAIL}" "${LOG_FILE}"

    else

            fn_exit_with_success_message "0" "${SCRIPT_NAME} Executed Successfully" "${TARGET_MAIL}" "${LOG_FILE}"

    fi

}

function fn_sendmail(){

    mailbody=$1

    fn_assert_variable_is_set "mailbody" "${mailbody}"

    subject=$2

    fn_assert_variable_is_set "subject" "${subject}"

    target_mail=$3

    fn_assert_variable_is_set "target_mail" "${target_mail}"

    logfile=$4

    if fn_check_if_file_exists "${logfile}"; then

        echo "${mailbody}"| mailx -s "${subject}" -a "${logfile}" "${target_mail}"

    fi

}

function fn_send_mail_job_failed(){

    failure_message=$1

    fn_assert_variable_is_set "failure_message" "${failure_message}"

    target_mail=$2

    fn_assert_variable_is_set "target_mail" "${target_mail}"

    logs_attchment=$3

    email_subject="${EXECUTION_FAIL_STATUS}"

    fn_assert_variable_is_set "email_subject" "${email_subject}"

    message_body=$Dated:`date +%m-%d-%Y`\n\n\n Dear Recipient,\n\nYou are receiving this message as ${failure_message}.'

    #email_format_failure="Content-Type: text/html\r\nSubject: Status Update: Script Failed to execute   \r\n\r\n <p style='font-size:12pt'>Dated: `date +%m-%d-%Y`</p><p style='font-size:11pt'>Dear Recipient,</p><p style='font-size:11pt'>You are receiving this message as ${failure_message}.</p>"
    fn_sendmail "${message_body}" "${email_subject}" "${target_mail}" "${logs_attchment}"

}

function fn_send_mail_job_succeeded(){

    success_message=$1

    fn_assert_variable_is_set "success_message" "${success_message}"

    target_mail=$2

    fn_assert_variable_is_set "target_mail" "${target_mail}"

    logs_attchment=$3

    email_subject="${EXECUTION_SUCCESS_STATUS}"

    fn_assert_variable_is_set "email_subject" "${email_subject}"

    messae_body=$'Dated: `date +%m-%d-%Y`\n\n\n Dear Recipient,\n\nYou are receiving this message as ${success_message}.'

    #email_format_success="Content-Type: text/html\r\nSubject: Status Update: Script Executed Successfully   \r\n\r\n <p style='font-size:12pt'>Dated: `date +%m-%d-%Y`</p><p style='font-size:11pt'>Dear Recipient,</p><p style='font-size:11pt'>You are receiving this message as ${success_message}.</p>"
    fn_sendmail "${messae_body}" "${email_subject}" "${target_mail}" "${logs_attchment}"

}

function fn_log(){

  #Message to be logged should be passed as first argument to
  #this function
  message=$1

  #Print message along with the current timestamp
  echo "[`date`]" ${message}

}

function fn_log_error(){

  #Message to be logged should be passed as first argument to
  #this function
  message=$1

  #Log message with ERROR label
  fn_log "ERROR ${message}"

}

function fn_exit(){

  exit_code=$1

  exit ${exit_code}

}

function fn_exit_with_failure_message(){

  exit_code=$1

  failure_message=$2

  target_mail=$3

  log_file=$4

  fn_log_error "${failure_message}"

  fn_send_mail_job_failed "${failure_message}" "${target_mail}" "${log_file}"

  fn_exit ${exit_code}

}

function fn_check_if_file_exists(){

    file_path="$1"

    fn_assert_variable_is_set "file_path" "${file_path}"

    if [[ -f $file_path ]] ; then
        return 0
    else
        return 1
    fi

}

function fn_exit_with_success_message(){

  exit_code=$1

  success_message=$2

  target_mail=$3

  log_file=$4

  fn_log "${success_message}"

  fn_send_mail_job_succeeded "${success_message}" "${target_mail}" "${log_file}"

  fn_exit ${exit_code}

}

function fn_assert_variable_is_set(){

  variable_name=$1

  variable_value=$2

  if [ "${variable_value}" == "" ]
  then

    exit_code=${EXIT_CODE_VARIABLE_NOT_SET}

    failure_message="${variable_name} variable is not set"

    fn_exit_with_failure_message "${exit_code}" "${failure_message}"

  fi

}
