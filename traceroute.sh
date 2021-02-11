#!/bin/bash

# Declare a string array
Targets=()

function NsLookup
{
for addr in $(echo "$(nslookup -type=mx $1 | grep 'mail exchanger =')" | awk '{print $6}')
do
    ip=$(host $addr | grep 'address' | awk '{print $4}')
    arrVar+=($ip)
done
} 

function Robtex
{
curl 'https://www.robtex.com/dns-lookup/'$1 > _robtex

for value in {2,3,4,5,6,7,8,9,10,11,12,13,14,15}
do
#ip=$(echo  $(cat _robtex) |  awk -F'<div><h3>Mail servers</h3></div>' '{print $2}' | awk -F'results shown' '{print $1}' |awk -F'dns-lookup/' '{print $'$value'}' |awk -F'">' '{print $1}')
ip=$(echo  $(cat _robtex) |  awk -F'<div><h3>IP numbers of the mail servers</h3></div>' '{print $2}' | awk -F'results shown' '{print $1}' |awk -F'ip-lookup/' '{print $'$value'}' |awk -F'">' '{print $1}')
arrVar+=($ip)
done
rm _robtex
}

function ReadTraceTargets
{
 input="target.txt"
 while IFS= read -r line
 do
  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  arrVar+=($line)
else
  NsLookup $line
  Robtex $line
fi
done < "$input"
}

function Trace
{
sorted_arrVar=($(echo "${arrVar[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for value in "${sorted_arrVar[@]}"
do
# traceroute -m 3 -p25 $value >> $value.try
#echo '-------------------'
#traceroute -m 15 -I $value >> $value.try
echo $value

done
#tar -cf outtrace.tar *.try
#rm *.try
}


echo "Start Program"
ReadTraceTargets
Trace
