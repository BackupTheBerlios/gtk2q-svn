#!/usr/bin/env python

import sys
import exceptions
import os

from tool2 import *
import codecs

#fname = sys.argv[1]
#lines = sys.stdin.readlines()
comments = []
usedinterfaces = []
interfaceaddlines = []
usedclasses = []
pextratypes = {}
pextraconsts = []
pexternfuncs = []
#cimplementsinterfaces = [] -> dings
ofimode = False
ofsmode = False

global classname
# classname = sys.argv[2] # moved to tool2 for some reason
pnativeclasspointername = wrapperpointerprefix + classname
pwrapped = "%s(Fobject)" % pnativeclasspointername

gtkpascalgen_indir = os.environ["gtkpascalgen_indir"]

uscclassname = uscclassnameOfClassname(classname)

#uscclassname = classname

path1 = sys.argv[3]

fnlines = []

lines = codecs.open("./deprecated.txt", "r", "UTF-8").readlines()
for line in lines:
	line = line.strip()
	
	if not line in cskipfuncs:
		cskipfuncs.append(line)

def willFNVanish(fnname):
	global cskipfuncs
	return fnname in cskipfuncs

def openDescFile(name, autoext = True):
	global gtkpascalgen_indir
	global path1
	if autoext == True:
		xname = name + ".xml"
	else:
		xname = name
		
	try:
		return codecs.open(gtkpascalgen_indir + "/input/%s/%s" % (path1, xname), "r", "UTF-8")
	except exceptions.IOError, e:
		return codecs.open(gtkpascalgen_indir + "/overrides/%s/%s" % (path1, xname), "r", "UTF-8")

try:
	setIVersion(openDescFile("version.txt", False).readlines()[0].strip())
except:
	raise
	pass
	
classdef = ClassDefinition()
classdef.classname = classname
parseFile(openDescFile(os.path.basename(sys.argv[4]).replace(".xml", "")), classdef)

if classname == "GdkPixbuf": # special case, hack
	parseFile(openDescFile("util"), classdef)
	parseFile(openDescFile("scaling"), classdef)
	parseFile(openDescFile("file-loading"), classdef)
	parseFile(openDescFile("file-saving"), classdef)
	pass

#classname = classdef.classname
#setSignals(classdef.signals) below
#setProps(classdef.props) below
#fns = classdef.fns
setCImplementsInterfaces(classdef.cimplementsinterfaces)
ascendentants = classdef.ascendentants

########### merge interface implementation signals and functions into main class ########

for iname in classdef.cimplementsinterfaces.keys():
	if iname == "AtkImplementorIface": continue # fixme
		
	#print iname, "found"
	try:
		xclassdef = ClassDefinition()
		parseFile(openDescFile(iname.lower()), xclassdef)
	except exceptions.IOError, e:
		print classname, "warning! interface not found: %s" % iname
		continue
		
	classdef.cimplementsinterfaces[iname] = xclassdef
		
	### merge functions into main class ###
	for fnname, v in xclassdef.fns.items():
		if fnname.startswith(uscclassnameOfClassname(iname) + "_"):
			sk = uscclassnameOfClassname(classname) + "_" + fnname[len(uscclassnameOfClassname(iname)) + 1:]
			#print "check", sk
			# skip gtk_cell_layout_pack_start if there is a gtk_tree_view_column_pack_start
			# should check parameters too but I dont for now.
			if (sk in classdef.fns) and not willFNVanish(sk):
				if isDebug():
					print classname, "info: skipping %s in favor of %s" % (fnname, sk)
				continue
			
		classdef.fns[fnname] = v

	### merge properties into main class ###
	for pname, pdef in xclassdef.props.items():
		if pname not in classdef.props:
			classdef.props[pname] = pdef
				
	### merge signals into main class ###
	for sname, sdef in xclassdef.signals.items():
		#print "  " + sname
		if sname not in signals:
			### merge signal into main class ###
			#print classname, "error", sname, "is also found in main class (in addition to %s)" % iname
			classdef.signals[sname] = sdef
			#print "=>", iname, sname
				
setSignals(classdef.signals)
setProps(classdef.props)

setCImplementsInterfaces(classdef.cimplementsinterfaces)
		
setFns(classdef.fns)
fns = classdef.fns

