#!/bin/bash

kasa_cmd=/home/tmoyer/.local/bin/kasa
fan_hostname=desk-fan.internal.moyer.wtf

fan_state=$(${kasa_cmd} --host ${fan_hostname} --type plug --json state | jq '.system.get_sysinfo.relay_state')

if [[ "${fan_state}" == "1" ]]
then
    # echo "Fan is on"
    ${kasa_cmd} --host ${fan_hostname} --type plug off &> /dev/null
else
    # echo "Fan is off"
    ${kasa_cmd} --host ${fan_hostname} --type plug on &> /dev/null
fi
