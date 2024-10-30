() {
  local -r target=${1}
  shift
  (( ${+commands[${1}]} )) || return 1
  if [[ ! ( -s ${target} && ${target} -nt ${commands[${1}]} ) ]]; then
    "${@}" >! ${target} || return 1
    zcompile -UR ${target}
  fi
  source ${target}
} ${0:h}/fzf---zsh.zsh fzf --zsh || return 1

if (( ${+commands[bfs]} )); then
  export FZF_DEFAULT_COMMAND="command bfs -mindepth 1 -exclude -name .git -type d,f -printf '%P\n' 2>/dev/null"
  export FZF_ALT_C_COMMAND="command bfs -mindepth 1 -exclude -name .git -type d -printf '%P\n' 2>/dev/null"
  _fzf_compgen_path() {
    command bfs ${1} -exclude -name .git -type d,f -a -not -path ${1} -print
  }
  _fzf_compgen_dir() {
    command bfs ${1} -exclude -name .git -type d -a -not -path ${1} -print
  }
elif (( ${+commands[fd]} )); then
  export FZF_DEFAULT_COMMAND='command fd -H --no-ignore-vcs -E .git -td -tf'
  export FZF_ALT_C_COMMAND='command fd -H --no-ignore-vcs -E .git -td'
  _fzf_compgen_path() {
    command fd -H --no-ignore-vcs -E .git -td -tf . ${1}
  }
  _fzf_compgen_dir() {
    command fd -H --no-ignore-vcs -E .git -td . ${1}
  }
elif (( ${+commands[rg]} )); then
  export FZF_DEFAULT_COMMAND="command rg -uu -g '!.git' --files --no-messages"
  _fzf_compgen_path() {
    command rg -uu -g '!.git' --files ${1}
  }
elif (( ${+commands[ug]} )); then
  export FZF_DEFAULT_COMMAND="command ug -lrs. --exclude-dir=.git --no-tree ''"
  _fzf_compgen_path() {
    command ug -lrs. --exclude-dir=.git --no-tree '' ${1}
  }
fi

local bat_cmd
if (( ${+commands[bat]} )); then
  bat_cmd=bat
elif (( ${+commands[batcat]} )); then
  # APT package
  bat_cmd=batcat
fi
if [[ -n ${bat_cmd} ]]; then
  export FZF_CTRL_T_OPTS="--bind ctrl-/:toggle-preview --preview 'command ${bat_cmd} --color=always --line-range :500 {}' ${FZF_CTRL_T_OPTS}"
fi
unset bat_cmd

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