if classname.lower() == "gdkpixbuf":
	if "gdk_pixbuf_new" not in fns:
		dummyname, fns["gdk_pixbuf_new"] = parseFN("GdkPixbuf* gdk_pixbuf_new (GdkColorspace colorspace,gboolean has_alpha,int bits_per_sample,int width,int height);")

	if "gdk_pixbuf_new_from_inline" not in fns:
		dummyname, fns["gdk_pixbuf_new_from_inline"] = parseFN(
		"""GdkPixbuf* gdk_pixbuf_new_from_inline	(gint          data_length,
					 const guint8 *data,
					 gboolean      copy_pixels,
					 GError      **error);
		""")
	
	if "gdk_pixbuf_new_subpixbuf" not in fns:
		dummyname, fns["gdk_pixbuf_new_subpixbuf"] = parseFN(
		"""GdkPixbuf* gdk_pixbuf_new_subpixbuf(GdkPixbuf *src_pixbuf,
		int        src_x,
		int        src_y,
		int        width,
		int        height);
		""")
	
	f1 = """
void        gdk_pixbuf_render_pixmap_and_mask
                                            (GdkPixbuf *pixbuf,
                                             GdkPixmap **pixmap_return,
                                             GdkBitmap **mask_return,
                                             int alpha_threshold);

	"""
	dummyname, fns["gdk_pixbuf_render_pixmap_and_mask"] = parseFN(f1)
	
	f2 = """
void        gdk_pixbuf_render_pixmap_and_mask_for_colormap
                                            (GdkPixbuf *pixbuf,
                                             GdkColormap *colormap,
                                             GdkPixmap **pixmap_return,
                                             GdkBitmap **mask_return,
                                             int alpha_threshold);
	"""
	dummyname, fns["gdk_pixbuf_render_pixmap_and_mask_for_colormap"] = parseFN(f2)

	f3 = """
void        gdk_pixbuf_render_threshold_alpha
                                            (GdkPixbuf *pixbuf,
                                             GdkBitmap *bitmap,
                                             int src_x,
                                             int src_y,
                                             int dest_x,
                                             int dest_y,
                                             int width,
                                             int height,
                                             int alpha_threshold);
	"""
	dummyname, fns["gdk_pixbuf_render_threshold_alpha"] = parseFN(f3)
	
#if classname.lower() == "gtktipsquery" and "gtk_tips_query_new" not in fns:
#	dummyname, fns["gtk_tips_query_new"] = parseFN("GtkWidget* gtk_tips_query_new (void);")

#print "isinterfaceclass", isinterfaceclass
#print "classname", classname
#for fnname, fn in fns.items():
#	if isMemberFN(fn):
#		print fn
#print "asc", ascendentants
#print "props", props

pclassname = pclassnameOf(classname)

gtkpascalgen_outdir = os.environ["gtkpascalgen_outdir"]	

punit = "u" + pclassname[1:].lower() # implementation unit
piunit = "iu" + pclassname[1:].lower() # interface unit
psunit = "s" + pclassname[1:].lower() # signal proxy unit
ofname = gtkpascalgen_outdir + "/output/" + path1 + "/" + punit + ".pas"
ofiname = gtkpascalgen_outdir + "/output/" + path1 + "/" + piunit + ".inc"
ofsname = gtkpascalgen_outdir + "/output/" + path1 + "/" + psunit + ".pas"
if pclassname in pusedclasses:
	for a in pusedclasses[pclassname]:
		if a == "variants":
			addExtraUses(a)
		elif a.startswith(interfaceprefix):
			if a not in usedinterfaces:
				usedinterfaces.append(a)
		else:
			if a not in usedclasses:
				usedclasses.append(a)

for iface in classdef.cimplementsinterfaces:
	piface = interfaceprefix + iface
	#print "PIFACE", piface
	if piface not in usedinterfaces:
		usedinterfaces.append(piface)
		#print "ADD", piface

#if not piunit.endswith("igtkimage"): sys.exit(0)  

########## get rid of unwanted functions ##################

for fnname in cskipfuncs:
	if fnname in fns:
		if fnname not in forceexternals: # exception for the external declarations. fixed up later without that.
			del fns[fnname]

for fnname in fns.keys():
	if fnname.endswith("_class_find_style_property") \
	or fnname.endswith("_class_find_child_property") \
	or fnname.endswith("_class_install_child_property") \
	or fnname.endswith("_class_install_style_property") \
	or fnname.endswith("_class_install_style_property_parser"):
		del fns[fnname] 

############ add external declarations ###############

fnlib = path1.replace("-", "") + "lib"

