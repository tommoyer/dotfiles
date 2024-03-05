#!/bin/bash

kasa_cmd=/home/tmoyer/.local/bin/kasa
light_hostname=desk-lamp.moyer.wtf

light_state=$(${kasa_cmd} --host ${light_hostname} --type plug --json state | jq '.system.get_sysinfo.relay_state')

if [[ "${light_state}" == "1" ]]
then
    # echo "light is on"
    ${kasa_cmd} --host ${light_hostname} --type plug off &> /dev/null
else
    # echo "light is off"
    ${kasa_cmd} --host ${light_hostname} --type plug on &> /dev/null
fi
