#!/usr/bin/python

import sys

filename=sys.argv[0]
args = sys.argv[1:]

if len(args) == 0:
  args = ['hello,', 'world!']
elif len(args) == 1:
  args.append('world!')

print(args[0], args[1])
