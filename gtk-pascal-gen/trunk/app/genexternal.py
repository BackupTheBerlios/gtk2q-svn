#!/usr/bin/env python

from tool2 import fnsFromFNLines

path1 = "pango"
############ add external declarations ###############

fnlib = path1.replace("-", "") + "lib"

lines = file("/tmp/E", "r").readlines()

fns = fnsFromFNLines(lines)

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