for fnname, fn in fns.items():
	if fn["return"] != "void" and fn["return"] != None:
		ftype = "function"
		fnreturn = ": " + exttype(fn["return"], True)
	else:
		ftype = "procedure"
		fnreturn = ""
	
	global c2pfuncparamoverride
	if fnname in c2pfuncparamoverride:
		over = c2pfuncparamoverride[fnname]
	else:
		over = None
		
	fnparams = []
	ix = 1
	for arg in fn["args"]:
		ty = arg[0]
		na = arg[1]
		
		if na == "string": na = "astring"
		
		if na == "...":
			ty = "array of const"
			na = "additional"
		else:	
			ty = exttype(ty, False)
			
		try:
			overi = over[ix]
		except:
			overi = None
			
		if fnname == "gtk_label_new" and ix == 1: # sigh
			ty = "PGChar"
			
		if overi != None and overi[0] == "carray":
			typarts = ty.split(" ")
			rty = typarts[-1]

			if rty.startswith(wrapperpointerprefix):
				rty = wrapperprefix + rty[len(wrapperpointerprefix):] + "Array"
				typarts[-1] = rty
				ty = " ".join(typarts)

			if isDebug(): # or not isDebug():
				print classname, "debug", fnname, "carray debug", rty, "type thinks"
		
		cf = ""
		if ty.startswith("const "):
			ty = ty[6:]
			cf = "const "
			
		if na.endswith("[6]") and (path1 in ["gnome-canvas", "diacanvas"]): # gnome-canvas affine transformation
			na = na[:-3]
			ty = "TAffineTransform"
		
		fnparams.append("%s%s: %s" % (cf, na, ty))
		ix = ix + 1

	fnelib = fnlib
	if fnname in [
		"gdk_pixbuf_render_threshold_alpha",
		"gdk_pixbuf_render_to_drawable",
		"gdk_pixbuf_render_to_drawable_alpha",
		"gdk_pixbuf_render_pixmap_and_mask",
		"gdk_pixbuf_render_pixmap_and_mask_for_colormap",
		"gdk_pixbuf_get_from_drawable",
		"gdk_pixbuf_get_from_image",
	]:
		fnelib = "gdklib"
	
	s = "%s %s(%s)%s; cdecl; external %s;" % (ftype, fnname, ";".join(fnparams),  fnreturn, fnelib)
	pexternfuncs.append(s)

gettypef = "%s_get_type" % uscclassname
if (classname in paddexternalgettype) and not (gettypef in fns):
		ftype = "function"
		fnname = gettypef
		fnparams = ""
		fnreturn = ": TGType"
		#fnlib =  # unchanged
		s = "%s %s(%s)%s; cdecl; external %s;" % (ftype, fnname, ";".join(fnparams),  fnreturn, fnlib)
		pexternfuncs.append(s)

if classname == "GdkGC":
	getvaluesf = "%s_get_values" % uscclassname
	if not (getvaluesf in fns):
		ftype = "procedure"
		fnname = getvaluesf
		fnparams = ["gc: PWGdkGc", "gcvalues: PWGdkGcValues"]
		fnreturn = ""
		#fnlib =  # unchanged
		s = "%s %s(%s)%s; cdecl; external %s;" % (ftype, fnname, ";".join(fnparams),  fnreturn, fnlib)
		pexternfuncs.append(s)

# after the externals are done, get rid of unwanted functions that have been excepted before
for fnname in cskipfuncs:
	if fnname in fns:
		del fns[fnname]

########## get rid of accessor functions that have a property too ########

cfnprops = {}
props = getProps()
for k, v in props.items():
	cfnprops[cproptocfn(k)] = v
	cfnprops[cproptocfn(k)]["name"] = k

pafns = {} # property accessor functions


for fnname, fn in fns.items():
	i = fnname.find("_set_")
	j = -1
	k = -1
	if i == -1: i = fnname.find("_get_")
	if i == -1: j = fnname.find("_is_")
	if j == -1: k = fnname.find("_has_")
	if i > -1 or j > -1 or k > -1:
		# is a accessor function (probably)
		
		if i != -1:
			i = i + len("_set_") # or, _get_
			cpfn = fnname[i:]
		elif j != -1:
			cpfn = fnname[j + len("_"):]
		elif k != -1:
			cpfn = fnname[k + len("_"):]
		
		if cpfn in cfnprops:
			pafns[fnname] = fn
			
			if doesInterfaceRequireFN(fn): # cannot remove. required. sigh.
				if isDebug():
					print "leaving accessor function %s in although there is a property for it, to adhere the interface" % fnname

				continue
			
			del fns[fnname]
			
			v = cfnprops[cpfn]
			if isDebug():
				print "skipping accessor function %s in favor of property %s" % (fnname, v["name"])

#for k, v in signals.items():
#	#The &quot;closed&quot; signal
#	print k, ":", v
	
for signalname in signals.keys():
	if signalname.startswith("GtkFileChooserDefault::"): # fixme
		del signals[signalname]
		continue
		

