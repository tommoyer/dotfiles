#!/usr/bin/python3

import datetime
import subprocess
import signal
import sys


def sig_handler(sig, frame):
    sys.exit(0)


signal.signal(signal.SIGINT, sig_handler)
previous_date = datetime.date.today()
start_time = datetime.time(9, 0, 0)
time = datetime.time(9, 0, 0)

watson_path = '/home/tmoyer/.local/bin/watson'

while True:
    from_date = datetime.date.fromisoformat(input(f'Enter date, Ctrl+C to finish [{previous_date.strftime("%Y-%m-%d")}]: ') or previous_date.strftime("%Y-%m-%d"))

    minutes = int(input('Enter minutes worked: '))
    project = input('Enter project: ')
    note = input('Enter note: ')

    if previous_date != from_date:
        time = start_time
        previous_date = from_date

    from_time = datetime.datetime.combine(from_date, time)
    delta = datetime.timedelta(minutes=minutes)
    to_time = from_time + delta
    time = to_time.time()

    command = [watson_path,
               'add',
               '--from',
               f'{from_time.strftime("%Y-%m-%d %H:%M")}',
               '--to',
               f'{to_time.strftime("%Y-%m-%d %H:%M")}',
               project,
               '--note',
               note]

    print(command)
    subprocess.run(command)
