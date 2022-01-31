##########
# This env vars are set from main.sh
# * __PATHADD_TOOL_ROOTDIR - envar tool root directory
# * __PATHADD_TOOL_LIBDIR - envar lib directory
##########

pathadd.append() {
  __pathadd.opts.func_help "${FUNCNAME[0]}" "${@}" && return

  declare -A OPTS=(
    [force]=0
    [override]=0
    [paths]=''
    [pathfiles]=''
    [gen_pathfile]=0
    [inval]=''
  )
  __pathadd.opts.add "${@}"
  __pathadd.gen_pathfile "${OPTS[gen_pathfile]}" && return 0
  __pathadd.opts.fail_invalid "${OPTS[inval]}" || return 1
  __pathadd.opts.parse_pathfiles_to_global "${OPTS[pathfiles]}"

  [[ -z "${OPTS[paths]}" ]] && return

  PATH="$(__pathadd.add.mkpath 0)"
  [[ -z "$(bash -c 'echo ${PATH+x}')" ]] \
    && export PATH
}

pathadd.prepend() {
  __pathadd.opts.func_help "${FUNCNAME[0]}" "${@}" && return

  declare -A OPTS=(
    [force]=0
    [override]=0
    [paths]=''
    [pathfiles]=''
    [gen_pathfile]=0
    [inval]=''
  )
  __pathadd.opts.add "${@}"
  __pathadd.gen_pathfile "${OPTS[gen_pathfile]}" && return 0
  __pathadd.opts.fail_invalid "${OPTS[inval]}" || return 1
  __pathadd.opts.parse_pathfiles_to_global "${OPTS[pathfiles]}"

  [[ -z "${OPTS[paths]}" ]] && return

  PATH="$(__pathadd.add.mkpath 1)"
  [[ -z "$(bash -c 'echo ${PATH+x}')" ]] \
    && export PATH
}

pathadd.ls() {
  __pathadd.opts.func_help "${FUNCNAME[0]}" "${@}" && return

  __pathadd.colon_to_nl "${PATH}"
}

pathadd.help() {
  local help_dir="${__PATHADD_TOOL_LIBDIR}/assets/help"

  declare -A OPTS=(
    [demo]=0
    [gen-demo]=''
    [inval]=''
  )
  __pathadd.opts.help "${@}"
  __pathadd.opts.fail_invalid "${OPTS[inval]}" || return 1

  [[ ${OPTS[demo]} -eq 1 ]] && {
    . "${help_dir}/demo.sh"
    return
  }

  [[ (-n ${OPTS[gen-demo]} && -d ${OPTS[gen-demo]}) ]] && {
    cp -r "${help_dir}/demo.env"/* ${OPTS[gen-demo]}
    return
  }

  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
  For each function \`<func> --help\` prints
  detailed help.
  Issue \`pathadd.help --demo\` to see usage demos.
  Issue \`pathadd.help --gen-demo .\` to generate
  demo playground to the current directory
  "

  echo
  echo "Available functions:"
  for f in $(ls "${help_dir}"/func.pathadd.*.txt); do
    basename ${f} | cut -d'.' -f2- | cut -d'.' -f-2
    sed -e '/^$/,$d' "${f}" | sed 's/^/  /g'
  done | sed 's/^/  /g'
}
