#!/bin/bash

tasks=1000
cpus=2
tempfifo="/tmp/$$.fifo"
mkfifo ${tempfifo}
exec 6<>${tempfifo}

function cmd()
{
  sleep 50
}

if [ ${tasks} -lt ${cpus} ]; then
  for ((i=0;i<${cpus};i++));
  do
    {
        cmd
    }&
  done
elif [ ${tasks} -ge ${cpus} ]; then
  for ((i=0;i<${cpus};i++));
  do
    echo
  done >&6 

  for ((i=0;i<${tasks};i++));
  do
    read -u 6 
    {   
      cmd
    } &
  echo >&6
  done 
  wait
  exec 6>&-
else
  exit 1;
fi