#!/usr/bin/env python3

import io
import sys

input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
bad_cities = 'Åmål Mariestad Skövde Strömstad'.split()

ignore = False
for line in input_stream:
    line = line.strip()
    if line in bad_cities:
        ignore = True
        continue
    if line.startswith('2022') and ignore:
        continue
    ignore = False
    print(line)
