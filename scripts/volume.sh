#!/bin/bash

if [ -z "$1" ]
  then col="red"
 else
    col=$1
fi

vol=$(amixer get Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "<fc='"$col"'>MM</fc>" } else { print $2 "%" }}'  | head -n 1)

echo Vol: $vol

exit 0
