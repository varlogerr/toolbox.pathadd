__pathadd.gen_pathfile() {
  [[ ${1} -ne 1 ]] && return 1

  local assetsdir="$(
    dirname "${BASH_SOURCE[0]}"
  )/../assets"

  grep -vFx '' "${assetsdir}/pathfile.pathadd" \
  | sed 's/^/# /g'
  return 0
}

__pathadd.colon_to_nl() {
  tr ':' '\n' <<< "${1}"
}

__pathadd.add.mkpath() {
  local prepend="${1:0}"
  local NL_PATH="${PATH:+$(__pathadd.colon_to_nl "${PATH}")}"

  # normalize and make unique paths
  OPTS[paths]="$( while read -r p; do
    [[ -z "${p}" ]] && continue

    [[ "${p:0:1}" == '/' ]] && \
      realpath -qms -- "${p}" && continue

    sed -E 's/[\/]+$//g' <<< "${p}"
  done <<< "${OPTS[paths]}" \
  | cat -n | sort -k2 -k1n | uniq -f1 \
  | sort -nk1,1 | cut -f2- )"

  [[ ${OPTS[override]} -eq 1 ]] && \
    NL_PATH="$(grep -vFx "${OPTS[paths]}" <<< "${NL_PATH}")"

  [[ ${OPTS[force]} -eq 0 ]] && \
    OPTS[paths]="$(grep -vFx "${NL_PATH}" <<< "${OPTS[paths]}")"

  local ret="${NL_PATH}"
  if [[ -n "${OPTS[paths]}" ]]; then
    [[ ${prepend} -eq 0 ]] && {
      ret+="${ret:+$'\n'}${OPTS[paths]}"
    } || {
      ret="$(tac <<< "${OPTS[paths]}")${ret:+$'\n'${ret}}"
    }
  fi

  printf -- '%s' "${ret}" | tr '\n' ':'
}
