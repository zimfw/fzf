if (( ${+commands[fd]} )); then
  export FZF_DEFAULT_COMMAND='command fd -H --no-ignore-vcs -E .git -tf'
  export FZF_ALT_C_COMMAND='command fd -H --no-ignore-vcs -E .git -td'
  _fzf_compgen_path() {
    command fd -H --no-ignore-vcs -E .git -tf . ${1}
  }
  _fzf_compgen_dir() {
    command fd -H --no-ignore-vcs -E .git -td . ${1}
  }
elif (( ${+commands[rg]} )); then
  export FZF_DEFAULT_COMMAND="command rg -uu -g '!.git' --files"
  _fzf_compgen_path() {
    command rg -uu -g '!.git' --files ${1}
  }
fi
if (( ${+commands[bat]} )); then
  export FZF_CTRL_T_OPTS="--bind ctrl-/:toggle-preview --preview 'command bat --color=always --line-range :500 {}' ${FZF_CTRL_T_OPTS}"
fi
local ls_cmd
if command ls --version &>/dev/null; then
  # GNU
  ls_cmd='ls --group-directories-first --color=always'
else
  # Stock OpenBSD ls does not support colors at all, but colorls does.
  if [[ ${OSTYPE} == openbsd* ]]; then
    if (( ${+commands[colorls]} )); then
      ls_cmd='colorls --color=always'
    else
      ls_cmd=ls
    fi
  else
    ls_cmd='ls --color=always'
  fi
fi
export FZF_ALT_C_OPTS="--bind ctrl-/:toggle-preview --preview 'command ${ls_cmd} -CF {}' ${FZF_ALT_C_OPTS}"
unset ls_cmd

if (( ${+FZF_DEFAULT_COMMAND} )) export FZF_CTRL_T_COMMAND=${FZF_DEFAULT_COMMAND}
