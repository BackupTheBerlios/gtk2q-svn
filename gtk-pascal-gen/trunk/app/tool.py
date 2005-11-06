#!/usr/bin/env python
from readdef import *
from guid import allocGUID
import string # digits

# there are three signal callbacks that have io parameters:
#  GtkSpinButton.input              var gdouble value
#  GtkEditable.insert-text          var gint position
#  GtkMenuItem.toggle-size-request  var gint requisition

def classunit(pclassname):
	global classprefix
	global classunitprefix
	global classname
	
	if pclassname == "TGdkEvent":
		return "uwrapgdknames"
	
	if pclassname == "TGdkColorspace":
		return "ugdkpixbuftypes"
		
	if not pclassname.startswith(classprefix):
		print classname, "error", pclassname, "is not a pclass"
		
	return classunitprefix + pclassname[len(classprefix):].lower()

def implementationClassForInterface(interface):
	global classprefix
	global interfaceprefix
	if not interface.startswith(interfaceprefix):
		print "error", interface, "is not an interface"
	
	return classprefix + interface[len(interfaceprefix):]

def arrayTypeOf(xarritemt):
	preturn = xarritemt + "Array" #
	if preturn == "StringArray": preturn = "TStringArray"
	if preturn == "UTF8StringArray": preturn = "TUTF8StringArray"
	return preturn
		
def classFromInterface(interface):
	return implementationClassForInterface(interface)

def interfaceunit(interface):
	global interfaceprefix
	global interfaceunitprefix
	global classname
	global interfaceunitoverride

	if interface in interfaceunitoverride:
		return interfaceunitoverride[interface]
	
	if interface.startswith(interfaceprefix + "Gdk"):
		return interfaceunitprefix + "gdk"
		
	if interface.startswith(interfaceprefix + "Gtk"):
		return interfaceunitprefix + "gtk"
	
	if interface.startswith(interfaceprefix + "Atk"):
		return interfaceunitprefix + "atk"
		
	if interface.startswith(interfaceprefix + "Pango"):
		return interfaceunitprefix + "pango"
		
	if interface.startswith(interfaceprefix + "GnomeCanvas"):
		return interfaceunitprefix + "gnomecanvas"
	
	if interface.startswith(interfaceprefix + "Art"):
		return interfaceunitprefix + "art"
		
	if interface.startswith(interfaceprefix + "Dia"):
		return interfaceunitprefix + "diacanvas"

	#return interfaceunitprefix + interface.lower()[len(interfaceprefix):]

def findleadingwhitespace(s):
	initindent = ""
	for c in s:
		if c == " " or c == "\t":
			initindent = initindent + c
		else:
			break
			
	return initindent

def stripemptylines1(s):
	a = s.split("\n")
	if len(a) > 0 and a[0] == "": del a[0]
	p = ""
	b = []
	if len(a) > 0:
		initindent = findleadingwhitespace(a[0])
	else:
		initindent = ""

	for i in a:
		if i == "" and p == "":
			p = i
			continue
			
		if i.startswith(initindent):
			i = i[len(initindent):]
			
		b.append(i)
		p = i

	return b
	
def addmembervars():
	global paddmembervars
	if classname in paddmembervars:
		mvar = paddmembervars[classname]
	else:
		mvar = ""
		
	return mvar
	
def addfuncs(prototypesonly):
	global paddfuncs
	global paddprops
	global classname
	
	if classname in paddfuncs:
		addf = paddfuncs[classname]
	else:
		addf = {}
		
	s = ""
	for k,v in addf.items():
		#if v.startswith("public "): v = v[7:]
		
		if v.find(":") == -1 and v.find("(") == -1 and v.find("=") > -1: # IDiaCanvasGroupable.Next = IterNext
			if prototypesonly == False:
				continue
				
			if isInInterfaceMode():
				continue
				#if v.find("=") > -1:
				#	a = v.split(" ", 1)
				#	ixa = a[1].find("=")
				#	a[1] = a[1][ixa + 1:]
				#	
				#	v = " ".join(a)

			#print "V",v
			
			s = s + v + "\n"
			continue
		
		if prototypesonly == True:
			b = stripemptylines1(v)
			l1 = b[0]

			if l1.startswith("public "): l1 = l1[7:]
			if l1.startswith("published "): l1 = l1[7+3:]
			if l1.startswith("protected "): l1 = l1[7+3:]

			if (l1.startswith("class ") or l1.startswith("constructor ") or l1.find("override") > -1) and isInInterfaceMode():
				continue
			
			v = l1
		else: # body
			b = stripemptylines1(v)
						
			if len(b) == 0:
				print classname, "warning", "paddfuncs member is empty: ", k
				continue
			
			l1 = b[0]
			if l1.startswith("public "): l1 = l1[7:]
			if l1.startswith("published "): l1 = l1[7+3:]
			if l1.startswith("protected "): l1 = l1[7+3:]
			l1 = l1.replace("function ", "function %s." % pclassname)
			l1 = l1.replace("procedure ", "procedure %s." % pclassname)
			l1 = l1.replace("constructor ", "constructor %s." % pclassname)
			l1 = l1.replace("reintroduce;", "")
			l1 = l1.replace("override;", "")
			l1 = l1.replace("overload;", "")
			#l1 = l1.replace("virtual;", "") etcetc
			b[0] = l1
			
			v = "\n".join(b)
			
		s = s + v + "\n"

	if prototypesonly == True:
		if classname in paddprops:
			addp = paddprops[classname]
		else:
			addp = {}

		ccc = {} # protection -> list(fns)
		for k,v in addp.items():
			protection = "private"
			
			if v.startswith("public "):
				v = v[len("public "):]
				protection = "public"
				
			if v.startswith("published "):
				v = v[len("published "):]
				protection = "published"

			if v.startswith("private "):
				v = v[len("private "):]
				protection = "private"

			if protection not in ccc: ccc[protection] = []
			ccc[protection].append(v)
		
		for protection, vs in ccc.items():
			if not isInInterfaceMode(): # they dont support it
				s = s + protection + "\n" # public or so
				
			for v in vs:
				s = s + "  " + v + "\n"
	
	b = stripemptylines1(s)
	s = "\n".join(b)
		
	#print s	
	return s

def signalUnit():
	global classname
	return "s%s.inc" % classname.lower()

def c2psignalname(cname):
	if cname.find("::") > -1: # fixme GtkFileChooserDefault has that. test.
		cname = cname[cname.find("::") + 2:]

	return "On" + "".join([x.capitalize() for x in cname.split("-")])

def signalTypeOf(csignalname):
	t = pclassnameOf(signalInterfaceOfSignal(csignalname)) + "T" + c2psignalname(csignalname)[2:] + "Signal"
	return t

def callbackTypeOf(csignalname):
	return "THandler" + pclassnameOf(signalInterfaceOfSignal(csignalname)) + "T" + c2psignalname(csignalname)[2:]


def signalInterfaceOfSignal(csignalname):
	global classname
	global c2psignalparamoverride
	signals = getSignals()
	cimplementsinterfaces = getCImplementsInterfaces()
	
	#d1 = False
	#if csignalname == "rows-reordered":
	#	#print "================ WAAAAAH ================="
	#	d1 = True

	for iface, v in cimplementsinterfaces.items():
		if not v:
			continue
			
		if csignalname in v.signals:
			#print "YEP", iface, csignalname
			return iface

		### in case some interface failed to read, we would end up not finding the correct interface ###
		### thus cheat by checking the overrides for the signals (the overrides list the original class they are in) ###

		k = "%s.%s" % (iface, csignalname)
		
		if k in c2psignalparamoverride:
			return iface

	if (csignalname in signals) and isSignalMine(csignalname):
		return classname

	print classname, "warning: signal interface of signal %s not found", csignalname
	return None

def getSignalParamOverride(csignalname, ix):
	global classname
	global c2psignalparamoverride
	
	cinterface = signalInterfaceOfSignal(csignalname)
	
	k = "%s.%s" % (cinterface, csignalname)
	
	if k in c2psignalparamoverride:
		try:
			return c2psignalparamoverride[k][ix]
		except:
			return None

	return None

def callbackReturnOf(csignalname):
	global classname
	global c2psignalparamoverride
	
	signals = getSignals()
		
	k = "%s.%s" % (classname, csignalname)

	returnover = None
	if k in c2psignalparamoverride:
		try:
			returnover = c2psignalparamoverride[k][0]
		except:
			pass

	signal = signals[csignalname]
	name, attr = parseFN(signal)
	
	creturn = attr["return"]
	
	preturn = creturn
	if returnover != None and returnover[0] == "type":
		return returnover[1]
	
	return preturn

