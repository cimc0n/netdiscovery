#!/bin/bash
file_ip="target.txt"
file_dic="dic.txt"
thread=100
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
answer=$(snmpwalk -c $1 $2 1.3.6.1.2.1.1.1.0)
if [[ $answer == "" ]]; then
 echo "$2 $1" >> bad_result
else
 echo "$2 $1" >> good_result
fi
}
####################

target=( $(ReadFile $file_ip))
dic=( $(ReadFile $file_dic))


for value in "${dic[@]}"
do
echo $value

for ip in "${target[@]}"
do
  while [`jobs | wc -l` -ge $thread ]
  do
    sleep 5
  echo $(jobs | wc -l)  
  done
    TestSNMP $value $ip &
done

done
