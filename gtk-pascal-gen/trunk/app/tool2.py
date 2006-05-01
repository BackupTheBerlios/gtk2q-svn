#!/usr/bin/env python

from readcfg import *
import re
import sys
import exceptions

classname = ""
#ascendentants = []
signals = {}
props = {}
pextrauses = []
xxversion = ""

try:
	classname = sys.argv[2] # moved to tool2 for some reason
except:
	classname = "<unknown>"
	
cimplementsinterfaces = {}

def addExtraUses(unitname):
	global pextrauses
	pextrauses.append(unitname)
	
def getExtraUses():
	global pextrauses
	return pextrauses
	
def getProps():
	global props
	return props
	
def setProps(aprops):
	global props
	props = aprops
	
def setFns(afns):
	global fns
	fns = afns
	
def getFns():
	return fns
	
def setCImplementsInterfaces(c):
	global cimplementsinterfaces
	cimplementsinterfaces = c

def getCImplementsInterfaces():
	global cimplementsinterfaces
	return cimplementsinterfaces

def getSignals():
	global signals
	return signals
	
def setSignals(s):
	global signals
	signals = s

ofimode = False
ofsmode = False


def cproptocfn(cpropname):
	return cpropname.replace("-", "_")

def isDebug():
	return False

def setInterfaceMode(enable):
	global ofimode
	ofimode = enable
	
def setSignalMode(enable):
	global ofsmode
	ofsmode = enable
	
def isInSignalMode():
	global ofsmode
	return ofsmode

def isInInterfaceMode():
	global ofimode
	return ofimode

endofstruct = re.compile(r"[a-zA-Z][a-zA-Z]*;") # "PangoLayoutIter;"

def fnsFromFNLines(fnlines):
	fns = {}
	rest = ""
	for fnline in fnlines:
		rest = rest + fnline.replace("\n", "")
		if fnline.find(";") > -1:
			#fns.append(rest)
			if rest.find("(*Gtk") > -1: # probably a function pointer type (I hope only them)
				rest = ""
				continue
			if rest.find("(*Gdk") > -1: # probably a function pointer type (I hope only them)
				rest = ""
				continue
				
			if endofstruct.match(rest.strip()) != None:
				rest = ""
				continue
				
			name, attr = parseFN(rest)
			if name == None and attr == None:
				#print "NO", rest
				rest = ""
				continue
				
			if name == "GdkFilterReturn": # FIXME fix the underlying bug
				rest = ""
				continue
				
			fns[name] = attr
			rest = ""

	return fns

class ClassDefinition:
	def __init__(self):
		self.fns = {}
		self.cimplementsinterfaces = {}
		self.props = {}
		self.ascendentants = []
		self.signals = {}
		self.classname = ""
		
	fns = {}
	cimplementsinterfaces = {}
	props = {}
	ascendentants = []
	signals = {}
	classname = ""

tags = re.compile(r"^(.*)(<[^>]*>)(.*)$")
indexterm1 = re.compile(r"^(.*)<primary>([^<]*)</primary>(.*)$")

def stripTags(line):
	match = re.search(r"^(.*)\)[ ]*:[^<]*</programlisting>.*$", line)
	if match != None:
		line = match.group(1) + ");"
	
	line = line.replace(")</programlisting>", ");") # gtk 2.8 forgot the ";" :)
	while True:
		match = indexterm1.match(line)
		if match == None: break
		
		line = match.group(1) + match.group(3)
		
	while True:
		match = tags.match(line)
		if match == None: break

		line = match.group(1) + match.group(3)

	return line

def overrideProptype(classdef, pname, datatype):
	k = ("%s.%s" % (classdef.classname, pname)) 
	#print "K", k
	if k in c2pproptypeoverride:
		e = c2pproptypeoverride[k]
		#print "TODO override", classdef.classname, pname, e
						
		if e[0] == "ctype":
			eparts = e[1].split(" ")
			if eparts[0] == "unboxed" or eparts[0] == "boxed":
				# TODO
				eparts = eparts[1:]
				
			datatype = eparts[0] + "*"

	if (datatype in cclasses): # datatype is a class instance pointer
		datatype = datatype + "*"
	
	if classdef.classname.startswith("Dia"):	
		if datatype == "gulong" and (pname.endswith("-color") or \
		pname == "color" or pname == "grid-bg"):
			datatype = "GdkRgbColor"
	
	return datatype
	