def callbackParamsOf(csignalname, isdest = False):
	global cclasses
	global interfaceprefix
	global c2pstructcopied
	global c2penumcopied
	global enumprefix
	global classprefix
	global pstringtype
	global nongobjectclasses
	global c2ptypehash
	signals = getSignals()
	
	signal = signals[csignalname]
	
	name, attr = parseFN(signal)
	
	creturn = attr["return"]
	#assert(creturn == "void") FIXME
	
	args = attr["args"]
	
	pparamlist = []
	cparamlist = args
	
	havesender = False
	ix = 1
	for cparam in cparamlist:
		ctype = cparam[0]
		cname = cparam[1]
		
		pname = cname
		ptype = ctype
		useconst = False
		usevar = False
		
		overridea = getSignalParamOverride(csignalname, ix)
		if overridea != None and len(overridea) > 0 and overridea[0] != None:
			override = overridea[0]
		else:
			override = None
			
		ix = ix + 1
		
		if override == "userdata" or pname == "user_data":
			# todo
			continue
		
		if override == "pointer" and ctype == "gpointer":
			ptype = "Pointer"
		elif override == "type":
			ptype = overridea[1]
		elif ctype == "GParamSpec*":
			ptype = "DGParamSpecName"
			#"Pointer" # fixme
		elif ctype == "gchar*": # cellrenderertext signal prototypes have that annoying habit
			ptype = pstringtype
		elif ctype == "gint*": # gtkeditable insert-text in/out parameter
			usevar = True
			ptype = "Integer" # gint
		elif ctype in c2ptypehash:
			ptype = c2ptypehash[ctype]
		elif ctype.endswith("*"):
			xtype = ctype[:-1]
			if (not havesender) and (xtype == classname):
				pname = "Sender"
				ptype = classprefix + "GObject"
				havesender = True
			elif (xtype in cclasses):
				ptype = interfaceprefix + xtype
				impclass = implementationClassForInterface(ptype)
				if impclass not in nongobjectclasses:
					ptype = "IGObject{%s}" % ptype
					
			elif (xtype in c2pstructcopied):
				ptype = c2pstructcopied[xtype]
				useconst = True
				
			
		else: # no pointer
			xtype = ctype
			if (xtype in c2penumcopied):
				ptype = enumprefix + xtype

			if ptype == "GUInt":
				ptype = "Cardinal" # fixme
			elif ptype == "gint":
				ptype = "Integer" # fixme
			
		prefix = ""
		if useconst == True:
			prefix = "const "
		elif usevar == True:
			prefix = "var "
			
		pparamlist.append((prefix + ptype, pname)) 
		#"%s%s: %s" % (prefix, pname, ptype))

	return pparamlist		
	
def stringCallbackParamsOf(csignalname):
	ps = []
	for item in callbackParamsOf(csignalname):
		argtype = item[0]
		argname = item[1]
		a = argtype.split(" ")
		argtype = a[-1]
		if len(a) > 1:
			prefix = a[0] + " "
		else:
			prefix = ""
			
		ps.append("%s%s: %s" % (prefix, argname, argtype))
	
	return "; ".join(ps)
	
def varreplace(varname, callback, data):
	global pclassname
	global classname
	global punit
	global ascendentants
	global pextraconsts
	global pextratypes
	global classprefix
	global usedclasses
	global psignalusediocimpl
	global path1
	global uscclassname
	global pwrapped
	global comments
	global interfaceprefix
	global interfaceunitprefix
	global piunit
	global interfaceaddlines
	global signalimpl
	global signalintl
	global pexternfuncs
	global psignalusedioc
	global underivable
	global pextraconstructcode

	cimplementsinterfaces = getCImplementsInterfaces()

	if varname == "pextraconstructcode":
		if classname in pextraconstructcode:
			return pextraconstructcode[classname]
			
		return ""
		
        
	if varname == "gtypeclass":
		if classname in underivable:
			return "Integer" # fixme
			pass

		return "W%sClass" % classname
	if varname == "includepgclassdef":
		if classname in underivable:
			return ""
			
		return "{$INCLUDE ../../output/" + path1 + "/c" + classname.lower() + ".inc}"
	if varname == "signalimpl":
		return signalimpl % { "psignalunit": signalUnit(), "path1": path1 } #  fixme INCLUDE
		#\n".join(signalimpl.values())
	elif varname == "signalintf":
		return signalintf % { "psignalunit": signalUnit(), "path1": path1 } #  fixme INCLUDE
	elif varname == "pexternfuncs":
		return "\n".join(pexternfuncs)
	elif varname == "paddmembervars":
		return addmembervars()
	elif varname == "paddfuncs":
		return addfuncs(False)
	elif varname == "paddfuncprototypes":
		return addfuncs(True)
	elif varname == "ptypeuses":
		return ", u" + path1.replace("-", "") + "types"
	elif varname == "namespace":
		return path1
	elif varname == "punit":
		return punit
	elif varname == "psunit":
		return "s" + classname.lower()
	elif varname == "psuses":
		l = ["s" + classname.lower()]
		for ainterface in cimplementsinterfaces.keys():
			l.append("s" + ainterface.lower())

		# at LEAST 1 item
		#if path1 == "gdk-pixbuf":
		#	return "sgdk"
			
		#return "s%s" % path1
		return ",".join([""] + l)
		#return psunit
	elif varname == "piunit":
		return piunit
	elif varname == "pinterfaceaddlines":
		return "\n".join(interfaceaddlines)
	elif varname == "psiguses":
		arr = []
		if isInSignalMode():
			if path1 == "gtk":
				arr.append("ugtktypes")
				arr.append("ugdktypes")
			
			k = "u%stypes" % path1.replace("-", "")
			if k not in arr:
				arr.append(k)
			
			if pclassname in psignalusedioc:
				for intorclass in psignalusedioc[pclassname]:
					if isInterface(intorclass):
						un = interfaceunit(intorclass)
						if un not in arr:
							arr.append(un)
					elif intorclass.startswith("TGdkEvent"):
						if "ugdktypes" not in arr:
							arr.append("ugdktypes")
					elif intorclass == "TGdkRgbColor":
						if "ugdkrgb" not in arr:
							arr.append("ugdkrgb")
			
		return ",".join([""] + arr)
		
	elif varname == "piuses":
		arr = []
		for item in ascendentants:
			nu = interfaceunit(interfaceprefix + item[len(classprefix):])
			if nu != None and nu not in arr:
				arr.append(nu)

		for interface in usedinterfaces:
			iuname = interfaceunit(interface)
			
			if iuname != None and iuname not in arr:
				#print interface, iuname
				arr.append(iuname)
		
		if piunit in arr and isInInterfaceMode():
			arr.remove(piunit) # not self
			
		#if (piunit not in arr) and not isInInterfaceMode():  # not good
		#	arr.append(piunit)
			
		if not isInInterfaceMode():
			item = classname
			n = interfaceprefix + item
			n = interfaceunit(n)
			if n != None and n not in arr:
				arr.append(n)
			
		if "iugobject" not in arr:
			arr.append("iugobject")
			
		#if interfaceunitprefix + "gdkwindow" in arr:
		#	arr.remove(interfaceunitprefix + "gdkwindow") # does not exist.
			
		#if interfaceunitprefix + "gdkcolormap" in arr:
		#	arr.remove(interfaceunitprefix + "gdkcolormap")
		#	if (interfaceunitprefix + "gdkcolor") not in arr:
		#		arr.append(interfaceunitprefix + "gdkcolor")
		
		return ",".join([""] + arr)
	elif varname == "pauses":
		arr = []
		for item in ascendentants:
			arr.append("u" + item.lower())

		# todo make that a setting 
		if path1 == "gtk" or path1 == "gnome-canvas" or path1 == "diacanvas":
			if "ugdktypes" not in arr:
				arr.append("ugdktypes")
				
			if "upangotypes" not in arr:
				arr.append("upangotypes")
				
			if path1 == "gnome-canvas":
				if "uarttypes" not in arr:
					arr.append("uarttypes")
					
				if "ugtktypes" not in arr:
					arr.append("ugtktypes")
					
			if path1 == "diacanvas":
				if "ugdkrgb" not in arr:
					arr.append("ugdkrgb")
					
				if "ugnomecanvastypes" not in arr:
					arr.append("ugnomecanvastypes")
					
				if "uarttypes" not in arr:
					arr.append("uarttypes")
				
		if path1 == "gdk-pixbuf":
			#if "ugdkpixbuftypes" not in arr:
			#	arr.append("ugdkpixbuftypes")
				
			#if "upangotypes" not in arr:
			#	arr.append("upangotypes")
			pass
			
		euses = getExtraUses()
		for euse in euses:
			if euse not in arr:
				arr.append(euse)
				
		return ",".join([""] + arr)
		
	elif varname == "guid":
		return allocGUID(classname)
		
	elif varname == "pimpuses":
		arr = []
		
		if True: #not isInSignalMode():
			arr.append("uwrapgnames")
			arr.append("uwrap%snames" % path1.replace("-", ""))
			
			if not isInSignalMode() and ( \
				classname.endswith("Store") or \
				classname.endswith("Model") or \
				classname=="DiaCanvas" \
			): # treestore, liststore
				arr.append("ugvalue")				
				arr.append("unicegvalue")
			
			if path1 in ["gtk", "gdk-pixbuf"]:
				arr.append("uwrapgdknames")
				
			if path1 == "diacanvas":
				arr.append("uwrapgnomecanvasnames")
			
			if path1 == "gnome-canvas" or path1 == "diacanvas":
				arr.append("uwrapgtknames")
				arr.append("uwrapgdknames")
				arr.append("uwrapartnames")
		
		#if path1 == "gtk":
		#	#arr.append("gtk2")
		#	#arr.append("gtk24")
		#	#arr.append("glib2")
		#	#arr.append("gdk2")
		#	#arr.append("gdk2pixbuf") # for gtkwindow, at least
		#elif path1 == "gdk":
		#	arr.append("gdk2")
		#	arr.append("gdk2pixbuf")
		#	arr.append("glib2")
		#elif path1 == "gdk-pixbuf":
		#	arr.append("gdk2pixbuf")
		#	arr.append("glib2")
		#else:
		#	arr.append("glib2")

		if isInSignalMode():
			if pclassname in psignalusediocimpl:
				xusedclasses = psignalusediocimpl[pclassname]
			else:
				xusedclasses = []
				
			if (pclassname in psignalusedioc) and ("uwrapgdknames" not in arr):
				for item in psignalusedioc[pclassname]:
					if item == "TGdkEvent":
						arr.append("uwrapgdknames")
						break
		else:
			xusedclasses = usedclasses
			
		for cua in xusedclasses:
			cu = classunit(cua)
			if cu not in arr:
				arr.append(cu)

		# insert lowlevel uses
		if not classname.startswith("Pango"):
			for interface in usedinterfaces:
				if interface.startswith("IPango") and "uwrappangonames" not in arr:
					arr.append("uwrappangonames")

		
		return ",".join([""] + arr)		
	elif varname == "pextraconsts":
		return "\n".join(pextraconsts)
	elif varname == "pextratypes":
		v = pextratypes.values()
		v.sort()
		return "\n".join(v)
	elif varname == "pclass":
		return classprefix + classname
	elif varname == "piclass":
		return interfaceprefix + classname + iversion()
	elif varname == "pancestorclass":
		return classprefix + ascendentants[0]
	elif varname == "pinterfaces":
		arr = []
		for item in [classname + iversion()] \
		+ ascendentants \
		+ maybeCloneable() \
		+ maybeUserdata() \
		+ ["Invokable"] \
		+ ["Interface"] \
		+ cimplementsinterfaces.keys():
			arr.append(interfaceprefix + item)
		return ",".join([""] + arr)		
	elif varname == "pancestorinterface":
		try:
			return interfaceprefix + ascendentants[0]
		except:
			print classname, "error", "no ascendentants"
			raise

	elif varname == "pinterface":
		return interfaceprefix + classname
	elif varname == "cclass1":
		return uscclassname
	elif varname == "cclass1type": 
		#standalone fixme
		#if uscclassname == "gdk_window":
		#	return "gdk_drawable_get_type" # fixme
		if uscclassname == "gtk_progress":
			return "0" # fixme
		else:
			return uscclassname + "_get_type"
			
	elif varname == "pwrapped":
		return pwrapped
	elif varname == "comments":
		return "\n".join(comments)
	elif varname == "cclassparams":
		try:
			return cclassconstructparams[classname]
		except:
			return "" # FIXME sometimes cannot construct
	else:
		if callback != None:
			res= callback(varname, data)
			if res != None:
				return res
				
		print "unknown var", varname
		return "UNKNOWN$$$"

