slimline::section::execution_time::preexec() {
  slimline_section_execution_time_cmd_timestamp=$EPOCHSECONDS
}

slimline::section::execution_time::precmd() {
  local integer elapsed
  (( elapsed = EPOCHSECONDS - ${slimline_section_execution_time_cmd_timestamp:-$EPOCHSECONDS} ))
  slimline_section_execution_time_output=
  if (( elapsed > ${SLIMLINE_MAX_EXEC_TIME:-5} )); then
    slimline_section_execution_time_output="$(slimline::utils::pretty_time $elapsed)"
  fi

  unset slimline_section_execution_time_cmd_timestamp
}

slimline::section::execution_time() {
  # add elapsed time if threshold is exceeded
  if [[ -z "${slimline_section_execution_time_output}" ]]; then return; fi
  local exec_time="${slimline_section_execution_time_output}"
  local format="%F{yellow}|exec_time|%f"
  echo "${${SLIMLINE_EXECUTION_TIME_FORMAT:-${format}}/|exec_time|/${exec_time}}"
}
