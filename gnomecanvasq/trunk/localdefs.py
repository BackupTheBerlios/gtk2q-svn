#!/usr/bin/env python

# pstringtype = "UTF8String"
# classprefix = "T"
# enumprefix = "T"
# interfaceprefix = "I"
# interfaceunitprefix = "iu"
# classunitprefix = "u"
# wrapperpointerprefix = "PW"
# wrapperprefix = "W"

# type to use for storing the return value of Object Property Accessors
ptype1 = {
}

# hash of class -> uses clause additions (interface or implementation class name):
#    (interface names are added at the unit interface section)
#    (implementation class names are added at the unit implementation section)
pusedclasses = { # from class implementation: list of classes used (implementation 'uses' clause for classes, interface 'uses' clause for interfaces)
	"TGnomeCanvas": ["IGtkObject", "TGnomeCanvasGroup"],
	"TGnomeCanvasBpath": ["IGtkObject"],
	"TGnomeCanvasClipgroup": ["IGtkObject"],
	"TGnomeCanvasGroup": ["IGtkObject"],
	"TGnomeCanvasItem": ["IGtkObject", "IGdkCursor"],
	"TGnomeCanvasShape": ["IGtkObject"],
	"TGnomeCanvasRe": ["IGtkObject"],
	"TGnomeCanvasEllipse": ["IGtkObject"],
	"TGnomeCanvasRect": ["IGtkObject"],
	"TGnomeCanvasLine": ["IGtkObject"],
	"TGnomeCanvasPixbuf": ["IGtkObject"],
	"TGnomeCanvasPolygon": ["IGtkObject"],
	"TGnomeCanvasRichText": ["IGtkObject"],
	"TGnomeCanvasText": ["IGtkObject"],
        #"DGnomeCanvasXXX": ["IGtkObject"],
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
	"TGnomeCanvasItem": ["TGdkEvent"],
	"TGnomeCanvas": ["IGnomeCanvasBuf"],
}

# signal units uses clause, used classes for implementation section
psignalusediocimpl = {
	"TGnomeCanvas": ["TGnomeCanvasBuf"], 
}

# these are array types that are to be automagically casted to the right type 
# when calling the wrapped function in the wrapper (to prevent array mismatch)
# add only when you get an array type mismatch.
# add C type name as given in the array override as [1]
poverridearraytypes = {
}

# hash of transformers for preturn, given that they arent obvious.
# examples for required manual transformers are:
#   - pointer to (structure or exception) transformer
preturntransformers = {
}

# list of classes that are not gobject (usually pointermediators) but are wrappers
nongobjectclasses = [
	"TGnomeCanvasPoints",
	"TGnomeCanvasPathDef",
]

# maps from interface name to interface unit name for special cases
interfaceunitoverride = {
	"IGnomeCanvasBuf": "iugnomecanvasbuf",
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
        "GnomeCanvas",
        "GnomeCanvasBpath",
        "GnomeCanvasClipgroup",
        "GnomeCanvasEllipse",  
        "GnomeCanvasGroup",    
        "GnomeCanvasItem",     
        "GnomeCanvasLine",     
        "GnomeCanvasPathDef",  
        "GnomeCanvasPixbuf",   
        "GnomeCanvasPoints",   
        "GnomeCanvasPolygon",  
        "GnomeCanvasRE",
        "GnomeCanvasRect",
        "GnomeCanvasRichText",
        "GnomeCanvasShape",   
        "GnomeCanvasText",    
        "GnomeCanvasWidget",  
]

# list of parameters that are used as 'const ...*' uselessly (from a pascal point of view)
c2pconstpointerparam = [ # 'const GdkColor*' as parameter
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
        ## GnomeCanvas cclassconstructparams
        "GnomeCanvasBpath": None, # not constructable it seems
        "GnomeCanvasClipgroup": None, # not constructable it seems
        "GnomeCanvasEllipse": None, # manual constructor
        "GnomeCanvasGroup": "nil",
        "GnomeCanvasItem": None, # not constructable. base type.
        "GnomeCanvasPolygon": None, # manual constructor
        "GnomeCanvasRE": None, # rect/ellipse base class
        "GnomeCanvasRect": None, # manual constructor
        "GnomeCanvasRichText": None, # manual constructor
        "GnomeCanvasShape": None, # not constructable it seems
        "GnomeCanvasText": None, # manual constructor
        "GnomeCanvasWidget": None, # not constructable it seems
        "GnomeCanvasLine": None, # manual constructor
        "GnomeCanvasPixbuf": None, # manual constructor
}

# direct type mapping
# contains type mappings for primitive types, for use in the interfaces
# be careful with that.
c2ptypehash = {
}