def processTemplateLine(ofile, line, callback = None, data = None):
	textbetween = line.split("{")
	
	for item in textbetween:
		i = item.find("}")
		if i == -1:
			var = None
			text = item
		else:
			var = item[:i]
			text = item[i+1:]
	
		if var != None and var != "dummy":
			#print "var", var
			ofile.write(varreplace(var, callback, data))
	
		ofile.write(text)

	ofile.write("\n")

def isBoxed(data):
	b = data["datatype"] in [ "GdkColor", "GdkColor*", 
		"PangoFontDescription*", "PangoFontDescription", 
		"GtkBorder", "GtkRequisition",
		"DiaRectangle", "DiaPoint",
		"DiaCanvasItemAffine",
	]
	#if b == True: print "bweek", data
	
	return b

def processSubLines1(ofile, seclines, callback, data, insection): # for signalhandlerarg
	processSecLines1(ofile, seclines, callback, data, insection)

def processSecLines1(ofile, seclines, callback, data, insection): # for signal, #signalhandlerarg# #/signalhandlerarg#
	signal = data
	sublines = []

	ins = None
	#print "SECLINES", "\n".join(seclines)
	#print "==="
	for secline in seclines:
		ssecline = secline.strip()
		if ssecline.startswith("#"):
			sec = ssecline[1:]
			sec = sec[:sec.find("#")]
		else:
			sec = None
			
		if ins != None and sec == "/" + ins:
			ins = None
			args = callbackParamsOf(signal["name"])
			
			param = { "arg": None, "signal": signal, "argno": 0 }
			for arg in args:
				param["arg"] = arg
				param["argno"] = param["argno"] + 1
				processSubLines1(ofile, sublines, signalarg_cb, param, insection)
				
			sublines = []
		elif ins == None and sec == "signalhandlerarg":
			ins = sec
		elif ins != None:
			sublines.append(secline)
		else:
			processTemplateLine(ofile, secline, callback, data)
	
def processSecLines(ofile, seclines, callback, data, insection):
	global classname
	if insection.startswith("publicprocedure"):
		if "return" in data and data["return"] != "void" and data["return"] != "":
			return
		
	if insection.startswith("publicfunction"):
		if "return" not in data or (data["return"] == "void" or data["return"] == ""):
			return

	try:
		if insection == "propertywrite" and isBoxed(data): return
		if insection == "propertywriteboxed" and not isBoxed(data): return
			
		if insection == "propertyread" and isBoxed(data): return
		if insection == "propertyreadboxed":
			if not isBoxed(data):
				return
	except:
		print classname, "error: exception in processSecLines:"
		raise
	
	for secline in seclines:
		processTemplateLine(ofile, secline, callback, data)

def c2pfnname(cfnname):
	global uscclassname
	cimplementsinterfaces = getCImplementsInterfaces()
        	
	pfnname = ""
	xcfnname = cfnname
	
	for intf in cimplementsinterfaces.keys():
		u = uscclassnameOfClassname(intf)
		if cfnname.startswith(u + "_"):
			cfnname = cfnname[len(u) + 1:]
	
	if cfnname.startswith(uscclassname + "_"):
		cfnname = cfnname[len(uscclassname) + 1:]

	if cfnname.startswith("gdk_draw_"):
		cfnname = cfnname[len("gdk_"):]
			
	uc = True
	for c in cfnname:
		if c == "_":
			uc = True
		else:
			if uc == True:
				uc = False
				pfnname = pfnname + c.upper()
				
			else:
				pfnname = pfnname + c
				
	if pfnname in [ "Xor", "Raise", "Set" ]:
		pfnname = pfnname + "1"

	if pfnname == "SnapToGrid" and uscclassname == "dia_canvas":
		pfnname = "SnapToGridPoint"
			
	if pfnname == "Destroy":
		pfnname = "Dispose" # (IDisposable)
	
	if pfnname == "GdkDevicesList":
		pfnname = "DeviceList"
		
	if pfnname.startswith("GdkRectangle"): pfnname = pfnname[3:]
		
	if pfnname == "GdkListVisuals":
		pfnname = "VisualList"
	
	#if pfnname == "Activate" and cfnname == "gtk_menu_item_activate": # fixme
	#	# widget activate: boolean
	#	# menuitem activate;
	#	pfnname = "Activate1"
	
	cfnname = xcfnname
		
	if cfnname == "gtk_window_mnemonic_activate":
		pfnname = "WindowMnemonicActivate"

	if cfnname == "gtk_menu_item_set_accel_path": # fixme
		# widget set_accel_path(path: string, IAccelGroup)
		# menuitem set_accel_path(path: string);
		pfnname = "MenuItemSetAccelPath"
	
	if cfnname == "gtk_menu_set_accel_path": # fixme
		# widget set_accel_path(path: string, IAccelGroup)
		# menuitem set_accel_path(path: string);
		pfnname = "MenuSetAccelPath"

	if cfnname.startswith("gtk_accelerator") and pfnname.startswith("GtkAccelerator"):
		pfnname = pfnname[len("Gtk"):] # leaves "Accelerator"

	if cfnname.startswith("gtk_accel_groups_") and pfnname.startswith("GtkAccelGroups"):
		pfnname = pfnname[len("Gtk"):] # leaves "AccelGroups"
		
	if cfnname == "gtk_statusbar_remove": # fixme
		pfnname = "StatusbarRemove"
		
	if cfnname.startswith("gtk_rc_") and pfnname.startswith("GtkRc"):
		pfnname = pfnname[3:] # leaves "Rc"

	if pfnname.startswith("GdkDrag") or pfnname.startswith("GdkDrop"):
		pfnname = pfnname[3:] # leaves "Drag..."	
	
	if pfnname.startswith("GtkPaint"):
		pfnname = pfnname[3:] # leaves "Paint"

	if pfnname == "Copy":
		pfnname = "Clone"
		
	if cfnname.endswith("_sink"):
		pfnname = "SinkUnderlyingObject"
		
	if uscclassname == "dia_canvas_item":
		# rename to sane names
		if pfnname == "Visible":
			pfnname = "Show"
		elif pfnname == "Invisible":
			pfnname = "Hide"
		elif pfnname == "Connect":
			pfnname = "ConnectHandle"
				
	return pfnname
	
