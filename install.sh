#! /bin/bash

function printUsage() {
   echo 'Usage:' 
   echo '      dirx-cli install'
   echo '      dirx-cli set-strategy strategy("frequency" or "accessTime")'
}

if [ $# -eq 0 ]; then
   printUsage
elif [ "$1" = "install" ]; then
   cat config.json | grep '"installed" *: *"no"' >&/dev/null

   if [ $? = 0 ]; then
      # Change install status to "yes"
      sed -i 's/\("installed" *\): *"\([a-z]\+\)"/\1: "yes"/g' config.json

      # Change {INSTALL_PATH}
      sed -i "s:{INSTALL_PATH}:$PWD:" interceptor.bash
      sed -i "s:{INSTALL_PATH}:$PWD:" interceptor.zsh

      if [ -f ~/.zshrc ]; then
         cat ./interceptor.zsh >> ~/.zshrc
      fi

      if [ -f ~/.bashrc ]; then
         cat ./interceptor.bash >> ~/.bashrc
      fi
   fi
elif [[ "$1" = "set-strategy" && ("$2" = "frequency" || $2 = "accessTime" ) ]]; then
   # Change strategy
   sed -i "s/\(\"defalutStrategy\" *\): *\"\([[:alpha:]]\+\)\"/\1: \"$2\"/g" config.json
else
   printUsage
fi 