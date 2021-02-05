#!/bin/bash
file_ip="target.txt"
file_dic="dic.txt"
delay=1
####################
function ReadFile
{ 
local list=()
while IFS= read -r line
do
 list+=($line)
done < $1
echo $(echo ${list[*]}| tr " " "\n" | sort -R)
}
####################
function TestSNMP
{
    echo $2 $1
#answer=$(snmpwalk -c $1 $2 1.3.6.1.2.1.1.1.0)
if [[ $answer == "" ]]; then
 echo "$2 $1" >> bad_result
else
 echo "$2 $1" >> good_result
fi
}
####################

target=( $(ReadFile $file_ip))
dic=( $(ReadFile $file_dic))