def isInterface(name):
	global interfaceprefix
	return name.startswith(interfaceprefix) and name != "Integer"

def isEnum(name):
	global c2penumcopied
	global enumprefix
	if not name.startswith(enumprefix):
		return False
		
	x = name[len(enumprefix):]
	return x in c2penumcopied
	
def isImplementationClass(name):
	global cclasses
	global classprefix
	global interfaceprefix
	for i in cclasses: #.values():
		if classprefix + i == name:
			return True
			#i[len(interfaceprefix):] == name:
			return True
		
def needImplementationUnitForClass(pclassname):
	global usedclasses
	global classname
	if pclassname != classname:
		if pclassname not in usedclasses:
			usedclasses.append(pclassname)
			
		#uname = classunit(pclassname)
		#if uname not in usedclasses:
		#	usedclasses.append(uname)
		#	#print "appended", uname
	
def needInterface(iname):
	global usedinterfaces
	global pextratypes
	if iname not in usedinterfaces:
		usedinterfaces.append(iname)
		#print "append", iname

	if iname not in pextratypes:
		pass
		#pextratypes[iname] = "%s = interface;" % iname

	pass
	
def c2ptypesmall(typn):
	global classprefix
	global c2ptypehash
	global wrapperpointerprefix
	global wrapperprefix
	if typn.endswith("*"):
		typn = wrapperpointerprefix + typn[:-1]
	else:
		if (not typn.startswith("T")) and (not typn.startswith(classprefix)):
			if not (typn in c2ptypehash):
				if typn == "gpointer":
					return "gpointer"
					
				if typn == "int": # gdk-pixbuf set_size weirdness
					return "Integer"
				
				if typn.startswith(wrapperprefix):
					return typn
				else:
					return wrapperprefix + typn # internal wrapper types
			else:
				return c2ptypehash[typn]
	
	return typn

def c2ptype(typn, inreturn = False, canvar = False):
	global classprefix
	global c2pcallbackpointers
	global cclasses
	global enumprefix
	global path1
	global c2ptypehash
	global c2penumcopied
	global c2pstructcopied
	global c2pconstpointerparam
	global interfaceprefix
	n = typn

	if typn == "const char*":
		typn = "const gchar*" # filechooser
	
	for p in c2pconstpointerparam:
		if typn == "const %s*" % p:
			typn = p
			break
			
	if typn == "int": # and path1 == "gdk-pixbuf":
		if isDebug():
			print "warning, assuming Integer for int"
			
		return "Integer"
		
	try:
		return c2ptypehash[typn]
	except:
		pass


	varok = "var "
	if inreturn == True:
		varok = ""
		
	if typn.endswith("*") and typn[:-1] in c2ptypehash:
		return varok + c2ptypehash[typn[:-1]]

	try:
		if typn in c2penumcopied:
			return enumprefix + typn
			#return c2penumcopied[typn]
	except:
		pass

	if typn.endswith("*") and typn[:-1] in c2penumcopied:
		return varok + enumprefix + typn[:-1]

	try:
		return c2pstructcopied[typn]
	except:
		pass

	if typn.endswith("*") and typn[:-1] in c2pstructcopied:
		return varok + c2pstructcopied[typn[:-1]]
		
	try:
		return c2pcallbackpointers[typn]
	except:
		pass


	if n.find("*") == -1:
		return "?" + n
		
	#if n == "gchar *"
	if n.endswith("*"):
		n = n[:-1]
		m = n
		
		# TODO move that to defs.py as a setting.
		if n.startswith("Atk") or n.startswith("Gtk") \
		or n.startswith("Gdk") or n.startswith("Pango") \
		or n.startswith("GnomeCanvas") or n.startswith("Art") \
		or n.startswith("Dia") \
		or n == "GClosure" or n == "GObject":
			n = interfaceprefix + n
		
		p = ""
		
		#p = "var " FIXME reintroduce that when needed
		if n.find("*") > -1: # err... whatthe...
			print "error", typn, "too many pointers"
			raise
			return None

		n = p + n

		if not (m in cclasses):
			#print "bweek", n
			n = "?" + n # [:-1]
		else:
			needInterface(n)
		
	return n
	
def c2pprop(cpropname):
	ppropname = ""
	uc = True
	for c in cpropname:
		if c == "-":
			uc = True
		else:
			if uc == True:
				uc = False
				ppropname = ppropname + c.upper()
			else:
				ppropname = ppropname + c

	if ppropname in [ "Label", "Type", "File" ]:
		ppropname = ppropname + "1"

	if ppropname.startswith("Gtk"): # gtksettings have that annoying habit
		ppropname = ppropname[3:]

	return ppropname

def isPropReadable(pname):
	props = getProps()
	
	return props[pname]["canread"]
	
def isPropKnown(pname):
	global cskipprops
	global classname
	
	props = getProps()
	prop = props[pname]
	
	if pname == "pixels": # fixme
		return False # skip 
	
	if pname == "user-data": # tree selection weirdness. FIXME
		return False # skip
	
	if classname + "." + pname in cskipprops:
		return False
	
	try:
		return isBoxed(prop) or proptype1(prop) != None
	except:
		print classname, "error: property %s: " % pname
		raise
	
def isPropWriteable(pname):
	props = getProps()
	
	return props[pname]["canwrite"]

def needPropUnwrapped(pname):
	props = getProps()

	datatype = props[pname]["datatype"]
	b = (datatype != "gint") and (datatype != "gchar*") and (datatype != "const gchar*") \
	and (datatype != "gchararray")
	
	return b
	
def proptype1(prop):
	global classprefix
	global c2penumcopied
	global classname
	global cclasses
	global nongobjectclasses
	
	if prop["datatype"] in c2penumcopied:
		return "UInt" # FIXME
		
	if prop["datatype"] == "GStrv":
		return "GStrv"
			
	pty = c2ptype(prop["datatype"])

	if prop["name"] == "selection-box-alpha": # sigh. workaround.
		return "Byte"
		
	if prop["name"] == "pixels": 
		return "Pointer"

	if pty == "Integer": return "Int"
	#if pty == "String": return "String"
	if pty == "UTF8String": return "String"
	if pty == "GUInt": return "UInt"
	if pty == "Boolean": return "Bool"
	if pty == "Single": return "Float"
	if pty == "Double": return "Double"
	#if pty == "TGtkBorder": return "Border" # FIXME
	#if pty == "TGtkRequisition": return "Requisition"
	if pty == "guchar": return "Byte"
	
	if pty == "guint64": return "GUInt64" # Gst... FIXME
	
	if pty == "TGdkRgbColor":
		return "UInt" # actually guint32!

	otype = prop["datatype"]
	if otype.endswith("*") and otype[:-1] in cclasses:
		# if otype[:-1] in nongobjectclasses: TODO... ?
		return "Object"
	
	if prop["name"] == "accel-closure": return None # I know and dont care
	
	print classname, "unknown proptype1 for ", prop["name"], prop["datatype"], pty

