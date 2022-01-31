__pathadd.opts.add() {
  local eopt=0
  local opt

  while :; do
    # break on end of params
    [[ -z "${1+x}" ]] && break

    opt="${1}"
    shift

    [[ (${eopt} -eq 1 || ${opt:0:1} != '-') ]] && {
      # borrowed from here:
      # https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
      [[ (-f "${opt}" && "${opt##*.}" == 'pathadd') ]] && {
        OPTS[pathfiles]+="${OPTS[pathfiles]:+$'\n'}${opt}"
      } || {
        OPTS[paths]+="${OPTS[paths]:+$'\n'}${opt}"
      }

      continue
    }

    # parse options
    case "${opt}" in
      --force)
        OPTS[force]=1
        ;;
      -o|--override)
        OPTS[override]=1
        ;;
      --pathfile=*)
        OPTS[pathfiles]+="${OPTS[pathfiles]:+$'\n'}${opt#*=}"
        ;;
      -f|--pathfile)
        OPTS[pathfiles]+="${OPTS[pathfiles]:+$'\n'}${1}"
        shift
        ;;
      --gen-pathfile)
        OPTS[gen_pathfile]=1
        ;;
      --)
        eopt=1
        ;;
      *)
        OPTS[inval]+="${OPTS[inval]:+$'\n'}${opt}"
        ;;
    esac
  done
}

__pathadd.opts.func_help() {
  local funcname="${1}"
  local help_file="${__PATHADD_TOOL_LIBDIR}/assets/help/func.${funcname}.txt"
  shift

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      -h|-\?|--help)  cat "${help_file}"; return 0 ;;
    esac
    shift
  done

  return 1
}

__pathadd.opts.help() {
  while :; do
    # break on end of params
    [[ -z "${1+x}" ]] && break

    # parse options
    case "${1}" in
      -d|--demo)      OPTS[demo]=1 ;;
      --gen-demo=*)   OPTS[gen-demo]="${1#*=}" ;;
      --gen-demo)     shift; OPTS[gen-demo]="${1}" ;;
      *)
        OPTS[inval]+="${OPTS[inval]:+$'\n'}${1}"
        ;;
    esac

    shift
  done
}

__pathadd.opts.fail_invalid() {
  [[ -n "${1}" ]] && {
    echo "Invalid options:"
    while read -r o; do
      printf -- '%-2s%s\n' '' "${o}" >&2
    done <<< "${1}"
    return 1
  }
  return 0
}

__pathadd.opts.parse_pathfiles_to_global() {
  local content="$( while read -r pathfile; do
    [[ -z "${pathfile}" ]] && continue
    [[ ! -f "${pathfile}" ]] && continue

    # exclude empty lines and lines
    # starting with '#'
    grep -v '^#' "${pathfile}" | grep -vFx '' \
    | while read -r path; do
      [[ "${path:0:1}" != ':' ]] && {
        echo "${path}"
        continue
      }

      local pathfile_dir="$(dirname "$(realpath -qms "${pathfile}")")"
      echo "${pathfile_dir}/${path:1}"
    done
  done <<< "${1}" | grep -vFx '' )"

  OPTS[paths]="$(__envar.append_uniq "${OPTS[paths]}" "${content}")"
}
