#! /bin/bash

bin_path=$(which dirx-cli)
if [ $? = 0 ]; then
   # Install through The npm way, in the MacOS, the readlink does't work
   # like in linux, so we add realpath.js to get the realpath to fix it
   script_path=$(dirname $(realpath $bin_path))
else 
   # Install through The git clone way
   script_path=$PWD
fi

pushd $script_path >&/dev/null

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
      # Use tempfile to fix macos `sed command c expects \ followed by text` 

      # Test whether or not need `sudo` to run the following commands
      touch tempfile.$$ 2>/dev/null
      if [ $? = 1 ]; then
         echo "Permission denied"
         exit 1
      fi
      sed 's/\("installed" *\): *"no"/\1: "yes"/g' config.json > tempfile.$$
      cat tempfile.$$ > config.json
    
      # Change {INSTALL_PATH}
      if [ -f ~/.zshrc ]; then
         sed "s:{INSTALL_PATH}:$PWD:" interceptor.zsh > tempfile.$$
         cat tempfile.$$ >> ~/.zshrc
      fi

      if [ -f ~/.bashrc ]; then
         sed "s:{INSTALL_PATH}:$PWD:" interceptor.bash > tempfile.$$
         cat tempfile.$$ >> ~/.bashrc
      fi
   fi
elif [[ "$1" = "set-strategy" && ("$2" = "frequency" || $2 = "accessTime" ) ]]; then
   # Change strategy
   sed "s/\(\"defalutStrategy\" *\): *\"\([[:alpha:]]\+\)\"/\1: \"$2\"/g" config.json > tempfile.$$
   cat tempfile.$$ > config.json
else
   printUsage
fi 

rm -rf tempfile.$$
popd >&/dev/null