c2penumcopied = [ # enums copied to delphi as-is
]

# structs copied from gtk to the wrapped (into unit u...types) 
c2pstructcopied = { # simple structs copied to delphi as-is
}

# class (not instance) functions to get from C
c2pclassfunctions = { 
}

cskipsignals = [
]

# properties that are to be skipped and not be wrapped (f.e. deprecated properties)
cskipprops = [
]

# externals to force
forceexternals = [
        ## GnomeCanvas forceexternals
        "gnome_canvas_item_i2w_affine", # manually
        "gnome_canvas_item_i2c_affine", # manually
        "gnome_canvas_item_w2i", # manually
        "gnome_canvas_item_i2w", # manually
        "gnome_canvas_item_affine_absolute", # manually
        "gnome_canvas_item_affine_relative", # manually
        "gnome_canvas_w2c_affine", # manually
        "gnome_canvas_w2c", # manually
        "gnome_canvas_w2c_d", # manually
        "gnome_canvas_c2w", # manually
        "gnome_canvas_get_scroll_offsets", # manually
        "gnome_canvas_root", # manually
]

paddmembervars = {
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
	## GnomeCanvas
	"GnomeCanvasItem": {
		"GetItemToWorldAffine": """
			published function GetItemToWorldAffine: TAffineTransform;
			begin
			  gnome_canvas_item_i2w_affine(PGnomeCanvasItem(Fobject), Result);
			end;
		""",
		"GetItemToCanvasPixelAffine": """
			published function GetItemToCanvasPixelAffine: TAffineTransform;
			begin
			  gnome_canvas_item_i2c_affine(PGnomeCanvasItem(Fobject), Result);
			end;
		""",
		"WorldToItemCoords": """
			published function WorldToItemCoords(const source: DArtPoint): DArtPoint;
			begin
			  Result.x := source.x;
			  Result.y := source.y;
			  gnome_canvas_item_w2i(PGnomeCanvasItem(Fobject), @Result.x, @Result.y);
			end;
		""",
		"ItemToWorldCoords": """
			published function ItemToWorldCoords(const source: DArtPoint): DArtPoint;
			begin
			  Result.x := source.x;
			  Result.y := source.y;
			  gnome_canvas_item_i2w(PGnomeCanvasItem(Fobject), @Result.x, @Result.y);
			end;
		""",
		"SetAffine": """
			published procedure SetAffine(const affine: TAffineTransform);
			begin
			  gnome_canvas_item_affine_absolute(PGnomeCanvasItem(Fobject), affine);
			end;
		""",
		"ModAffineRelative": """
			published procedure ModAffineRelative(const affine: TAffineTransform);
			begin
			  gnome_canvas_item_affine_relative(PGnomeCanvasItem(Fobject), affine);
			end;
		""",
	},
	"GnomeCanvas": {
		"GetRoot": """
			protected function GetRoot: IGnomeCanvasGroup;
			var
			  cgroup: PGnomeCanvasGroup;
			begin
			  cgroup := gnome_canvas_root(PGnomeCanvas(Fobject));
			  assert(Assigned(cgroup));
			  Result := WrapGObject(cgroup, TGnomeCanvasGroup) as IGnomeCanvasGroup;
			end;
		""",
		"GetWorldToCanvasAffine": """
			published function GetWorldToCanvasAffine: TAffineTransform;
			begin
			  gnome_canvas_w2c_affine(PGnomeCanvas(Fobject), Result);
			end;
		""",
		"WorldToCanvasCoords": """
			published function WorldToCanvasCoords(const source: DArtPoint): DArtPoint;
			var
			  cx,cy: Double;
			begin
			  gnome_canvas_w2c_d(PGnomeCanvas(Fobject), source.x, source.y, @cx, @cy);
			  Result.x := cx;
			  Result.y := cy;
			end;
		""",
		"CanvasToWorldCoords": """
			published function CanvasToWorldCoords(x,y: Integer): DArtPoint;
			var
			  wx,wy: Double;
			begin
			  gnome_canvas_c2w(PGnomeCanvas(Fobject), x,y, @wx, @wy);
			  Result.x := wx;
			  Result.y := wy;
			end;
		""",
		"GetScrollOffsets": """
			published procedure GetScrollOffsets(out cx,cy: Integer);
			begin
			  gnome_canvas_get_scroll_offsets(PGnomeCanvas(Fobject), @cx, @cy);
			end;
		""",
	},
	#"GnomeCanvasGroup": {
	#	"Create": """
	#		public constructor Create(parent: IGnomeCanvasGroup);
	#		begin
	#		  assert(Assigned(parent));
	#		  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
	#		  gnome_canvas_group_get_type, nil));
	#		end;
	#	"""
	#},
	"GnomeCanvasRect": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_rect_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasText": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_text_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasRichText": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_rich_text_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasEllipse": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_ellipse_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasPolygon": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_polygon_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasLine": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_line_get_type, nil));
			end;
		"""
	},
	"GnomeCanvasPixbuf": {
		"Create": """
			public constructor Create(parent: IGnomeCanvasGroup);
			begin
			  assert(Assigned(parent));
			  setWrapped(gnome_canvas_item_new(parent.GetUnderlying,
			  gnome_canvas_pixbuf_get_type, nil));
			end;
		"""
	},
	
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
	## GnomeCanvas
	"GnomeCanvas": {
		"Root": "published property Root: IGnomeCanvasGroup read GetRoot;",   
	},
}

# functions to be skipped and not be wrapped
cskipfuncs = [
	## GnomeCanvas cskipfuncs
	"gnome_canvas_item_i2w_affine", # manually
	"gnome_canvas_item_i2c_affine", # manually
	"gnome_canvas_item_w2i", # manually
	"gnome_canvas_item_i2w", # manually
	"gnome_canvas_item_affine_absolute", # manually
	"gnome_canvas_item_affine_relative", # manually
	"gnome_canvas_item_set_valist", # varargs
	"gnome_canvas_item_set", # FIXME required? (g_object_set should be good enough, right?)
	"gnome_canvas_item_construct", # is that required?
	"gnome_canvas_request_redraw_uta", # weird semantics, and only used by item implementations
	"gnome_canvas_w2c_affine", # manually
	"gnome_canvas_w2c", # manually
	"gnome_canvas_w2c_d", # manually
	"gnome_canvas_c2w", # manually
	"gnome_canvas_get_scroll_offsets", # manually
	"gnome_canvas_root", # manually
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
	## GnomeCanvas c2pfuncparamoverride
	"gnome_canvas_item_set_valist": [ 
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param gchar
		[ "tvarargs" ], # 3rd (C) param override
	],
	"gnome_canvas_item_grab": [
		None, # return value override
		None, # 1st (C) param override
		[ "type", "TGdkEventMask" ], # 2nd (C) param override
	],
	"gnome_canvas_item_get_bounds": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, x1
		[ "out" ], # 3rd (C) param override, y1
		[ "out" ], # 4th (C) param override, x2
		[ "out" ], # 5th (C) param override, y2
	],
}


c2psignalparamoverride = {
	"GnomeCanvas.render-background": [
		None, # return value override
		None, # 1st (C) param override
		["type", "IGnomeCanvasBuf"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
}

c2pproptypeoverride = {
	"GnomeCanvasBpath.bpath": ["ctype", "GnomeCanvasPathDef"],
	"GnomeCanvasClipgroup.path": ["ctype", "GnomeCanvasPathDef"],
	"GnomeCanvasLine.points": ["ctype", "boxed GnomeCanvasPoints"],
	"GnomeCanvasPolygon.points": ["ctype", "boxed GnomeCanvasPoints"],
	"GnomeCanvasShape.dash": ["ctype", "unboxed ArtVpathDash"],
}

c2pfuncparamnullable = {
}

#signalintf = ""
#signalimpl = ""

# where to add xxx_get_type external function explicitly (since its missing in the source xml)
paddexternalgettype = [
	## GnomeCanvas paddexternalgettype
	
	"GnomeCanvas", "GnomeCanvasBpath", "GnomeCanvasClipgroup",
	"GnomeCanvasEllipse", "GnomeCanvasGroup", 
	"GnomeCanvasItem", "GnomeCanvasLine", "GnomeCanvasPixbuf",
	"GnomeCanvasPolygon", "GnomeCanvasRE", "GnomeCanvasRichText",
	"GnomeCanvasRect", "GnomeCanvasShape", "GnomeCanvasText",
	"GnomeCanvasWidget",
]

# typemap for external declarations (C) -> pascal, prefix "const " for const-params
externaltypemap = {
}

# ptypename: {"SIMPLE"|"PARAMSPEC"|"ENUM"|"MEDIATOROBJECT"|"OBJECT"|"RECORD"}
csignalhandlerargtype2definemap = {
	"IGnomeCanvasBuf": "MEDIATOROBJECT",
}

# for determining whether to include c*.inc or not:
# this should become less with time
underivable = [
]

# TODO use that
classoverridables = {
}

# widgets that will be created without passing a C widget instance (ie NEW instances)
# will use this code after construction:
pextraconstructcode = {
}

superclassoverride = {
}

csettypes = [
]
