#!/bin/sh


echo -e "Copying example files into destination CPDIR=$CPDIR\n"

if [ ! -d $CPDIR ]; then
  echo -e "Error: Please mount $CPDIR inorder to copy example files\n"
  exit
fi

cp /example/* $CPDIR

echo -e "Copy completed.. you can start example file by running gen_ca_init.sh"

