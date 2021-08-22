#!/bin/bash
n=-1
c=0
if [ -n "$3" ]
then
   n=$3
fi

endpoint="syslog-ng"

while [ "$n" -ne $c ]
do

arr[0]="loki.grafana.com"
arr[1]="tempo.grafana.com"
arr[2]="grafana.grafana.com"
arr[3]="prometheus.grafana.com"
arr[4]="cortex.grafana.com"
arr[5]="tanka.grafana.com"
rand=$[$RANDOM % ${#arr[@]}]
random_host=${arr[$rand]}


   WAIT=$(shuf -i "$1"-"$2" -n 1)
   sleep $(echo "scale=4; $WAIT/1000" | bc)
   I=$(shuf -i 1-4 -n 1)
   D=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
   case "$I" in
      "1") echo "$D ${random_host} ERROR An error is usually an exception that has been caught and not handled." | nc -u -w1 ${endpoint} 514
      ;;
      "2") echo "$D ${random_host} INFO An info is often used to provide context in the current task." | nc -u -w1 ${endpoint} 514
      ;;
      "3") echo "$D ${random_host} WARN A warning that should be ignored is usually at this level and should be actionable." | nc -u -w1 ${endpoint} 514
      ;;
      "4") echo "$D ${random_host} DEBUG This is a debug log that shows a log that can be ignored." | nc -u -w1 ${endpoint} 514
      ;;
   esac
   c=$(( c+1 ))
done
