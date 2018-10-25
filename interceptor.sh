
###############################################################################
###### The following snippet will be appended to ~/.zshrc or ~/.bashrc ########

declare -A directory_stacks

# Push the home as the initial directory
directory_stacks=( [~]=0 )

function push_if_success() {
   # The $1 represents the execute status of `cd` or `pushd`
   # And the $2 is the directory being changed into
   if [ $1 = 0 ]; then
      if [ "${directory_stacks[$2]}" = "" ]; then
         directory_stacks+=( [$2]=0 )
      else
         let directory_stacks[$2]++
      fi
  fi
}

function generate_directories() {
   # Data form: dirname#frequency
   for key in "${!directory_stacks[@]}"; do
      echo "$key#${directory_stacks[$key]}";
   done
}

function cd_interceptor() {
  cd $1
  # If success then added it to directory_stacks, for $1 may
  # be a invalid value.
  push_if_success "$?" "$1"
}
alias cd="cd_interceptor"

function dirx {
  node /tmp/test_inquirer/index.js $(generate_directories) 2>~/.dirsrc
  dir=$(cat ~/.dirsrc)
  cd $dir
}
alias dirx="dirx"

function pushd_interceptor() {
  pushd $1
  # If success then added it to directory_stacks, for $1 may
  # be a invalid value.
  push_if_success "$?"
}
alias pushd="pushd_interceptor"
###############################################################################