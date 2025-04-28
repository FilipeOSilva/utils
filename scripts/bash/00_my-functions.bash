#!/usr/bin/env bash

## -x-x-x-x-x- ##
##  FUNCTIONS  ##
## -x-x-x-x-x- ##

print() {
  if [[ ${BUILD_LOG} == true ]] ; then
    echo -e "$1 "
  fi
}

step_start() {
  if [[ ${BUILD_LOG} == true ]] ; then
    echo -n "$1 "
  fi
}

step_ok() {
  if [[ ${BUILD_LOG} == true ]] ; then
    echo -e "[ \033[0;36m OK \033[0m ]"
  fi
}

abort() {
  echo -e "[ \033[0;31mstop\033[0m ] $1"
  exit 1;
}