def prop_cb(varname, prop):
	global ptype1
	global classname
	if varname == "gprop":
		return prop["name"]
	elif varname == "ppropinterfacecast":
		ptype = c2ptype(prop["datatype"])
		if isInterface(ptype):
			return " as %s" % ptype
		if isEnum(ptype):
			return ")"
		if prop["datatype"] == "GStrv":
			return ")"
		return ""
	elif varname == "ppropinterfacecaststart":
		if prop["datatype"] == "GStrv":
			return "UTF8StringArrayFromStrv("
		else:
			ptype = c2ptype(prop["datatype"])
			if isEnum(ptype):
				return "%s(" % ptype

		return ""
	elif varname == "pprop":
		return c2pprop(prop["name"])
	elif varname == "pproputype":
		return "Pointer"
	elif varname == "propertyvisibility":
		if isBoxed(prop) == True: # fpc
			return "public"
			
		return "published"
	elif varname == "proptype1":
		return proptype1(prop)
	elif varname == "ppropgenericcast":
		pt1 = proptype1(prop)
		if pt1 == "Object":
			return " as IGObject"
			
		return ""
	elif varname == "proptype1cast":
		pt1 = proptype1(prop)
		if prop["name"] == "pixels":
			return "Pointer"
			
		if prop["datatype"] == "GStrv":
			return "StrvFromUTF8StringArray"
		                
		try:
			pt1 = ptype1[pt1]
		except:
			print classname, "unknown proptype1cast for", pt1
			
		return pt1
	elif varname == "pproptype":
		if prop["name"] == "selection-box-alpha": # sigh. workaround.
			return "Byte"
			
		if prop["name"] == "pixels":
			return "Pointer"
			
		if prop["datatype"] == "GStrv":
			return "TUTF8StringArray"
			
		ptype = c2ptype(prop["datatype"])
		return ptype
	elif varname == "ppropdefault":
		return "" # TODO ?
	
	return None

def propunwrapped_cb(varname, prop):
	return prop_cb(varname, prop)

def getClassConstruct(pclass):
	#pclassconstruct = pclass + ".GetOrCreateWrapped"
	global nongobjectclasses
	
	if pclass in nongobjectclasses:
		return pclass + ".CreateWrapped"
		
	#if pclass.startswith("TGtkFileChooser.*Dialog"):
	# use TGtkFileChooserDialogCreateWrapped
	#if pclass.startswith("TGtkFileChooser.*Widget"):
	# use TGtkFileChooserWidgetCreateWrapped
	# blahblah dont think anything returns that though.
		
	pclassconstruct = "WrapGObject"
	# TODO extra p arameter for the class to use minimally

	return pclassconstruct

def isFNWithGError(fn):
	global classname
	args = fn["args"]
	if len(args) == 0: return False
	
	la = args[-1]
	b = la[0] == "GError**"
	
	#if b:
	#	print classname, "warning", fn["name"]
	#if (not b) and( la[0].find("Error") >-1):
		
	return b

def pchartype(cttype):
	if cttype == "char*" or cttype == "const char*" or cttype == "G_CONST_RETURN char*":
		return "PChar"
	if cttype == "gchar*" or cttype == "const gchar*" or cttype == "G_CONST_RETURN gchar*":
		return "PGChar"
	
	if cttype.lower().find("char") > -1:	
		print "unknown type", cttype
	return "?"
	#c2ptype(cttype)

def arrayInfoFill(aty, inreturn):
	global classprefix
	arritemt = c2ptype(aty, inreturn=inreturn)
	# fixme string special handling as in "array" ?
	xarritemt = arritemt
	if xarritemt.startswith(classprefix):
		xarritemt = "T" + xarritemt[1:]
	else:
		xarritemt = xarritemt
				
	preturn = arrayTypeOf(xarritemt)
	pclassconstruct = arritemt

	return arritemt, preturn, pclassconstruct
			
	
def getFNListReturnOverride(fn):
	global c2pfuncparamoverride
	global pextratypes
	global interfaceprefix
	global classprefix
	global pstringtype
	
	res = {}
	
	if fn["name"] in c2pfuncparamoverride:
		overridep = c2pfuncparamoverride[fn["name"]]
	else:
		overridep = None

	if overridep != None and len(overridep) >= 1:
		returnoverride = overridep[0]
	else:
		returnoverride = None

	preturn = c2ptype(fn["return"])
	res["preturn"] = preturn
	res["arritemt"] = preturn

	if preturn == None:
		print classname, "error in function", fn["name"]
			
	if isInterface(preturn):
		pclass = classFromInterface(preturn)
		
		pclassconstruct = getClassConstruct(pclass)
		
		if returnoverride == None:
			print "error",fn["name"],"needs to have an interface return override"

		#print "isinterface", fn["eturn"]
		
		#return "interface", preturn, preturn, "", "", pclassconstruct
		#return None

	if returnoverride != None:
		res["kind"] = returnoverride[0]
		res["pforeachfree"] = ""
		res["pendfree"] = ""
		try:
			pendfree = returnoverride[2]
			pforeach = returnoverride[3]
			res["pendfree"] = pendfree
			res["pforeach"] = pforeach
			pforeachfree = returnoverride[5]
			res["pforeachfree"] = pforeachfree
		except:
			pass

		if returnoverride[0] == "overlay":
			res["pname"] = returnoverride[1]
			return res

		# C array:
		if returnoverride[0] == "array" and fn["return"] == "GtkAccelGroupEntry*" and fn["name"] == "gtk_accel_group_query":
			#"GtkAccelGroupEntry*"
			#print "fnreturn", fn["return"]

			aty = returnoverride[1]
			
			res["arritemraw"] = aty
			if res["arritemraw"] == "?":
				res["arritemraw"] = aty
				
			arritemt, preturn, pclassconstruct = arrayInfoFill(aty, True)
			res["arritemt"] = arritemt
			res["preturn"] = preturn
			res["pclassconstruct"] = pclassconstruct
			
			#print res, aty
			return res
			
		if returnoverride[0] == "array" and fn["return"] == returnoverride[1] + "*":
			aty = returnoverride[1]
			
			res["arritemraw"] = aty
			if res["arritemraw"] == "?":
				res["arritemraw"] = aty
				
			arritemt, preturn, pclassconstruct = arrayInfoFill(aty, True)
			res["arritemt"] = arritemt
			res["preturn"] = preturn
			res["pclassconstruct"] = pclassconstruct
			return res
				
		if returnoverride[0] == "array" and fn["return"] in ["GList*", "GSList*", "gchar**"]:
			if returnoverride[1] in [ "gchar*", "char*" ]: # filechooser
				arritemt = pstringtype
			else:
				arritemt = c2ptype(returnoverride[1])


			# todo test
			res["arritemraw"] = pchartype(returnoverride[1])
			if res["arritemraw"] == "?":
				res["arritemraw"] = returnoverride[1] # ??

			if arritemt.startswith(interfaceprefix):
				pclass = classFromInterface(arritemt)
				#pclassconstruct = pclass + ".GetOrCreateWrapped"
				pclassconstruct = getClassConstruct(pclass)
			else:
				pclassconstruct = arritemt #  FIXME
				
			xarritemt = arritemt
			if xarritemt.startswith(interfaceprefix):
				xarritemt = "T" + xarritemt
			
			preturn = arrayTypeOf(xarritemt)
			
			if preturn not in pextratypes:
				pass
				#pextratypes[preturn] = "%s = array of %s;" % (xarritemt+ "Array", arritemt)
	
	
			res["arritemt"] = arritemt
			res["preturn"] = preturn
			res["pclassconstruct"] = pclassconstruct
			return res
		elif returnoverride[0] == "array":
			print classname, "error", fn["return"] , "array requested but unknown carrier type found"
			return res

		if returnoverride[0] == "allocedstring":
			preturn = pstringtype
			res["preturn"] = preturn
			res["arritemt"] = preturn # ?
			res["arritemraw"] = pchartype(returnoverride[1])
			if returnoverride[1] == "": res["arritemraw"] = pchartype(fn["return"]) # fixme
			return res
		
		if returnoverride[0] == "errorcode":
			#  # 0 = error occured
			res["errorcode"] = returnoverride[1]
			return res
			
		if returnoverride[0] == "pointer":
			# fixme ! ( GtkIconTheme.lookup_icon, returns pointer, to be freed with gtk_icon_info_free)
			#res["preturn"] = "Pointer" # FIXME!!!
			return res
			
		if returnoverride[0] == "interface":
			if isInterface(preturn):
				pclass = classFromInterface(preturn)
				pclassconstruct = getClassConstruct(pclass)
				#pclassconstruct = pclass + ".GetOrCreateWrapped"
			else:
				print classname, "warning", "no interface return override for", fn["name"], "(", preturn , ")"

			res["pclassconstruct"] = pclassconstruct
			return res
			
	return res

def getFNListParamOverride(fn, index): # index 1 = 1st parameter
	global c2pfuncparamoverride
	global pextratypes
	global interfaceprefix
	global classprefix
	
	if fn["name"] in c2pfuncparamoverride:
		overridep = c2pfuncparamoverride[fn["name"]]
	else:
		overridep = None

	assert(index >= 1)
	if overridep != None and len(overridep) > index:
		poverride = overridep[index]
	else:
		poverride = None

	if poverride != None:
		return poverride
		#if poverride[0] == "var":
			#arritemt = c2ptype(returnoverride[1])
			
		#	return ["var"]

	return None

