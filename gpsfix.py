#!/usr/bin/python3
#
# modified from:
# https://stackoverflow.com/questions/46506705/run-command-on-gps-fix

import sys
import errno
import json

modes = {
  0: 'unknown',
  1: 'nofix',
  2: '2D',
  3: '3D',
}

try:
  while True:
    line = sys.stdin.readline()
    if not line: break # EOF

    sentence = json.loads(line)
    if sentence['class'] == 'TPV':
      mode = modes[sentence['mode']]
      sys.stdout.write(mode + '\n')
      sys.stdout.flush()
      if mode in ['2D', '3D']:
        sys.stdout.write('GOT A %s FIX\n' % mode)
        sys.exit(0)
        
except IOError as e:
  if e.errno == errno.EPIPE:
    pass
  else:
    raise e
