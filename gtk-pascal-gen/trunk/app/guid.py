#!/usr/bin/env python

import codecs
import sys

ids = {}
freeids = []

def readIDS():
	global ids
	global freeids
	ids1 = codecs.open("ids.txt", "r", "UTF-8").readlines()

	for idsi in ids1:
		idsi = idsi.strip()
		a = idsi.split(":", 1)
		
		if len(a) > 1:
			ids[a[0]] = a[1]
		else:
			freeids.append(a[0])
			
readIDS()

def writeIDS():
	global ids
	global freeids
	f = codecs.open("ids.txt", "w", "UTF-8")
	for k, v in ids.items():
		a = [k, v]
		s = ":".join(a)
		f.write(s + "\n")

	for freeid in freeids:
		f.write(freeid + "\n")
		
	f.close()
		
def allocGUID(classname):
	global ids
	global freeids
	if classname in ids:
		return ids[classname]
		
	if len(freeids) == 0:
		print "no GUIDs left"
		sys.exit(1)

	id = freeids[0]
	freeids = freeids[1:]
	
	ids[classname] = id
	writeIDS()

	return id
		