def parseFile(file, classdef):
	#global props
	#global ascendentants
	#global ascendentantsDone
	#global signals
	global cclasses
	global classname
	global c2pproptypeoverride
	global superclassoverride

	fnlines = []
	inprop = False
	inpropdetails = False
	insynopsis = False
	inoh = False
	insignal = False
	insignalstart = False
	insignalname = None
	inintf = False
	isinterfaceclass = False
	
	ascendentantsDone = False

	uscclassname = uscclassnameOfClassname(classname)

	if classname in superclassoverride:
		sc = superclassoverride[classname]
		if len(classdef.ascendentants) == 0:
			classdef.ascendentants.append(sc)
		
	lines = [stripTags(line) for line in file.readlines()]
	
	for line in lines:
		line = line.strip()
		
		#print "LINE", line
		
		if line == "Synopsis":
			insynopsis = True
		elif line == "Object Hierarchy":
			insynopsis = False
			inoh = True
		elif line == "Description":
			insynopsis = False
			inoh = False
		elif line == "Properties":
			insynopsis = False
			inoh = False
			inprop = True
			insignal = False
			inintf = False
		elif line == "Signal Prototypes" or line == "Signals":
			insynopsis = False
			inoh = False
			inintf = False
			inprop = False
			inpropdetails = False
			insignal = True
			insignalstart = False
		elif line == "Implemented Interfaces":
			insynopsis = False
			inoh = False
			inprop = False
			inpropdetails = False
			insignal = False
			inintf = True
		elif line == "Known Implementations":
			insynopsis = False
			inoh = False
			inprop = False
			inpropdetails = False
			insignal = False
			inintf = False
			isinterfaceclass = True
			
		# fixme inprop = True for properties?
		elif (inprop == True) and ((line.startswith("The &quot;") and line.endswith(" property")) or (line.startswith("&quot;"))):
			# (line.startswith("&quot;")) is for dia-canvas
			#if classname == "AtkHyperlink":
			#	print "find prop", line
			
			if line.startswith("The &quot;"):
				name = line[10:]
			elif line.startswith("&quot;"):
				name = line[6:]
				
			i = name.find("&quot;")
			name = name[:i]
			#print name
			pname = name
			
			classdef.props[name] = {}
			inpropdetails = True
			
			# diacanvas:
			if True: #classdef.classname.startswith("Dia"):
				i = line.find("(")
				if i == -1:
					#   &quot;strength&quot;             DiaStrength          : Read / Write
					if line.find(": ") > -1 and (line.find("Read") > -1 or line.find("Write") > -1):
						i = line.strip().find(" ")
			else:
				i = -1
				
			if i > -1: # "grid-bg" (gulong : Read / Write)	
				rest = line[i + 1:]
				rfs = rest.split(":",1)
				assert(len(rfs) == 2)
				datatype = overrideProptype(classdef, pname, rfs[0].strip())
				rw = rfs[1]
				canread = rw.find("Read") > -1
				canwrite = rw.find("Write") > -1
				
				classdef.props[name] = {
					"datatype": datatype,
					"canread": canread,
					"canwrite": canwrite,
				}
				pname = None
				inpropdetails = False
			
		else:
			if insignal == True:
				if insignalstart == False:
					if line.startswith("The &quot") and line.endswith("&quot; signal"):
						insignalstart = True
						insignalname = line
						insignalname = insignalname.replace("The &quot;", "").replace("&quot; signal", "")
						classdef.signals[insignalname] = ""
						if isDebug():
							print classdef.classname, "insignal >%s<", insignalname
				else: # if insignalname != None:
					classdef.signals[insignalname] = classdef.signals[insignalname] + " " + line
					if line.find(";") > -1:
						classdef.signals[insignalname] = classdef.signals[insignalname].strip()
						insignalstart = False
				
			if inoh and line.strip() != "":
				arr =  line.split("+----")
				for item in arr:
					#print "ITEM", item
					item = item.strip()
					if item.find("-") > -1 or item.find("+") > -1:
						print classdef.classname, "ERROR inoh (%s)" % item
						sys.exit(1)
						
					if item.lower() == classdef.classname.lower(): # stop at self
						# the lower() is a workaround for the GdkGC weirdness
						# real: GdkDrawable -> gdk_drawable , as expected
						# real: GdkGC -> gdk_gc, expected: gdk_g_c
						# so I make it GdkGc in pascal
						ascendentantsDone = True
						break
						
					if item != "" and ascendentantsDone == False:
						if item not in classdef.ascendentants:
							classdef.ascendentants = [item] + classdef.ascendentants
			
			if insynopsis == True and not line.startswith("#") and line != "" and \
			not line.startswith("struct ") and not line.startswith("enum ") and \
			not line.startswith("union ") and not line.startswith("typedef ") and \
			not line.startswith("GtkAboutDialogtypedef") and \
			not line == classname + ";":
				fnlines.append(line)
				
			#if line.find("typedef") > -1:
			#	print "UGH", line
				
			if inintf == True:
				items = [i.replace(".", "").replace(",", "") for i in line.split(" ") if i != "" and i != "and" and i != "implements" and i != classname ]
				for item in items:
					if item not in classdef.cimplementsinterfaces:
						classdef.cimplementsinterfaces[item] = None # value will be filled later .append(item)
				
				#implementsinterfaces.append()
				
				if line.strip().endswith("."): # last one
					inintf = False
				
			if inprop == True and inpropdetails == True:
				if not line.startswith("&quot;" + name):
					if classdef.classname.startswith("Dia"):
						try:
							del classdef.props[pname]
							print classname, "warning: skipped property ", pname
							print classname, "info: line was", line
						except:
							pass
				else:
					a = line.split(" ")
					b = []
					for i in a:
						if i.strip() != "":
							b.append(i)
					
					datatype = overrideProptype(classdef, pname, b[1])
					
					
					rw1 = b[3]
					# 4= "/"
					try:
						rw2 = b[5]
					except:
						rw2 = None
						
					try:
						rw3 = b[7]
					except:
						rw3 = None

	
					#rw3 = "Construct only" ?
					classdef.props[pname]["datatype"] = datatype
					classdef.props[pname]["canread"] = rw1 == "Read"
					classdef.props[pname]["canwrite"] = rw2 == "Write" or rw1 == "Write"
					
					# construct only is appended, fixme
	
				i = line.find("Allowed values:")
				if i > -1:
					val = line[i+len("Allowed values:"):]
					val = val.strip()
					val = val.replace("&gt;", ">")
					#print "default", val # '>= 0', '[0,1]', '[1e-04,10000]'
					classdef.props[pname]["default"] = val

				if line.startswith("Default value:"):
					inpropdetails = False
			pass
	
	#print "fnlines", fnlines
	
	xfns = fnsFromFNLines(fnlines)
	for k, fn in xfns.items():
		if k in classdef.fns:
			print classdef.classname, "warning", "duplicate function %s in class" % k
			
		classdef.fns[k] = fn
		
	for clasigname in cskipsignals:
		if not clasigname.startswith(classdef.classname + "."): continue
		signame = clasigname[len(classdef.classname + "."):]
		
		if signame in classdef.signals:
			del classdef.signals[signame]

	# this is a special handling for DiaCanvasGroup
	# DiaCanvasGroup does not list a signal that is listed in DiaCanvasGroupable
	# hence these have to be simulated (at least until proper ginterface support is there, if it is)
	
	if classdef.classname == "DiaCanvasGroup":
		# made that up. only ref is dia-canvas-groupable.h signals comment.
		classdef.signals["add"] = "void user_function(DiaCanvasGroup* group, DiaCanvasItem* item, gpointer user_data);"
		classdef.signals["remove"] = "void user_function(DiaCanvasGroup* group, DiaCanvasItem* item, gpointer user_data);"

	# likewise
	if classdef.classname == "DiaCanvasText":
		classdef.signals["text-changed"] = "void user_function(DiaCanvasText *diacanvastext, gchar *arg1, gpointer user_data);"
		classdef.signals["start-editing"] = "void user_function(DiaCanvasText *diacanvaseditable, DiaShapeText *arg1, gpointer user_data);"
		classdef.signals["editing-done"] = "void user_function(DiaCanvasEditable *diacanvaseditable, DiaShapeText *arg1, gchar *arg2, gpointer user_data);"
		
