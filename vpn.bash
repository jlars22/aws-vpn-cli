_vpn() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local commands="import list ls status all disconnect down logs setup-sudo"

  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/aws-vpn-cli"
  local profiles_file="$config_dir/profiles.json"
  local profiles=""
  if [[ -f "$profiles_file" ]]; then
    profiles=$(python3 -c "
import json, sys
with open(sys.argv[1]) as f:
    profiles = json.load(f)
print(' '.join(profiles))
" "$profiles_file" 2>/dev/null)
  fi

  case "$prev" in
    disconnect|down)
      mapfile -t COMPREPLY < <(compgen -W "all $profiles" -- "$cur")
      ;;
    logs)
      mapfile -t COMPREPLY < <(compgen -W "$profiles" -- "$cur")
      ;;
    *)
      mapfile -t COMPREPLY < <(compgen -W "$commands $profiles" -- "$cur")
      ;;
  esac
}

complete -F _vpn vpn
