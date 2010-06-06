#!/bin/bash

# TEST
# sh find_substring_position.sh "find substring position" "g p"  => 13
# sh find_substring_position.sh foodforthought.jpg fo            => 0

function find_substring_position()
{
    longstr=$1
    substr=$2
    truncated_str=${longstr%%$substr*}
    echo "子串位置是：" ${#truncated_str}
}

if [ $# != 2 ]; then
    echo "Usage: $0 LONGSTR SUBSTR"
    exit 1
fi

find_substring_position "$1" "$2"