def getInterfaceOfImplementationFN(fn):
	cimplementsinterfaces = getCImplementsInterfaces()
	fnname = fn["name"]
	for interface in cimplementsinterfaces:
		usc = uscclassnameOfClassname(interface)
		if fnname.startswith(usc + "_"):
			#print "is i i", fnname, "bla", interface, "du", usc
			return interface
			
	return None

def doesInterfaceRequireFN(fn):
	return isInterfaceImplementationFN(fn)

def isInterfaceImplementationFN(fn):
	return getInterfaceOfImplementationFN(fn) != None

def isMemberFN(fn):
	global classname
	args = fn["args"]
	b = len(args) >= 1 and args[0][0].lower() == classname.lower() + "*" # gdkgc workaround
	
	if (not b) or b:
		if classname == "GdkPixbuf" and args[0][0] != "" and fn["name"] != "gdk_pixbuf_get_file_info":
			b = True
	
	
	if b: return True

	if isDebug():	
		print classname, "not a member function", fn
		
	return False

def parseVar(item):
		item = item.strip()
		if item.endswith(";"):
			item = item[:-1].strip()
			
		#print "item>", item, "<"
		
		if item.find(" [") > -1:
			item = item.replace(" [", "[")
		
		rn = item.split(" ")
		rnn = []
		for rni in rn:
			rni = rni.strip()
			if rni != "": rnn.append(rni)
	
		varname = rnn.pop()
		vartype = " ".join(rnn)
		
		while varname.startswith("*"):
			varname = varname[1:]
			vartype = vartype + "*"
			
		if varname == "affine[6]": # sigh
			varname = "affine"
			vartype = "TAffineTransform"

		if varname.endswith("[]"): # ahem... gdk_gc_set_dashes
			varname = varname[:-2].strip()
			vartype = vartype.strip() + "*"
			
		#if name == "gdk_gc_set_dashes":
		#	print "MOOO!", varname, vartype
			
		if varname in [ "function", "label", "end", "type", "object", "var", "begin" ]:
			varname = varname + "1" # err...
	
		return vartype, varname

