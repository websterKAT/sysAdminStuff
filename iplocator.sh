#!/bin/bash

for i in `awk '{ print $1 }' access.log | sort | uniq` ; do
    echo "$i:`whois $i | grep -m 1 -E 'country|Country' | sed -r 's/.*(.{3})/\1/'`"
done
