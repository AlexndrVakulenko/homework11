#!/bin/bash

LinesCount=$(wc ./nginx_log.log | awk '{print $1}')

Log_begin=$(awk '{print $4}' nginx_log.log | sed 's/\[//' | sed -n 1p)
Log_end=$(awk '{print $4}' nginx_log.log | sed 's/\[//' | sed -n "$LinesCount"p)
Period="$Log_begin-$Log_end"

echo -e NGINX Log за период  $Period > result.txt

# Более 5-ти запросов IP
IP=$(awk '{print $1}' nginx_log.log| sort | uniq -c | sort -rn | awk '{ if ( $1 >= 5 ) { print "      " $2, "\t запросов :" $1 } }')
echo -e "\n$IP" >> result.txt

# Более 5-ти запросов URL
addresses=$(awk '($9 ~ /200/)' nginx_log.log|awk '{print $7}'|sort|uniq -c|sort -rn|awk '{ if ( $1 >= 5 ) { print "\t" $1 "\t запросов: " , "URL:" $2 } }')
echo -e "\n Наиболее часто запрашиваемые адреса: \n$addresses"  >> result.txt

# Частые ошибки
errors=$(cat nginx_log.log | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -rn)
echo -e "\n Частые ошибки:\n$errors"  >> result.txt
cat ./result.txt | mail -s "NGINX Log за период  $Period" root@localhost