fncommentR = re.compile(r"^(.*)(/\*[^/]*\*/)(.*)$", re.M)


closeopenR = re.compile(r"^[a-zA-Z_ *][a-zA-Z_ 0-9*]+\)[ ]*\(")
# '*_gtk_reserved2) (void);'

class InvalidFunction(exceptions.Exception):
	pass
	
def parseFN(rest, pointertoo = False):
	global classname
	global fncommentR
	global closeopenR
	name, attr = None, None
	
	adebug = False
	#if classname == "DiaConstraint" and rest.find("DiaConstraintFunc") > -1:
	#	adebug = True
	
	while True:
		m = fncommentR.search(rest)

		if not m:
			break
		
		#print "MATCH"
		
		rest = m.group(1) + " " + m.group(3)	
		#print "NREST", rest
		
	if rest.find("/*") > -1:
		#print ">>>",rest,"<<<"
		assert(rest.find("/*") == -1)
	
	bp = rest.split("(", 1)
	if len(bp) < 2:
		print classname, "ERROR, invalid function", rest
		raise InvalidFunction()
		#sys.exit(1)

	r = bp[1]
	
	r = r.strip()
	
	if r.startswith("*") and not pointertoo: # probably void        (*DiaConstraintFunc)            (DiaConstrain
		return None, None
	
	j = r.find("(")
	if j>-1 and not closeopenR.match(r):
		pass
		#print "IIIEH", r
		#'GdkWindow *window,GdkRegion *region,gboolean (*child_func) (GdkWindow *, gpointer),gpointer user_data);'
		
	if j > -1 and closeopenR.match(r):
		#print "REST",rest
		#print "UGH"
		#print r
		#if (r[0] != "*"):
		#	print "r", r
		#	print "rest", rest
			
		assert(r[0] == "*")
		# "void (*x)(bla blo)"
		x = r[:j].replace("*", "") # x
		
		bp[0] = bp[0] + " " + x
		
		r = r[r.find("(")+ 1:]
		bp[0] = bp[0].replace(")", "").strip()
		
		#print "bp0", bp[0]
		#print "r", r

	rn = bp[0].split(" ")
	rnn = []
	for rni in rn:
		rni = rni.strip()
		if rni != "": rnn.append(rni)
		
	name = rnn.pop()
	attr = {}
	attr["return"] = " ".join(rnn)
	
	# bp[1] "Bla*a, gint i);"
	
	
	r = r.strip()
	if r.endswith(";"): r = r[:-1]
	r = r.strip()
	if r.endswith(")"): r = r[:-1]
	r = r.strip()

	attr["args"] = []
		
	arr = r.split(",")
	for item in arr:
		if item.strip() != "":
			vartype, varname = parseVar(item)
			attr["args"].append([vartype, varname])
		
	if len(attr["args"]) == 1 and attr["args"][0] == ["", "void"]:
		attr["args"] = []

	if name == "gtk_label_set_text":
		# weird workaround for broken gtk docs/ll handler
		attr["args"][1][0] = "const gchar*"
		
	attr["name"] = name
	
	if name.find("void") > -1:
		print classname, "error", "internal error", "void in function name"
		print classname, "text was", rest
			
	return name, attr

