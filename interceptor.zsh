
###############################################################################
############           The following snippet is for zsh         ###############

declare -A directory_stacks
declare -A access_time

# Push the home as the initial directory
directory_stacks=( ~ 0 )
access_time=( ~ $(date +%s) )

function push_if_success() {
   # The $1 represents the execute status of `cd` or `pushd`

   # We should use absolute path for later use. @example: there is a diretory 
   # called `example` in `/home/nick`, given we are in `/home/nick` and  use `cd`
   # to change into `example`, then the argument passed in is `exmaple`, we cannot 
   # use it, we need get the absulote one, that is where comes in the 'cwd'.
   local cwd=$PWD
   
   if [ $1 = 0 ]; then
      if [ "$directory_stacks[$cwd]" = "" ]; then
         directory_stacks+=( $cwd 0 )
      else
         let $((directory_stacks[$cwd]++))
      fi

      access_time[$cwd]=$(date +%s)
   else
      # Fix error message. @exmaple: cd 0
      # 'cd_interceptor:cd:1: no such file or directory: 0' to 'cd:1: no such file or directory: 0'
      sed 's/^.*_interceptor:\([a-z]\+\):[0-9]\+:\(.*\)$/\1:\2/' <<<$(cat ~/.dirx/stderr) >/dev/stderr
   fi
}

function generate_directories() {
   # Data form: dirname#frequency@accesstime
   # Warning: (@k) is the syntax, not allowed (@key)
   for key in "${(@k)directory_stacks}"; do
      echo "$key#$directory_stacks[$key]@$access_time[$key]";
   done
}

function cd_interceptor() {
  cd $1 2>~/.dirx/stderr
  # If success then added it to directory_stacks, for $1 may
  # be a invalid value.
  push_if_success "$?"
}
alias cd="cd_interceptor"

function dirx {
  # Hide cursor
  printf "\033[?25l"

  {INSTALL_PATH}/index.js $(generate_directories) 2>~/.dirx/stderr
  dir=$(cat ~/.dirx/stderr)
  cd $dir

  # Show cursor
   printf "\033[?25h"
}
alias dirx="dirx"

function pushd_interceptor() {
  pushd $1 2>~/.dirx/stderr 
  # If success then added it to directory_stacks, for $1 may
  # be a invalid value.
  push_if_success "$?"
}
alias pushd="pushd_interceptor"

trap 'printf "\033[?25h"' INT

###############################################################################