def isFNListReturnOverride(fn, insection = None):
	global c2pfuncparamoverride
	if fn["name"] in c2pfuncparamoverride:
		overridep = c2pfuncparamoverride[fn["name"]]
	else:
		overridep = None

	if overridep != None and len(overridep) >= 1:
		returnoverride = overridep[0]
	else:
		returnoverride = None

	if isInterface(fn["return"]):
		print "isinterface2??"
		return True

	if returnoverride != None:
			
		if returnoverride[0] == "array":
			if fn["return"] == "GList*" and (insection == None or insection.endswith("fromlist")):
				return True

			if fn["return"] == "gchar**" and (insection == None or insection.endswith("fromstrv")):
				return True

			if fn["return"] == "GSList*" and (insection == None or insection.endswith("fromslist")):
				return True

			#print fn["return"], "<->", returnoverride[1], "*"
			
			# TODO check insection too ?
			#(insection == None or insection.endswith("fromcarray")) and 
			if fn["return"] == returnoverride[1] and (insection == None or insection.endswith("arrayreturnfromcarray")):
				#print "isFNListReturnOverride", classname, returnoverride
				return True
			else:		
			#if fn["return"] == returnoverride[1] + "*" and (insection == None or insection.endswith("fromcarray")):
				if fn["return"] == returnoverride[1] + "*" and insection == None:
					return True
			
		if returnoverride[0] == "allocedstring":
			if (insection == None) or (insection.endswith("fromnewstring")):
				return True
				
		if returnoverride[0] == "interface":
			return True
			
		if returnoverride[0] == "errorcode":
			return True
			
	return False

def getInvalidArgs(fn, args):
	ix = 0
	droplist = []
	oargs = args
	while ix < len(args):
		fnover = getFNListParamOverride(fn, ix + 1)
			
		if fnover != None and len(fnover) > 0:
			if fnover[0].startswith("carrcount"):
				# skip array counter since delphi has that built-in
				#print "no count", fn
				droplist.append(ix)
			elif fnover[0] == "overlay":
				# some variable is hardcoded in the wrapper
				droplist.append(ix)

		ix = ix + 1


	#if args != oargs:
	#	print "OLD", oargs
	#	print "NEW", args
	
	return droplist
	
def isSignalMine(signalname):
	signals = getSignals()

	cimplementsinterfaces = getCImplementsInterfaces()

	if not isSignalOk(signalname):
		return False

	for intf, xclassdef in cimplementsinterfaces.items():
		if xclassdef == None: continue
		
		if signalname in xclassdef.signals:
			return False
	
	#if isInSignalMode():
	
	return True
	

def isSignalOk(signalname):
	return True

def signalarg_cb(varname, signalparam): # signalparam: "arg": (prefix+type,name); "signal": signal, "argno": 1+
	global csignalhandlerargtype2definemap
	global classname
	global classprefix
	argno = signalparam["argno"]
	arg = signalparam["arg"]
	if varname == "signalhandlerargno":
		return argno
	elif varname == "signalhandlerargnamecurrent":
		return "arg%d" % argno
	elif varname == "signalhandlerargtypecurrent":
		ty = arg[0]
		return ty.split(" ")[-1]
	elif varname == "signalhandlerargtypeasimplcurrent":
		if isInterface(arg[0]):
			return implementationClassForInterface(arg[0])
		else:
			return "not really"
			
	elif varname == "signalhandlerargoutputflagcurrent":
		argtype = arg[0]
		
		if argtype.startswith("var "):
			#print "Output Parameter", signalparam
			return "YES"
		else:
			return "NO"
		
	elif varname == "signalhandlerargtypecurrentdef":
		argtype = arg[0]
		argname = arg[1]
		
		if (argtype.startswith(classprefix + "GObject") or argtype.startswith("IGObject")):
			if argname == "Sender":
				return "SELF"
			else:
				return "OBJECT"
		else:
			try:
				return csignalhandlerargtype2definemap[argtype]
			except:
				print classname, "info: for signal", signalparam["signal"], "arg", arg
				raise
				
	#elif varname == "signalhandlerargnextcommand":
	#	signalparam["argno"] = signalparam["argno"] + 1 # hack
	#	return ""
	
	return signal_cb(varname, signal)
	
def signal_cb(varname, signal):
	global classname
	global classprefix
	global signalargno
	global pstringtype
	
	if varname == "gsignalname":
		return signal["name"]
	elif varname == "signalname":
		return c2psignalname(signal["name"])
	elif varname == "signalhandlertype":
		return callbackTypeOf(signal["name"])
	elif varname == "signalhandlerclass":
		return callbackTypeOf(signal["name"]) + "Handler"
	elif varname == "signalhandlerparams":
		return stringCallbackParamsOf(signal["name"])
	#elif varname.startswith("signalhandlerarg") and varname.endswith("type") and varname[-5] in string.digits:
	#	ps = callbackParamsOf(signal["name"])
	#	#print "PS", ps
	#	ctype = ps[signalargno-1][0]
	#	return ctype # fixme
	elif varname == "signalclass":
		#return "DCustomSignal"
		return signalTypeOf(signal["name"])
	elif varname == "signalhandlerargnames":
		ps = callbackParamsOf(signal["name"])
		
		return ", ".join(["arg%d" % (x + 1) for x in range(len(ps))])
	elif varname == "signalhandlerrestype":
		creturn = callbackReturnOf(signal["name"])
		if creturn == "void":
			return "Integer" # dummy
			
		return creturn
	elif varname == "signalhandlerprocfunc":
		creturn = callbackReturnOf(signal["name"])
		if creturn == "void":
			return "procedure"
		else:
			return "function"
	elif varname == "signalhandlerreturn":
		creturn = callbackReturnOf(signal["name"])
		if creturn == "void":
			return ""

		if creturn == "gchar*": # WTF! gtkscale format-value
			assert(classname == "GtkScale")
			return ": " + pstringtype
		elif creturn == pstringtype: # sigh
			return ": " + pstringtype 
		else:
			preturn = c2ptype(creturn, inreturn=True, canvar=False)

		return ": " + preturn
	elif varname == "signalhandlerrestypedef":
		# NONE for no return value
		# other values for the return value type.
		
		creturn = callbackReturnOf(signal["name"])
		if creturn == "void":
			return "NONE"
		else:
			return "SIMPLE"
	else:
		print classname, "warning", "unknown variable", varname

def getFNListParamDefault(fn, ix):
	global c2pfuncparamnullable
	global classname
	fnname = fn["name"]
	
	ix = ix - 1 # no return value pos in the array so shift by 1

	if fnname in c2pfuncparamnullable:
		dover = c2pfuncparamnullable[fnname]
		
		if dover != None and len(dover) > ix and dover[ix] != None:
			for i in range(len(dover) - 1, ix, -1):
				if dover[i] == None: # last parameter must be 
					if isDebug():
						print classname, "warning: cant apply defaults to function %s because not all following parameters are defaults" % fnname
					return None
			
			return dover[ix]
	
	return None
		
