#!/usr/bin/env python

import os, sys
import cPickle as pickle
import yaml

if len(sys.argv) != 3:
    print "yaml-pickle.py [input] [output]"
    sys.exit(1)

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

with open(INPUT, 'r') as inputfile:
    inputyaml = yaml.load(inputfile)

with open(OUTPUT, 'w') as outputfile:
    pickle.dump(inputyaml, outputfile)
