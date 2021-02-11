#!/bin/bash

# Declare a string array
Targets=()

function NsLookup
{
for addr in $(echo "$(nslookup -type=mx $1 | grep 'mail exchanger =')" | awk '{print $6}')
do
    arrVar+=($addr)
done
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
fi
done < "$input"
}

function Trace
{
for value in "${arrVar[@]}"
do
traceroute -m 3 -p25 $value >> $value.try
echo '-------------------' >> $value.try
traceroute -m 15 -I $value >> $value.try
echo $value
done
tar -cf outtrace.tar *.try
rm *.try
}

echo "Start Program"
ReadTraceTargets
Trace