def getCfunctioncallparams(fn):
		global csettypes
		global wrapperprefix
		global poverridearraytypes
		global wrapperpointerprefix
		global c2penumcopied
		global enumprefix
		
		a = []
		args = fn["args"]
		if len(args) > 0 and args[-1][0] == "GError**":
			args = args[:-1]
		
		prevname = None
		ix = 0
		for argtyp, argname in fn["args"]:
			fnover = getFNListParamOverride(fn, ix + 1)
			
			if fnover != None and len(fnover) > 0 and fnover[0].startswith("carrcount"):
				if fnover[0] == "carrcountforward":
					# todo make that pretty
					nextname = fn["args"][ix + 1][1]
					a.append("Length(%s)" % nextname)
				else:
					a.append('Length(%s)' % prevname)
			elif fnover != None and len(fnover) > 0 and fnover[0] == "overlay":
				a.append(fnover[1])
			else:
				noat = False
				nocast = False
				if fnover != None and len(fnover) > 0:
					x = fnover[0]
					if x == "userdata":
						argname = "userdata"
					elif x.endswith("varargs"):
						argname = "avarargs" # TODO special handling
					elif x == "carray":
						noat = True
						y = fnover[1]
						if y in poverridearraytypes:
							argtyp = poverridearraytypes[y]
						else:
							nocast = True
												
				if argtyp != "GError**":
					pcompargtyp = c2ptype(argtyp)
				else:
					pcompargtyp = "wtf"

				pargtyp = c2ptypesmall(argtyp)
					
				o = pargtyp
				if pargtyp == wrapperpointerprefix + "const char": # gtk_label_set_text... sigh...
					pargtyp = "PChar"
					noat = True
					
				if pargtyp == wrapperpointerprefix + "const gchar":
					pargtyp = "PGChar"
					noat = True
					
				if pargtyp == wrapperprefix + "unsigned int": # gnome-canvas ... FIXME
					pargtyp = "guint"
					noat = True
					
				if pargtyp.startswith(wrapperpointerprefix + "const "): # Pconst GdkColor
					pargtyp = pargtyp[6 + len(wrapperpointerprefix):]
					
				if pargtyp == "Boolean":
					pargtyp = "gboolean"
					#LongBool"
					#Integer" # sigh
				
				if (argtyp.endswith("*") and argtyp.startswith("const ")) and not pargtyp.startswith("P"):
					# hack for const GdkColor *
					pargtyp = wrapperpointerprefix + pargtyp
					#print "hacky", pargtyp

				qual = ""
				
				#if pargtyp == "TGTypeArray":
				#	pargtyp = "glib2.TGTypeArray" # weird workaround
				#elif pargtyp == "TGIntArray":
				#	pargtyp = "glib2.TGIntArray" # weird workaround

				isinterface = False
				if pcompargtyp == None or not isInterface(pcompargtyp):
					if pargtyp == wrapperpointerprefix + "GError*":
						pargtyp = ""
						qual = "@"

					#pargtyp = ""
					if nocast == True:
						cast = "(%s%s%s)"
					else:
						if pargtyp.startswith(wrapperprefix):
							xargtyp = enumprefix + pargtyp[len(wrapperprefix):]
							if xargtyp in c2penumcopied: # use my copies of the enum. fixme or use integer.
								pargtyp = xargtyp
								
						if argtyp in csettypes:
							cast = "%s(%%s%%s%%s)" % (wrapperprefix + "CastSetType")
						else:
							cast = "%s(%%s%%s%%s)" % pargtyp
				else:
					isinterface = True
					#print "pcompargtyp", pcompargtyp
					cast = "%s%s%s.GetUnderlying"
					#GObject" 
					noat = True

				quale = ""

				#if pargtyp.find("Char") > -1:
				#	print classname, "warning", fn["name"], "parameter", argname, "type", pargtyp
				#	#print "NOAT", noat
				#	#print "o", o
				#	#if noat == False: assert(False)

				if pargtyp.startswith("P") or (argtyp.endswith("*") and argtyp.startswith("const ")): # const GdkColor *
					if noat == False:
						qual = "@"
					elif pargtyp == "PGChar":
						qual = "PChar("
						quale = ")"
					elif pargtyp == "PChar":
						if isDebug():
							print classname, "warning", fn["name"], "has PChar as parameter", argname
					#registerPointerType(pargtyp)

				if argtyp in c2pcallbackpointers:
					qual = "@"

				a.append(cast % (qual, argname, quale))
				
			prevname = argname
			ix = ix + 1

		try:
			if isMemberFN(fn):
				#ty = fn["args"][0][0]
				#if ty == classname + "*":
				#del a[0]
				a[0] = varreplace("pwrapped", None, None)
			elif isInterfaceImplementationFN(fn):
				a[0] = wrapperpointerprefix + getInterfaceOfImplementationFN(fn) + "(fObject)" # # hmm
		except:
			pass
			

		return a
			
def func_cb(varname, fn):
	global classname
	global cclassconstructparams
	global c2pfuncparamoverride
	global pextratypes
	global c2pcallbackpointers
	global preturntransformers
	global poverridearraytypes
	global wrapperpointerprefix
	global wrapperprefix
	global pstringtype
	global interfaceprefix
	if fn["name"] in c2pfuncparamoverride:
		overridep = c2pfuncparamoverride[fn["name"]]
	else:
		overridep = None
	
	if varname == "poverrideornot":
		if fn["name"].endswith("_sink"):
			return "override;"
		elif fn["name"] == "gtk_object_destroy":
			return "virtual;"
		
		return ""
	
	if varname == "pclassifier":
		if isMemberFN(fn) or isInterfaceImplementationFN(fn):
			return ""
		else:
			if isInInterfaceMode():
				return "//class"
			else:
				return "class"
	
	if varname == "preturntransformer":
		ret = func_cb("preturn", fn)
		
		if ret in preturntransformers:
			return preturntransformers[ret]
			
		if ret == "Single":
			return "" # workaround, fixme Lowlevel
		
		return ret
		
	if varname == "preturn":
		if fn["return"] == "gchar**":
			preturn = arrayTypeOf(pstringtype)
		else:
			preturn = c2ptype(fn["return"])
		
		if preturn != None:
			if preturn.startswith("var "):
				preturn = preturn[4:]
		
		if isFNListReturnOverride(fn):
			preturn = getFNListReturnOverride(fn)["preturn"]

		# support ICloneable interface by modding the return type to ICloneable
		# function Clone: ICloneable;
		## TODO parent supports ICloneable ?
		if fn["name"] == ("%s_copy" % uscclassname):
			assert(len(fn["args"]) == 1)
			rover = getFNListReturnOverride(fn)
			if rover != None and "kind" in rover and rover["kind"] == "interface":
				preturn = "ICloneable"
			else:
				print classname, "warning", fn["name"], "missing interface return override"

		return preturn

	if varname == "preturnerrorcode":
		if isFNListReturnOverride(fn):
			return getFNListReturnOverride(fn)["errorcode"]
		else:
			print classname, "warning", "no known error code for", fn["name"], "; Hint: use 'errorcode' return override"
			return "?"

	if varname == "preturnitemrawtype":
		if not isFNListReturnOverride(fn):
			print classname, "error", "no list return overide for", fn["name"], "(preturnitemrawtype)"
			
		arritemt = getFNListReturnOverride(fn)["arritemt"]
		if arritemt.startswith(interfaceprefix):
			nativetype = wrapperpointerprefix + arritemt[len(interfaceprefix):]
		elif arritemt == "TGtkAccelGroupEntry": # var ?
			nativetype = wrapperpointerprefix + arritemt[1:] # cough.
			#print "nativetype", nativetype
		elif arritemt == pstringtype: #"UTF8String": # or so
			try:
				nativetype = getFNListReturnOverride(fn)["arritemraw"]
			except:
				nativetype = "PChar"
				print classname, "warning, no nativetype for return value of function ", fn["name"], "assuming PChar"
				
			#"PChar"
			if nativetype == "?":
				print classname, "error", fn["name"], "have", nativetype, "for", arritemt
		else:
			print classname, "error, cannot find nativetype for ", arritemt, "for function", fn["name"]
			
		#print "native", nativetype
		return nativetype
		
	if varname == "wrapperexpectedtype":
		arritemt = getFNListReturnOverride(fn)["arritemt"]
		if arritemt.startswith(interfaceprefix):
			return wrapperpointerprefix + "GObject" # FIXME others
			
		if classname == "GtkAccelGroup" and arritemt == "TGtkAccelGroupEntry":
			#print arritemt #== "GtkAccelGroupEntry*" and 
			#print "YES"
			return "gtkAccelGroupEntryFromPointer"
		
		#if classname == "GtkAccelGroup": # FIXME do that somewhere else (*fromcarray)
		#	if arritemt.startswith(classprefix):
		#		return wrapperpointerprefix + arritemt[len(classprefix):]
			
		return ""

	if varname == "preturnitemtype":
		if (c2pfnname(fn["name"]) == "Clone"):
			arritemt = interfaceprefix + "Cloneable"
		else:
			arritemt = getFNListReturnOverride(fn)["arritemt"]
		
		if isInterface(arritemt):
			needInterface(arritemt)
			needImplementationUnitForClass(implementationClassForInterface(arritemt))
		
		return arritemt
		
	if varname == "preturnitemtypeas":
		res = func_cb("preturnitemtype", fn)
		if isInterface(res) or isImplementationClass(res):
			return " as %s" % res
		else:
			return ""

	if varname == "preturnlistfinalizer":
		return getFNListReturnOverride(fn)["pendfree"]
		
	if varname == "preturnperitempreaction":
		try:
			return getFNListReturnOverride(fn)["pforeach"]
		except:
			print classname, "error", fn["name"], "pforeach not found in config"
			raise
			
		return pforeach
		
	if varname == "pfreeforeachitem":
		return getFNListReturnOverride(fn)["pforeachfree"]
	
	if varname == "preturnitemclassname":
		return getFNListReturnOverride(fn)["pclassconstruct"]
	
	if varname == "pfunction":
		return c2pfnname(fn["name"])

	if varname == "cfunction":
		return fn["name"]
		
	if varname == "pfunctionparams":
		a = []
		args = fn["args"]
		invalidlist = getInvalidArgs(fn, args)

		ixo = 0
		if isMemberFN(fn) or isInterfaceImplementationFN(fn):
			#if len(args) > 0 and args[0][0].lower() == classname.lower() + "*": 

			args = args[1:] # skip instance param
			ixo = -1

		if len(args) > 0 and args[-1][0] == "GError**":
			args = args[:-1]

		#print args[0][0]
		ix = 1-ixo
		for argtyp, argname in args:
			canvar = False
			fnover = getFNListParamOverride(fn, ix)
			adefault = getFNListParamDefault(fn, ix)
			
			ptypeover = None
			if fnover != None and len(fnover) > 0:
				c = fnover[0]
				try:
					t = fnover[1]
					it = c2ptype(t)
					#if isEnum(it):
					if it.startswith("T"): # FIXME! after conv
						it = it[1:]
				except:
					t = None
					it = None

				if c == "type":
					ptypeover = t
					
				if c == "varany":
					ptypeover = "var "
					
				if c == "forceinstring": # for "gchar*" instead of "const gchar*" bug (gtk_paint_shadow_gap)
					ptypeover = pstringtype
				
				if c == "pointer":
					#print "pointer", fn
					ptypeover = "Pointer"

				if c == "ccallback":
					# TODO
					pass
										
				if c == "userdata":
					ptypeover = "Pointer" # fixme
					argname = "userdata"

				if c == "tvarargs":
					ptypeover = "const TVarrecArray"
					argname = "avarargs"
					
				if c == "varargs":
					ptypeover = "array of const"
					argname = "avarargs"
					
				if c == "array":					
					ptypeover = "T%sArray" % it
					
				if c == "carray":
					ptypeover = "T%sArray" % it
				if c == "varcarray":
					ptypeover = "var T%sArray" % it
					
				if c == "const":
					ptype = c2ptype(argtyp, False, canvar)
					if ptype.startswith("var "):
						ptypeover = "const " + ptype[4:]
					else:
						print classname, "warning", fn["name"], "parameter is overridden const but was not originally var"

				if c == "out":
					ptype = c2ptype(argtyp, False, canvar)
					if ptype.startswith("var "):
						ptypeover = "out " + ptype[4:]
					else:
						print classname, "warning", fn["name"], "parameter is overridden const but was not originally var"
					
			if ptypeover != None:
				ptype = ptypeover
			else:
				try:
					ptype = c2ptype(argtyp, False, canvar)
				except:
					print classname, "info: while doing", fn
					raise
				
			pname = argname
			
			if ptype == None:
				print classname, "info: while doing", fn
			
			# TODO var
			
			if ptype == "TGTypeArray":
				ptype = "ugtypes.TGTypeArray" # weird workaround
			#elif ptype == "TGIntArray":
			#	pargtyp = "ugtype.TGIntArray", # weird workaround

			
			if ptype != None and ptype.startswith("var "):
				ptype = ptype[4:]
				if ptype == "":
					a.append("var %s" % pname)
				else:
					a.append("var %s: %s" % (pname, ptype))
			elif ptype != None and ptype.startswith("const "):
				ptype = ptype[6:]
				a.append("const %s: %s" % (pname, ptype))
			elif ptype != None and ptype.startswith("out "):
				ptype = ptype[4:]
				a.append("out %s: %s" % (pname, ptype))
			else:			
				a.append("%s: %s" % (pname, ptype))
				
			if isDebug() and ptypeover != None:
				print "overridden", a

			if adefault != None:
				a[-1] = a[-1] + " = " + adefault
				
			ix = ix + 1

		offs = - ixo
		for item in invalidlist:
			ix = item - offs
			try:
				a = a[:ix] + a[ix+1:]
			except:
				print "??!"
				pass
			offs = offs + 1

			
		return ";".join(a)
		
	if varname == "cfunctioncallparams":
		a = getCfunctioncallparams(fn)
		# TODO @
		return ",".join(a)

	print varname
	return None

