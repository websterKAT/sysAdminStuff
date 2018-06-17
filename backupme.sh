#!/bin/bash

#getting source and destination
src_dir=$1
dest_dir=$2

#looping through each file and directory
#renaming and copying

for FILE in ${src_dir}*; do
    cp -r "$src_dir" "$dest_dir/${FILE##*/}_$(date +%-Y%-m%-d).bac";
done
echo "data has been backuped successfully"
