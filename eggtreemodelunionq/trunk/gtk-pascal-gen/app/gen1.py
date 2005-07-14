#!/usr/bin/env python

# TODO when property *and* function present, choose property

import sys
import codecs
import os
from defs import *
		
from readdef import *
from tool import *
from guid import *

class TemplateProcessor:
	def __init__(self, templatename, ofilename):
		self.template = codecs.open("templates/delphi/" + templatename + ".template", "r", "UTF-8").read()
		self.ofile = codecs.open(ofilename, "w", "UTF-8")

	def run(self):
		template = self.template
		ofile = self.ofile
		insection = None
		seclines = []

		for line in template.split("\n"):
			sline = line.strip()
			#print ">",sline

			if (insection != None and sline == "#/" + insection + "#") \
			or (insection == None and sline.startswith("#") and not sline.startswith("#/")): # section
				sec = sline[1:]
				sec = sec[:sec.find("#")]
				#print "section", sec
				if sec.startswith("/") and sec[1:] == insection:
					#print "SECLINES", seclines
					#print "END"
					processSection(ofile, insection, seclines)
						
					insection = None
					seclines = []
					#print "XX"
				elif not sec.startswith("/"):
					insection = sec
			else:
				#print "$",line
				if insection != None:
					#print "S",line
					seclines.append(line)
				else:
					#print "T",line
					processTemplateLine(ofile, line)

		ofile.close()		

classt = TemplateProcessor("class", ofname)
interfacet = TemplateProcessor("interface", ofiname)
signalt = TemplateProcessor("signal", ofsname)

######################### write output #################

setInterfaceMode(True)
interfacet.run()
setInterfaceMode(False)
classt.run()
setSignalMode(True)
signalt.run()

