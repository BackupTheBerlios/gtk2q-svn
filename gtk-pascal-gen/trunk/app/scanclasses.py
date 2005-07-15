#!/usr/bin/env python

# TODO two pass, first find the needed types, $INCLUDEs, then write the record

# this is NOT fit for unattended autogeneration yet.
# but better than nothing

import sys
import re
import time
import os
import codecs
from tool2 import parseFN, parseVar, exttype
from readcfg import *
#from tool import exttype

#cat gtktearoffmenuitem.h | awk ' /^struct.*_G.*Class/ { ok=1;} /}/ { ok=0; print $_} { if (ok) print $_ }' |sed 's@};@@'

gtkpascalgen_indir = os.environ["gtkpascalgen_indir"]
gtkpascalgen_outdir = os.environ["gtkpascalgen_outdir"]

if len(sys.argv) > 1:
	topdir = gtkpascalgen_indir + "/h" # "/" + sys.argv[1]
	themod = sys.argv[1]
else:
	topdir = gtkpascalgen_indir + "/h/gtk-2.0"
	themod = "gtk"

subdirs = os.listdir(topdir) #+ ["../overrides/gtk"]

struct1 = re.compile(r"^struct.*_([a-zA-Z]*Class)")
fncommentR = re.compile(r'^(.*)(/\*.*?\*/)(.*)$', re.MULTILINE|re.DOTALL)
#fncommentR = re.compile(r'^(.*)(/\*[^/]*\*/)(.*)$', re.MULTILINE|re.DOTALL)

needtypes = []

def psimplevardecl(vartype, varname):
	global needtypes
	global c2penumcopied
	global wrapperprefix

	#extra = ""	
	a = vartype.split(" ")
	extra = " ".join(a[:-1])
	
	if a[-1].endswith("*"):
		a[-1] = "P" + a[-1][:-1]
		if a[-1].endswith("*"):
			# actually this is an c array most of the time so this here is "wrong"
			a[-1] = "P" + a[-1][:-1]
			
		if a[-1].startswith("P"):
			a[-1] = "PW" + a[-1][1:]

		vartype = a[-1]
	else:
		if vartype.endswith("Class"):
			if vartype not in needtypes:
				needtypes.append(vartype)
				
			vartype = wrapperprefix + vartype
		elif vartype == "GtkCallback":
			vartype = wrapperprefix + vartype
		elif vartype in c2penumcopied:
			vartype = wrapperprefix + vartype
		elif vartype == "int":
			vartype = "gint{actually int}"

	varname = varname.lower().replace("_", "")
	
	if vartype == "GType": vartype = "TGType"
		
	return "%s %s: %s" % (extra, varname, vartype)


