plugin_dir=${0:A:h}
gh_user_script="$plugin_dir/gh-user-cached.sh"

typeset -g _GH_USER_CACHE=""

function _gh_user_fetch() {
  _GH_USER_CACHE="$($gh_user_script 2>/dev/null)"
}

function gh_user_prompt() {
  local user="$_GH_USER_CACHE"
  if [[ -z "$user" ]]; then
    _gh_user_fetch
    user="$_GH_USER_CACHE"
  fi

  if [[ "$user" == "Sign in" ]]; then
    echo "%F{242} Sign in%f"
  else
    echo "%F{cyan} $user%f"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _gh_user_fetch

function _gh_user_set_rprompt() {
  [[ -n "$GH_USER_PROMPT_DISABLED" ]] && return
  local snippet='$(gh_user_prompt)'
  if [[ "$RPROMPT" == *"$snippet"* ]]; then
    return
  fi
  if [[ -n "$RPROMPT" ]]; then
    RPROMPT="${RPROMPT} ${snippet}"
  else
    RPROMPT="${snippet}"
  fi
}
add-zsh-hook precmd _gh_user_set_rprompt