############ add external declarations ###############

def exttype(ctypename, isreturn):
	global classname
	t = exttypei(ctypename, isreturn)
	
	if isreturn == True and t.startswith("const "):
		t = t[len("const "):]
		
	if t == "int": t = "gint" # sigh
	
	return t
	
def exttypei(ctypename, isreturn): # char*
	global cclasses
	global c2penumcopied
	global enumprefix
	global c2pstructcopied
	global externaltypemap
	global c2pfuncparamoverride # TODO use tool.py functions
	global c2ptypehash
	
	pmod = ""
	
	if ctypename in externaltypemap:
		return externaltypemap[ctypename]
		
	if ctypename in c2ptypehash:
		return c2ptypehash[ctypename]
	
	if isreturn == True and ctypename == "gchar*":
		return "PGChar"

	if ctypename.endswith("*"):
		xtypename = ctypename[:-1]
		p = "^"
	else:
		p = ""
		xtypename = ctypename

	if xtypename.startswith("const "):
		pmod = "{const} "
		xtypename = xtypename[6:]

	#if xtypename.find("CellEditable") > -1:
	#	print "BOOxxxxx", xtypename, ctypename

	if (xtypename.endswith("*") and xtypename[:-1] in cclasses) or (p != "" and xtypename in cclasses):
		#if xtypename.find("CellEditable") > -1:
		#	print "BOO"
			
		return "Pointer{%s}" % ctypename
		
	# if xtypename in ["GdkGc", "GdkGcValues"]: special handled in readdef.py
		
	if xtypename.startswith("G_CONST_RETURN "):
		assert(isreturn == True)
		pmod = ""
		xtypename = xtypename[len("G_CONST_RETURN "):]

	n = p + xtypename
	
	if xtypename in c2penumcopied:
		n = p + wrapperprefix + xtypename
		
	if xtypename in c2pstructcopied:
		n = p + wrapperprefix + xtypename 
		#n = p + c2pstructcopied[xtypename]

	#first = True	
	while n.startswith("^"):
		x = n[1:]
		#if x.startswith("T"):
		#	x = x[1:]

		n = "P" + x
		
	if n.startswith("P") and not n.startswith("PW"):
		n = "PW" + n[1:]

	if n in c2pcallbackpointers:
		return c2pcallbackpointers[n]

	return pmod + n

def uscclassnameOfClassname(classname):
	uscclassname = ""
	for c in classname:
		if c.isupper():
			uscclassname = uscclassname +  "_" + c.lower()
		else:
			uscclassname = uscclassname + c
	
	uscclassname = uscclassname[1:]
	
	if uscclassname == "gnome_canvas_r_e": uscclassname = "gnome_canvas_re"
	if uscclassname == "gdk_g_c": uscclassname = "gdk_gc"
	if uscclassname == "gtk_u_i_manager": uscclassname = "gtk_ui_manager"
	if uscclassname.startswith("gtk_v_"): uscclassname = "gtk_v" + uscclassname[6:]
	if uscclassname.startswith("gtk_h_"): uscclassname = "gtk_h" + uscclassname[6:]
	if uscclassname == "gtk_i_m_context": uscclassname = "gtk_im_context"
	if uscclassname == "gtk_i_m_context_simple": uscclassname = "gtk_im_context_simple"
	if uscclassname == "gtk_i_m_multicontext": uscclassname = "gtk_im_multicontext"

	return uscclassname

def pclassnameOf(cclassname):
	if cclassname == "GnomeCanvasRE":
		pclassname = classprefix + "GnomeCanvasRe"
	elif cclassname != "GdkGC":
		pclassname = classprefix + cclassname
	else:
		pclassname = classprefix + "GdkGc"
		
	return pclassname

def setIVersion(ver):
	global xxversion
	xxversion = ver
	
def iversion():
	# returns interface version string (suffix)
	# examples for the used names are:
	#   IGtkTreeView24
	
	# this is not yet used until I cleared how to pass I* parameters (with the oldest version it was available in)
	# for example GdkDrawable26: procedure DrawXYZ(gc: IGdkGC20; ...); 2.0 !! not 2.6
	
	global xxversion
	
	return ""
	
	s = str(xxversion).replace(".", "")
	return s
	
