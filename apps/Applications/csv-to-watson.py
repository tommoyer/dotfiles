#!/usr/bin/python3

import csv

with open('timecards.csv', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        print(f'watson add --from "{row["date"]} {row["start time"]}" --to "{row["date"]} {row["end time"]}" {row["project"]} --note "{row["note"]}"')