for xsubdir in subdirs:
	subdir = os.path.join(topdir, xsubdir)

	if not os.path.isdir(subdir): continue
	if xsubdir == ".svn": continue

	items = [os.path.join(subdir, x) for x in os.listdir(subdir)]
	
	e = gtkpascalgen_outdir + "/overrides/" + xsubdir
	if os.path.exists(e):
		items = items + [os.path.join(e, x) for x in os.listdir(e)]
		#print "added subdir"
		#print "list now", items
		#print "end list"
	
	for filename in items:
		xfilename = os.path.basename(filename)
		if xfilename == ".svn": continue
		
		structname = "unknownerror"
		#filename = os.path.join(subdir, xfilename)
		if not filename.endswith(".h"):
			continue

		lines = codecs.open(filename, "r", "UTF-8").readlines()
		blubb = [""]
		funcs = {}
		
		structlines = []
		needtypes = []

		inc = False

		#if xfilename != "gtksocket.h": continue
				
		for line in lines:
			line = line.replace("colormap/depth", "colormap or depth") # evil hack because i'm too lazy to write a lalr parser
			line = line.replace("colormap/style", "colormap or style") # evil hack because i'm too lazy to write a lalr parser
			line = line.replace("* g_object_new (G_OBJECT_TYPE (style), NULL);", "")
			line = line.replace("text/widgets/pixbuf changed, marks/tags", "text widgets pixbuf changed, marks tags")
			line = line.replace("tooltips/whatsthis", "tooltips or whatsthis")
			
			if not inc:
				m = struct1.match(line)
				if m:
					#print structname
					if(structname != "unknownerror"): # more than one. unsupported.
						print xfilename, "warning: multiple G*Class structures in one .h file are not supported"
						break
					structname = m.group(1)
					inc = True
					
			elif inc:
				if line.startswith("}"):
					inc = False
				else:
					if line.find("{") == -1:
						line = line.replace("\t", " ")

						blubb[-1] = blubb[-1] + line

						if line.strip().endswith(";"):
							blubb.append("")
			
		for item in blubb:
			comments = ""
			while True:
				m = fncommentR.search(item)
				if m == None:
					break
			
				comments = comments + " " + m.group(2)
				item = m.group(1) + " " + m.group(3)

			structlines.append(comments.replace("/*", "(*").replace("*/", "*)"))

			item = item.strip()
			if item == "":
				continue
			
			if item.find("(") > -1:
				dummy, fn = parseFN(item, pointertoo=True)
				if not fn["name"].startswith("_"):
					fn["name"] = fn["name"].replace("_", "").lower() # sigh

				if fn["return"] != "void" and fn["return"] != "":
					p = "function"
				else:
					p = "procedure"
				
				a = []
				for arg in fn["args"]:
					vartype = arg[0]
					varname = arg[1]
					a = a + [psimplevardecl(vartype, varname)]
					
				reto = ""
				
				
				s = "; \n".join(a)
				
				if p == "function":
					fnret = fn["return"]
					if fnret.endswith(" *"):
						fnret = fnret[:-2] + "*" # strip space in the middle
						
					reto = ": " + exttype(fnret, True) #psimplevardecl(fn["return"], "") # exttype(, True) True)
				
				structlines.append(fn["name"] + ": " + p + "(" + s + ")" + reto + "; cdecl;")

				funcs[fn["name"]] = [fn, s, reto]
			else:
				# item contains "[]" is resolved incorrectly, so cheat:
				if item.find("[]") > -1:
					item = item.replace("[]", "[1]")
				
				# now use the normal variable parsing function
				vartype, varname = parseVar(item)

				# resolve "[5]" to unrolling
				ctr = 0			
				if varname.endswith("]"): # array that needs to be unrolled (sigh)
					varname = varname[:-1]
					i = varname.find("[")
					if i > -1:
						ctrs = varname[i + 1:]
						
						if ctrs == "GST_PADDING":
						  ctrs = "4" # Gst hardcoding, see gsttypes.h
						  
						try:
							ctr = int(ctrs)
						except:
							print "info: while processing", filename
							raise
							
						varname = varname[:i]

				if ctr == 0:
					structlines.append(psimplevardecl(vartype, varname) + ";")
				else:
					for i in range(ctr):
						structlines.append(psimplevardecl(vartype, varname + str(i)) + ";")

		pname = xfilename.replace(".h", "").replace("-", "")
		pfilename = "c" + xfilename.replace("-", "").replace(".h", ".inc")
		pclassname = "T" + pname
		
		#funcs[fn["name"]] = [fn, s, reto]
		
		try:
			nf = os.path.join(gtkpascalgen_outdir, "output", os.path.basename(xsubdir), pfilename)
			
			f = codecs.open(nf, "w", "UTF-8")
			
			for needtype in needtypes:
				if needtype == "GObjectClass":
					continue
					
				inclow = needtype.lower().replace("class", "")
				#if inclow.startswith("gdk")
				
				isubdir = xsubdir
				
				if themod == "gnome-canvas":
					if inclow.startswith("gtk"):
						isubdir = "gtk" # FIXME are cross-package includes really ok ?
						
				if themod == "diacanvas":
					if inclow.startswith("gnomecanvas"):
						isubdir = "gnome-canvas"
					
				incf = os.path.join("output", isubdir, "c" + inclow + ".inc")
				f.write("{$INCLUDE %s}\n" % incf)
			
			f.write("type\n")
			f.write("  PW%s = ^W%s;\n" % (structname, structname))
			f.write("  W%s = record\n" % structname)
			f.write("\n".join(["    " + line.lstrip() for line in structlines]))
			f.write("  end;\n")
			f.write("\n\n")
			f.write("(* wrapper functions that call the objects methods. DO NOT ASSIGN EVERY FUNCTION *)\n")
			f.write("(* reason is that most of the functions are probably signal handlers that are not allowed to be assigned *)\n")
			f.write("(* you only may assign 'vtable' members. *)\n")
			for name, v in funcs.items():
				if name.startswith("_"): # _gtk_reserved etc
					continue
					
				fn,params,reto = v
				p = "procedure"
				if reto != "": p = "function"
				s = "%s LL%sT%s(%s)%s; cdecl;" % (p, pname, fn["name"], params, reto)
				f.write(s + "\n")
				f.write("var\n")
				f.write("  me: %s;\n" % pclassname)
				f.write("begin (* TODO *)\n")
				thisi = fn["args"][0][1]
				thisi = thisi.replace("_", "")
				#if thisi == "socket_": thisi = "socket" # ????
				#if thisi == "cell_renderer_text": thisi = "cellrenderertext"
				
				# fixme getWrapper doesnt return a class instance but an interface which is bad here
				f.write("  me := %s(TGObject.GetWrapperDirect(%s));\n" % (pclassname, thisi));
				f.write("end;\n")
				f.write("\n")

			#print nf
			#print xsubdir, pfilename #, "\n".join(structlines)
		except:
			#raise
			pass

	#if xsubdir == "gnome-canvas":
	#	pfilename = "cgnomecanvasitem.inc"
	#	nf = os.path.join("..", "output", os.path.basename(xsubdir), pfilename)
	#	codecs.open(nf, "w", "UTF-8").write("\n\n")

