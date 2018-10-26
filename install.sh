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
   if [ -f ~/.dirx/config.json ]; then
      echo "Installed already." && exit 1
   fi

   if [ $? = 0 ]; then 
      # Save all related files in ~/.dirx
      mkdir ~/.dirx 2>/dev/null

      sed 's/\("installed" *\): *"no"/\1: "yes"/g' config.json > ~/.dirx/config.json
    
      # Change {INSTALL_PATH}
      if [ -f ~/.zshrc ]; then
         sed "s:{INSTALL_PATH}:$PWD:" interceptor.zsh > ~/.dirx/interceptor.zsh
         echo 'source ~/.dirx/interceptor.zsh' >> ~/.zshrc
      fi

      if [ -f ~/.bashrc ]; then
         sed "s:{INSTALL_PATH}:$PWD:" interceptor.bash > ~/.dirx/interceptor.bash 
         echo 'source ~/.dirx/interceptor.bash' >> ~/.bashrc
      fi
   fi
elif [[ "$1" = "set-strategy" && ("$2" = "frequency" || $2 = "accessTime" ) ]]; then
   # Change strategy
   if [ -f ~/.dirx/config.json ]; then
      # Fix `sed command c expects \ followed by text` in MacOS
      ret=$(sed "s/\(\"defalutStrategy\" *\): *\"\([[:alpha:]]\+\)\"/\1: \"$2\"/g" ~/.dirx/config.json)
      echo -n "$ret" > ~/.dirx/config.json
   else
      echo "Not installed dirx yet."
   fi
else
   printUsage
fi 

popd >&/dev/null