def maybeUserdata():
	global ascendentants
	if "GObject" in ascendentants:
		return ["GUserData"]
		
	return []
			
def maybeCloneable():
	global uscclassname
	global classname
	global ascendentants
	fns = getFns()
	ifaces = []
	if ("%s_copy" % uscclassname) in fns:
		ifaces.append("Cloneable")
		
	if ("%s_get_model" % uscclassname) in fns:
		if ("%s_set_model" % uscclassname) not in fns:
			print classname, "warning: not both model set/get functions are present"
			print classname, "info: not supporting IGtkTreeModelUser interface"
		else:
			ifaces.append("GtkTreeModelUser")
	
	# todo also support that is a ascendendant has _destroy!
		
	if ("%s_destroy" % uscclassname) in fns:
		ifaces.append("Disposable")

	if "GtkObject" in ascendentants:
		if "Disposable" not in ifaces:
			ifaces.append("Disposable")

	return ifaces
		
def processSection(ofile, insection, seclines):
	global uscclassname
	fns = getFns()
	props = getProps()

	if insection.startswith("publicfunction") or insection.startswith("publicprocedure"):
			
		for fnname, fn in fns.items():
			#printseclines = False
			if fnname.endswith("_new"): continue
			if fnname.endswith("_get_type"): continue
			if fnname.find("_new") > -1: continue
			
			if fnname == ("%s_copy" % uscclassname) and isInInterfaceMode(): continue # this is in ICloneable
			if fnname == ("%s_destroy" % uscclassname) and isInInterfaceMode(): continue # this is in IDisposable
			
			if fnname in ["%s_set_model" % uscclassname, "%s_get_model" % uscclassname] and isInInterfaceMode():
				if (("%s_set_model" % uscclassname) in fns) and (("%s_get_model" % uscclassname) in fns):
					continue # this is in IGtkTreeModelUser
			
			if insection.endswith("witherror") and not isFNWithGError(fn): continue
			if insection.endswith("withouterror") and isFNWithGError(fn): continue
			
			if insection.endswith("arrayreturnfromcarray"):
				if isFNWithGError(fn) or not isFNListReturnOverride(fn, insection): continue
				
				#print "still alive" reached for gtk_accel_group_query DEBUG
					
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "array": continue
				if isDebug():
					print "arrayreturnfromcarray!", fn["name"]
				#printseclines = True
			elif insection.endswith("arrayreturnfromlist"):
				if isFNWithGError(fn) or not isFNListReturnOverride(fn, insection): continue
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "array": continue
				if isDebug():
					print "arrayreturnfromlist", fn["name"]
			elif insection.endswith("arrayreturnfromslist"):
				if isFNWithGError(fn) or not isFNListReturnOverride(fn, insection): continue
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "array": continue
				if isDebug():
					print "arrayreturnfromslist", fn["name"]
			elif insection.endswith("arrayreturnfromstrv"):
				if isFNWithGError(fn) or not isFNListReturnOverride(fn, insection): continue
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "array": continue
				if isDebug():
					print "arrayreturnfromstrv", fn["name"]
			elif insection.endswith("returnfromnewstring"):
				if not isFNListReturnOverride(fn, insection): continue
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "allocedstring": continue
			elif insection.endswith("interfacereturncreate"):
				if not isFNListReturnOverride(fn, insection): continue
				kind = getFNListReturnOverride(fn)["kind"]
				if kind != "interface":
					continue
			elif insection.endswith("witherror"):
				pass  ## process it
			elif insection != "publicfunction" and insection != "publicprocedure":
				if isFNListReturnOverride(fn):
					continue
			
			#if fn["name"].startswith("gtk_editable_get_"):
			#	print "YES!", fn["name"]
			
			processSecLines(ofile, seclines, func_cb, fn, insection)

	if insection == "signal":
		signals = getSignals()
		for signalname, signal in signals.items():
			global signalargno
			signalargno = 1
			if isSignalOk(signalname) and ((isInSignalMode() and isSignalMine(signalname)) or (not isInSignalMode())):
				xsignal = { "name": signalname, "cproto": signal }
				processSecLines1(ofile, seclines, signal_cb, xsignal, insection)

	if insection == "constructable":
		global cclassconstructparams
		if not (classname in cclassconstructparams and cclassconstructparams[classname] == None):
			processSecLines(ofile, seclines, None, None, insection)
		
	if insection == "property":
		for pname, prop in props.items():
			if isPropKnown(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection == "propertyunknown":
		for pname, prop in props.items():
			if not isPropKnown(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)
		
	if insection in [ "propertyread", "propertyreadboxed" ]:
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropReadable(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection in [ "propertywrite", "propertywriteboxed" ]:
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropWriteable(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection == "propertyreadonly":
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropReadable(pname) and not isPropWriteable(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection == "propertywriteonly":
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropWriteable(pname) and not isPropReadable(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection == "propertyreadwrite":
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropReadable(pname) and isPropWriteable(pname):
				processSecLines(ofile, seclines, prop_cb, prop, insection)

	if insection == "propertyunwrappedread":
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropReadable(pname) and needPropUnwrapped(pname):
				processSecLines(ofile, seclines, propunwrapped_cb, prop, insection)

	if insection == "propertyunwrappedwrite":
		for pname, prop in props.items():
			if isPropKnown(pname) and isPropWriteable(pname) and needPropUnwrapped(pname):
				processSecLines(ofile, seclines, propunwrapped_cb, prop, insection)

