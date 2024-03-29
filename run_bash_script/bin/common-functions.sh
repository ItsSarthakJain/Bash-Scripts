#!/bin/sh

function fn_run_modular_bash_script(){

    SCRIPT_NAME=$1

    fn_assert_variable_is_set "SCRIPT_NAME" "${SCRIPT_NAME}"

    SCRIPT_PATH=$2

    fn_assert_variable_is_set "SCRIPT_PATH" "${SCRIPT_PATH}"

    SCRIPT_TYPE=$3

    fn_assert_variable_is_set "SCRIPT_TYPE" "${SCRIPT_TYPE}"

    TARGET_MAIL=$4

    fn_assert_variable_is_set "TARGET_MAIL" "${TARGET_MAIL}"

    declare -a MODULE_LIST

    declare -a ARRAY

    ARRAY=()

    if [[ "${SCRIPT_TYPE}" = "${INCREMENT_TYPE}" ]];then

        MODULE_LIST=(setup ingest export cleanup)

    elif [[ "${SCRIPT_TYPE}" = "${FULL_LOAD_TYPE}" ]];then

        MODULE_LIST=(ingest export)

    fi

    TIMESTAMP=`date "+%Y-%m-%d|%H:%M:%S" `

    DATE=`date "+%Y-%m-%d" `

    flag=0

    mkdir -p ${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}-${DATE}

    LOG_FILE=${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}-${DATE}/${SCRIPT_NAME}-${TIMESTAMP}.log

     if fn_check_if_file_exists "${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}.attempt"

       then

            MODULE_FAILED_AT=$(cat "${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}.attempt")

            for MODULE in "${MODULE_LIST[@]}"; do

               if [[ "${MODULE}" = "${MODULE_FAILED_AT}" ]]; then

                    flag=1

               fi

		       if [ ${flag} -eq "1" ];then

			     ARRAY+=(${MODULE})

		       fi

            done

       MODULE_LIST=("${ARRAY[@]}")

       rm ${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}.attempt

     fi

    for MODULE in "${MODULE_LIST[@]}"

        do
           MODULE_TO_EXECUTE=${SCRIPT_NAME}-${MODULE}/bin/${SCRIPT_NAME}-${MODULE}.sh

           printf "${n2}`date "+[%Y-%m-%d %H:%M:%S]" `Executing ${SCRIPT_NAME}-${MODULE}.sh ${n2}">>${LOG_FILE}

           time sh ${SCRIPT_PATH}${MODULE_TO_EXECUTE} 2>&1 |& tee -a ${LOG_FILE}

           exit_code=${PIPESTATUS[0]}

           if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

                echo ${MODULE}>>${SCRIPT_PATH}/logs_for_bash_script_runner/${SCRIPT_NAME}.attempt

                fn_exit_with_failure_message "1" "${SCRIPT_NAME} Failed to Execute.${n1}" "${TARGET_MAIL}" "${LOG_FILE}" "${SCRIPT_NAME}" "${SCRIPT_NAME}-${MODULE}.sh"

           fi

           printf "${n2}`date "+[%Y-%m-%d %H:%M:%S]" `Executed ${SCRIPT_NAME}-${MODULE}.sh Successfully ${n2}">>${LOG_FILE}

        done

    fn_exit_with_success_message "0" "${SCRIPT_NAME} Executed Successfully.${n2}" "${TARGET_MAIL}" "${LOG_FILE}" "${SCRIPT_NAME}"

}

function fn_exit_with_success_message(){

  exit_code=$1

  success_message=$2

  target_mail=$3

  log_file=$4

  script_name=$5

  fn_log "${success_message}"

  cnt="$(grep -m2 "Map input records" "${log_file}" | head -n1)"

  count=$(echo "${cnt}" | tr -dc '0-9')

  fn_send_mail_job_succeeded "${success_message}" "${target_mail}" "${log_file}" "${script_name}" "${count}"

  fn_exit ${exit_code}

}

function fn_exit_with_failure_message(){

  exit_code=$1

  failure_message=$2

  target_mail=$3

  log_file=$4

  script_name=$5

  module_name=$6

  fn_log_error "${failure_message}"

  fn_send_mail_job_failed "${failure_message}" "${target_mail}" "${log_file}" "${script_name}" "${module_name}"

  fn_exit ${exit_code}

}

function fn_send_mail_job_succeeded(){

    success_message=$1

    fn_assert_variable_is_set "success_message" "${success_message}"

    target_mail=$2

    fn_assert_variable_is_set "target_mail" "${target_mail}"

    logs_attchment=$3

    script_name=$4

    fn_assert_variable_is_set "script_name" "${script_name}"

    count=$5

    fn_assert_variable_is_set "count" "${count}"

    message_body="Dear Recipient,${n2}You are receiving this message as ${success_message}Script Name: ${script_name} ${n1}User: aa00ha ${n1}Server: phvgrm6${n1}Execution Time: `date "+%Y-%m-%d %H:%M:%S" `${n1}Records ingested from teradata:"${count}"${n1}Records ingested to Enriched Table: "${count}""

    fn_sendmail "${message_body}" "Status Update- Script "${script_name}" Executed Successfully" "${target_mail}" "${logs_attchment}"

}

function fn_send_mail_job_failed(){

    failure_message=$1

    fn_assert_variable_is_set "failure_message" "${failure_message}"

    target_mail=$2

    fn_assert_variable_is_set "target_mail" "${target_mail}"

    logs_attchment=$3

    script_name=$4

    module_name=$5

    fn_assert_variable_is_set "script_name" "${script_name}"

    message_body="Dear Recipient,${n2}You are receiving this message as ${failure_message}At ${module_name} ${n2}Script Name: ${script_name} ${n1}Module Failed to Execute: ${module_name} ${n1}User: aa00ha ${n1}Server: phvgrm6${n1}Execution Time:`date "+%Y-%m-%d %H:%M:%S" `"

    fn_sendmail "${message_body}" "Status Update- Script "${script_name}" Failed to Execute" "${target_mail}" "${logs_attchment}"

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



function fn_check_if_file_exists(){

    file_path="$1"

    fn_assert_variable_is_set "file_path" "${file_path}"

    if [[ -f $file_path ]] ; then
        return 0
    else
        return 1
    fi

}



function fn_assert_variable_is_set(){

  variable_name=$1

  variable_value=$2

  if [ "${variable_value}" == "" ]
  then

    exit_code=${EXIT_CODE_VARIABLE_NOT_SET}

    failure_message="${variable_name} variable is not set"

    fn_log "${failure_message}"

    fn_exit "${exit_code}"

  fi

}