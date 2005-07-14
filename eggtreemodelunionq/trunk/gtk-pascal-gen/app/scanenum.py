#!/usr/bin/env python

cskipenums = [
	"GtkProgressBarStyle", # manual
]

import os
import codecs
import sys
gtkpascalgen_indir = os.environ["gtkpascalgen_indir"]


def enumnameto_(enumname):
	s = ""
	for c in enumname:
		if c == c.upper():
			s = s + "_"
		else:
			s = s + c.upper()
			
	return c
	
def _toenumname(bla_):
	up = True
	s = ""
	for c in bla_:
		if c == "_":
			up = True
		else:
			if up == True:
				s = s + c.upper()
				up = False
			else:
				s = s + c.lower()

	return s
		
def enumname_cutlast(enumname):
	parts = enumnameto_(enumname).split("_")
	parts.pop()
	s = "_".join(parts)
	return _toenumname(s)
		
def c2penumvalue(enumname, value):
	#print "c2penumvalue", enumname, value
	s = ""
	up = True
	ss = ""
	for c in value:
		if c == "_":
			up = True
		else:
			if up == True:
				up = False
				s = s + c.upper()
				if len(ss) < 2:
					ss = ss + c.lower()
			else:
				s = s + c.lower()

	q = enumname
	if q.endswith("Type"): q = q[:-4]
	if q.endswith("Return"): q = q[:-6]
	if q.endswith("Sizing"): q = q[:-6]
	if q.endswith("Mode"): q = q[:-4]
	if q.endswith("DropPosition"): q = q[:-8] # !
	if q.endswith("Policy"): q = q[:-6]
	
	#print "S", s
	#print "Q", q
	
	if s.lower().startswith(q.lower()):
		s = s[len(q):]
	
	q = enumname_cutlast(enumname)
	if s.lower().startswith(q.lower()):
		s = s[len(q):]
	
	if enumname == "GtkTextWindowType":
		ss = "tw"
		#print "Moo"
		
	if enumname == "GdkFillRule":
		ss = "fr"
		
	s = ss + s
	
	s = s.replace("Gtk", "")
	s = s.replace("Gdk", "")
	
	return s

enums = {}
s = ""
basedir = gtkpascalgen_indir + "/h/"

if len(sys.argv) <= 2:
	lst = [ basedir + "gtk-2.0/gdk", basedir + "gtk-2.0/gtk" ]
else:
	lst = [ basedir + sys.argv[2] ]

for q in lst: # for each dir
	qq = os.path.basename(q)
	ns = os.listdir(q)

	for n in ns: # for each file
		if not n.endswith(".h"): continue
		
		nfull = os.path.join(q, n)
		
		try:
			header = codecs.open(nfull, "r", "UTF-8").read()
		except:
			print "scanenum: error: for file", nfull
			raise
		
		i = header.find("typedef enum")
		if i > -1:
			header = header[i:]
			
			i = header.find("{")
			if i == -1:
				print "warning, end of file for enum"
				
			s = s + header[:i+1]
			header = header[i+1:]
			
			i = header.find("}")
			if i == -1:
				print "warning, end of file for enum"
				
			s = s + header[:i+1]
			header = header[i+1:]
			
			i = header.find(";")
			if i == -1:
				print "warning, end of file for enum"
				
			s = s + header[:i]
			
			header = header[i + 1:]
			
			# complete enum is now in s

			enumname = s[s.find("}") + 1:].strip()
			
			s = s[:s.find("}")]
			s = s.replace("\n", " ")
			
			if s.startswith("typedef enum"): s = s[len("typedef enum") + 1:]
			s = s.strip()
			if s.startswith("{"): s = s[1:]
			s = s.strip()
			
			while s.find("/*") > -1:
				i = s.find("/*")
				j = s.find("*/")
				s = s[:i] + s[j + 2:]
			
			values = []
			svalues = s.split(",")
			for svalue in svalues:  # for each value
				v = svalue.strip()
				v = c2penumvalue(enumname, v)
				values.append(v)

			#print "values", values			

			if s.find("=") > -1:
				#print "warning, skipping enum %s, since fixed values were found" % enumname
				s = ""
				continue

			if not (enumname in cskipenums):
				enums[enumname] = values
				
			s = ""

	f = codecs.open(sys.argv[1] + "/" + qq + "/" + qq + "enums.inc", "w")
	for k, v in enums.items():			
		s = "D%s = (%s);" % (k, ", ".join(v))
		
		f.write(s + "\n")
		
	f.close()
	
	enums = {}
