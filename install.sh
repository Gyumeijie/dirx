#! /bin/bash

cat config.json | grep '"installed" *: *"no"' >&/dev/null

if [ $? = 0 ]; then
   # Change install status to "yes"
   sed -i 's/\("installed" *\): *"\([a-z]\+\)"/\1: "yes"/g' config.json

   # Change {INSTALL_PATH}
   sed -i "s:{INSTALL_PATH}:$PWD:" interceptor.sh

   if [ -f ~/.zshrc ]; then
      cat ./interceptor.sh >> ~/.zshrc
   fi

   if [ -f ~/.bashrc ]; then
      cat ./interceptor.sh >> ~/.bashrc
   fi
fi