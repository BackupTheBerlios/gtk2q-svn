#!/usr/bin/env python

pstringtype = "UTF8String"
classprefix = "D"
enumprefix = "D"
interfaceprefix = "I"
interfaceunitprefix = "iu"
classunitprefix = "u"

pvars = { "pstringtype": pstringtype }

# type to use for storing the return value of Object Property Accessors
ptype1 = {
	"Bool": "Boolean",
	"Object": "",
	"Int": "Integer",
	"Byte": "Byte",
	"UInt": "GUInt",
	"GUInt": "GUInt",
	"Float": "Single",
	"String": pstringtype,
	"Double": "Double",
}

# hash of class -> uses clause additions (interface or implementation class name):
#    (interface names are added at the unit interface section)
#    (implementation class names are added at the unit implementation section)

pusedclasses = { # from class implementation: list of classes used (implementation 'uses' clause for classes, interface 'uses' clause for interfaces)
	#"DGtkCalendar": [ "IAtkImplementorIface" ], automagically
	
	## Gdk pusedclasses
	"DGdkDisplay": ["DGdkDevice", "DGdkScreen"],
	"DGdkDisplayManager": ["DGdkDisplay"],
	"DGdkScreen": ["DGdkWindow", "DGdkVisual"],
	"DGdkDrawable": ["IPangoLayout"],
	
	## Gtk pusedclasses
	"DGtkWidget": ["IGtkSelectionData", "DGtkSelectionData"],
	#automagically:, "IAtkImplementorIface" ],
	"DGtkClipboard": ["DGtkSelectionData", "IGtkSelectionData"],
	#["DGdkEvent"],
	"DGtkAccelLabel": ["IGClosure"],
	"DGtkAccessible": ["IAtkObject"], #, "DAtkObject"],
	"DGtkActionGroup": ["DGtkAction"],
	"DGtkCellEditable": ["IGInterface"],
	"DGtkCellLayout": ["IGInterface"],
	"DGtkEditable": ["IGInterface"],
	"DGtkFileChooser": ["IGInterface"],
	"DGtkTreeModel": ["IGInterface", "IGtkTreePath"],
	"DGtkTreeModelFilter": ["IGInterface", "IGtkTreePath"],
	"DGtkTreeModelSort": ["IGtkTreePath"],
	"DGtkTreeSelection": ["IGtkTreePath", "DGtkTreeModel"],
	"DGtkTreeSortable": ["IGInterface"],
	"DGtkWindow": ["DGdkPixbuf"],
	"DGtkIconTheme": ["IGtkIconInfo", "DGtkIconInfo"],
	"DGtkIconView": ["IGtkTreePath", "DGtkTreePath"],
	"DGtkImage": ["IGtkIconSet"],
	"DGtkStyle": ["IGtkIconSet"],
	"DGtkTextTag": ["IGtkTextAttributes"],
	"DGtkTextView": ["IGtkTextAttributes"],
	"DGtkTreeView": ["IGtkTreePath", "DGtkTreePath", "IGtkTreeViewColumn", "DGtkTreeViewColumn"],
	"DGdkGc": ["IGdkPixmap", "DGdkPixmap", "IGdkBitmap"],
	"DGdkPixbuf": ["DGdkPixmap", "IGdkPixmap", "DGdkBitmap", "IGdkBitmap", "DGdkPixbufFormat"],
	"DGtkRcStyle": ["IPangoFontDescription", "DPangoFontDescription"],
	"DGtkListStore": ["DGtkTreePath", "variants"],
	
	## GnomeCanvas pusedclasses
	"DGnomeCanvas": ["IGtkObject", "DGnomeCanvasGroup"],
	"DGnomeCanvasBpath": ["IGtkObject"],
	"DGnomeCanvasClipgroup": ["IGtkObject"],
	"DGnomeCanvasGroup": ["IGtkObject"],
	"DGnomeCanvasItem": ["IGtkObject", "IGdkCursor"],
	"DGnomeCanvasShape": ["IGtkObject"],
	"DGnomeCanvasRe": ["IGtkObject"],
	"DGnomeCanvasEllipse": ["IGtkObject"],
	"DGnomeCanvasRect": ["IGtkObject"],
	"DGnomeCanvasLine": ["IGtkObject"],
	"DGnomeCanvasPixbuf": ["IGtkObject"],
	"DGnomeCanvasPolygon": ["IGtkObject"],
	"DGnomeCanvasRichText": ["IGtkObject"],
	"DGnomeCanvasText": ["IGtkObject"],
	#"DGnomeCanvasXXX": ["IGtkObject"],
	
	## DiaCanvas pusedclasses
	"DDiaCanvas": ["DDiaCanvasItem", "DDiaCanvasGroup"],
	"DDiaCanvasItem": ["DDiaCanvasItemShapes", "IPangoLayout"],
	"DDiaCanvasImage": ["IGdkPixbuf"],
	"DDiaVariable": ["IDiaVariable"],
	"DDiaCanvasView": ["IGnomeCanvas", "IGtkLayout", "DGdkEvent"],
	"DDiaCanvasViewItem": ["IGtkObject", "IArtUta"],
	"DDiaHandle": ["IGnomeCanvasItem", "IGtkObject"],
	"DDiaHandleLayer": ["IGnomeCanvasItem", "IGtkObject"],
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
	"DGtkWidget": ["IGtkSelectionData"], #, "DGtkSelectionData"],
	"DGtkTreeModel": ["IGtkTreePath"],
	"DGtkTreeView": ["IGtkTreePath"],
	"DGtkIconView": ["IGtkTreePath"],
	"DGtkNotebook": ["IGtkNotebookPage"],
	"DGdkPixbuf": ["IGdkPixbufFormat"],
	
	## GnomeCanvas psignalusedioc
	"DGnomeCanvasItem": ["DGdkEvent"],
	"DGnomeCanvas": ["IGnomeCanvasBuf"],
	
	## DiaCanvas psignalusedioc
	"DDiaCanvas": ["DDiaRectangle"],
	"DDiaUndoManager": ["IDiaUndoAction"],
	"DDiaTool": ["DGdkEvent"],
}

# signal units uses clause, used classes for implementation section
psignalusediocimpl = {
	"DGtkWidget": ["DGtkSelectionData"],
	"DGtkIconView": ["DGtkTreePath"],
	"DGtkTreeView": ["DGtkTreePath"],
	"DGtkTreeModel": ["DGtkTreePath"],
	"DGtkNotebook": ["DGtkNotebookPage"],
	"DGnomeCanvas": ["DGnomeCanvasBuf"],
}

# these are array types that are to be automagically casted to the right type 
# when calling the wrapped function in the wrapper (to prevent array mismatch)
# add only when you get an array type mismatch.
# add C type name as given in the array override as [1]
poverridearraytypes = {
	"GdkPoint": "GdkPointArray",
	"GtkTargetEntry": "GtkTargetEntryArray",
	"GdkColor": "GdkColorArray",
	"GType": "GTypeArray",
	"gint": "TGIntArray",
	"GdkSpan": "TGdkSpanArray",
}

# hash of transformers for preturn, given that they arent obvious.
# examples for required manual transformers are:
#   - pointer to (structure or exception) transformer
preturntransformers = {
	"DGtkAccelGroupEntry": "DGtkAccelGroupEntryFromPointer",
	"DGtkAccelKey": "DGtkAccelKeyFromPointer",
}

# list of classes that are not gobject (usually pointermediators) but are wrappers
nongobjectclasses = [
	"DGtkTreePath",
	"DGtkTreeIter",
	"DGtkIconInfo",
	"DGtkTextAttributes",
	"DGtkSelectionData",
	"DGdkPixbufFormat",
	"DGnomeCanvasPoints",
	"DGnomeCanvasPathDef",
	"ArtVpathDash",

	## DiaCanvas nongobjectclasses
	"DiaShape", # nope. is more or less one
	##"DiaHandle",  er....
	"DiaShapeBezier",
	"DiaShapeClip",
	"DiaShapeEllipse",
	"DiaShapeImage",
	"DiaShapePath",
	"DiaShapeText",
	"DiaExpression",
	"DiaDashStyle",
]

# maps from interface name to interface unit name for special cases

interfaceunitoverride = {
	"IAtkImplementorIface": interfaceunitprefix + "atk", #mmm
	"IAtkObject": interfaceunitprefix + "atk",
	"IGtkIconInfo": interfaceunitprefix + "gtkiconinfo",
	"IGtkTextAttributes": interfaceunitprefix + "gtktextattributes",
	"IGtkNotebookPage": interfaceunitprefix + "gtknotebookpage",
	##defl"IGInterface": interfaceunitprefix + "g",
	#if interface == "IGdkDisplay" or interface == "IGdkScreen" \
	#or interface == "IGdkDevice" or interface == "IGdkWindow" \
	#or interface == "IGdkPixmap":
	#	return interfaceunitprefix + "drawable"
	"IGClosure": interfaceunitprefix + "gobject",
	"IGObject": interfaceunitprefix + "gobject",
	"IGtkSelectionData": interfaceunitprefix + "gtkselectiondata",
	#"IGtkIconSet": interfaceunitprefix + "gtkiconset",
	"IGtkTreePath": interfaceunitprefix + "gtktreepath",
	"IGdkPixbufAnimationIter": interfaceunitprefix + "gdk",
	"IGdkPixbufFormat": interfaceunitprefix + "gdkpixbufformat",
	"IGnomeCanvasBuf": interfaceunitprefix + "gnomecanvasbuf",
	"IDiaUndoAction": interfaceunitprefix + "diaundoaction",
	"IDiaVariable": interfaceunitprefix + "diacanvas",
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
	# contains the stuff that are wrapped as pascal classes with interface
	"AtkObject",
	
	"GClosure", "GObject",
	"GdkBitmap", "GdkColormap", "GdkCursor", "GdkDevice", "GdkDisplay", 
	"GdkDisplayManager", "GdkDragContext", "GdkDrawable", "GdkFont", 
	"GdkGc", "GdkGC",   # ugh
	"GdkImage",
	"GdkPixbuf", "GdkPixbufAnimation", "GdkPixbufAnimationIter",
	"GdkPixbufFormat", # 
	"GdkPixbufLoader",
	"GdkPixmap", "GdkRegion", "GdkScreen", "GdkVisual", "GdkWindow", 

	"GtkAboutDialog", "GtkAccelGroup", "GtkAccelLabel", "GtkAccessible", 
	"GtkAction", "GtkActionGroup", "GtkAdjustment", 
	"GtkAlignment",
	"GtkArrow", "GtkAspectFrame",
	"GtkBin", "GtkBox", "GtkButton", "GtkButtonBox",
	"GtkCalendar",
	"GtkCellEditable", "GtkCellLayout", "GtkCellRenderer", 
	"GtkCellRendererPixbuf", "GtkCellRendererProgress",
	"GtkCellRendererCombo",
	"GtkCellRendererText", "GtkCellRendererToggle", "GtkCheckButton",
	"GtkCheckMenuItem",
	"GtkClipboard", "GtkColorButton", "GtkColorSelection",
	"GtkColorSelectionDialog",
	"GtkComboBox", "GtkComboBoxEntry", "GtkContainer", "GtkCurve",
	"GtkGammaCurve",
	"GtkDialog", "GtkDrawingArea",
	"GtkEditable", "GtkEntry", "GtkEntryCompletion", 
	"GtkEventBox", "GtkExpander",
	"GtkFileChooser", 
	"GtkFileChooserButton",
	"GtkFileChooserDefault",  # more or less
	"GtkFileChooserDialog", "GtkFileChooserWidget",
	"GtkFileFilter", "GtkFileSelection",
	"GtkFontButton", "GtkFixed", 
	"GtkFontSelection", "GtkFontSelectionDialog",
	"GtkFrame",
	"GtkHandleBox",

	"GtkHBox", "GtkHButtonBox", "GtkHPaned", "GtkHRuler", "GtkHScale", "GtkHScrollbar",
	"GtkHSeparator",

	"GtkIconInfo", 
	"GtkIconSet", "GtkIconTheme", "GtkIconView", "GtkImage",
	
	"GtkIMContext", "GtkIMContextSimple", "GtkIMMulticontext",
	
	"GtkImage",
	"GtkImageMenuItem", 
	"GtkInputDialog",
	"GtkInvisible",
	"GtkItem",
	"GtkLabel", "GtkLayout", "GtkListStore",
	"GtkMenu", "GtkMenuBar", "GtkMenuItem", "GtkMenuShell", 
	"GtkMenuToolButton",
	"GtkMessageDialog", "GtkMisc",
	"GtkNotebook",
	"GtkObject", 
	"GtkPaned", "GtkPlug", "GtkProgressBar",
	"GtkRadioAction", "GtkRadioButton", 
	"GtkRadioMenuItem", "GtkRadioToolButton", 
	"GtkRange", "GtkRuler",
	"GtkScale", "GtkScrollbar",
	"GtkScrolledWindow",
	"GtkSeparator", "GtkSeparatorMenuItem", "GtkSeparatorToolItem",
	"GtkSettings", "GtkSizeGroup",
	"GtkSocket",
	"GtkSpinButton", "GtkStatusbar",
	"GtkRcStyle", "GtkSelectionData", "GtkStyle", 
	"GtkTable", "GtkTearoffMenuItem",
	"GtkTextAttributes", # not quite
	"GtkTextBuffer", 
	"GtkTextChildAnchor", 
	"GtkTextMark",	"GtkTextTag", "GtkTextTagTable",
	"GtkTextView", 
	"GtkTipsQuery",
	"GtkToggleAction", "GtkToggleButton",
	"GtkToggleToolButton",
	"GtkToolbar", "GtkToolButton", "GtkToolItem", "GtkTooltips",
	
	"GtkTreeDragDest", "GtkTreeDragSource", # more or less
	
	"GtkTreeModel", "GtkTreeModelFilter", "GtkTreeModelSort",
	"GtkTreePath", "GtkTreeSelection", 
	"GtkTreeStore", "GtkTreeView", 
	"GtkTreeViewColumn", "GtkTreeSortable",
	"GtkUIManager",
	"GtkHPaned", 
	"GtkViewport",
	"GtkVBox", "GtkVButtonBox",
	"GtkVPaned", 
	"GtkVRuler",
	"GtkVSeparator",
	"GtkVScale", "GtkVScrollbar", 
	"GtkWidget", "GtkWindow", "GtkWindowGroup",
	"PangoAttrList", "PangoContext", "PangoFont", "PangoLayout", 
	"PangoTabArray", "PangoFontDescription",
	
	## GnomeCanvas cclasses
	
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
	"ArtVpathDash",
	"ArtUta", # somewhat
	
	## DiaCanvas cclasses
	"DiaCanvas",
	"DiaConstraint",
	"DiaCanvasElement",
	"DiaCanvasEditable", # not quite
	"DiaCanvasView",
	"DiaCanvasViewItem",
	"DiaCanvasItem",
	"DiaCanvasImage",
	"DiaCanvasText",
	"DiaDashStyle",
	"DiaExpression",
	"DiaHandle",
	"DiaHandleLayer",
	"DiaShape",
	"DiaShapeBezier",
	"DiaShapeClip",
	"DiaShapeEllipse",
	"DiaShapeImage",
	"DiaShapePath",
	"DiaShapeText",
	"DiaTool",
	"DiaStackTool",
	"DiaDefaultTool",
	"DiaPlacementTool",
	"DiaSelectionTool",
	"DiaItemTool",
	"DiaHandleTool",
	"DiaUndoAction",
	"DiaUndoManager",
	"DiaVariable",
	"DiaSolver",
]

# list of parameters that are used as 'const ...*' uselessly (from a pascal point of view)
c2pconstpointerparam = [ # 'const GdkColor*' as parameter
	"GdkColor",
	"GTimeVal",
	"GtkFileFilterInfo",
	"GtkTextIter",
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
	# contains c '*_new' parameters for each c 'class'
	"GdkColormap": None, # manually
	"GdkDevice": None, # not constructable
	"GdkDisplayManager": None, # not constructable
	"GdkDisplay": None, # not constructable
	"GdkDrawable": None, # not constructable
	"GdkGC": None, # manually constructable
	"GdkImage": None, # manually constructable
	"GdkPixbufAnimation": None, # manually constructable (only from file O_o)
	"GdkPixbuf": "TGdkColorSpace(csRgb), True, 8, 1, 1", # "GDK_COLORSPACE_RGB, True, 8, 1, 1",
	"GdkPixmap": None, # manually constructable
	"GdkScreen": None, # not construtable
	"GdkVisual": None, # not constructable
	"GdkWindow": None, # TODO constructable
	"GtkAccelLabel": "PGChar(PChar(''))",
	"GtkAccessible": None, # not constructable
	"GtkActionGroup": None, # TODO
	"GtkAction": None, # TODO
	"GtkAdjustment": "0,0,100,1,10,10",
	"GtkAlignment": "0,0,0.5,0.5",
	"GtkArrow": "TGtkArrowType(arRight), TGtkShadowType(shNone)", # "GTK_ARROW_RIGHT, GTK_SHADOW_NONE",
	"GtkAspectFrame": "PGChar(PChar('')), 0.5, 0.5, 0.5, TRUE",
	"GtkBin": None, # not constructable
	"GtkBox": None, # not constructable
	"GtkButtonBox": None, # not constructable
	"GtkCellEditable": None, # not constructable
	"GtkCellLayout": None, # not constructable
	"GtkCellRenderer": None, # not constructable
	"GtkClipboard": None, # can only get existing clipboards
	"GtkColorSelectionDialog": "PGChar(PChar(''))", # title ?
	"GtkContainer": None, # not constructable
	"GtkEditable": None, # interface
	"GtkExpander": "PGChar(PChar(''))", # szlabel
	"GtkFileChooserDialog": "nil, nil, TGtkFileChooserAction(gfOpen), nil, []", # action is settable later so thats ok
	"GtkFileChooser": None, # interface
	"GtkFileChooserWidget": "TGtkFileChooserAction(gfOpen)",
	"GtkFileSelection": "PGChar(PChar(''))", # unused
	"GtkFontSelectionDialog": "PGChar(PChar(''))",
	"GtkFrame": "PGChar(PChar(''))",
	"GtkHBox": "FALSE, 0",
	"GtkHScale": "nil",
	"GtkHScrollbar": "nil",
	"GtkImage": "",
	"GtkImContext": None, # base class
	"GtkIMContext": None, # base class, to be safe
	"GtkImContextSimple": "",
	"GtkIMContextSimple": "", # ?
	"GtkItem": None,  # not constructable
	"GtkLabel": "PGChar(PChar(''))",
	"GtkLayout": "nil, nil",
	"GtkListStore": None, # hmm
	"GtkMenuShell": None, # not constructable
	"GtkMessageDialog": None, # TODO make constructable
	"GtkMisc": None, # not constructable
	"GtkObject": None, # not constructable
	"GtkPaned": None, # not constructable
	"GtkProgress": None, # base class
	"GtkRadioAction": None, # TODO
	"GtkRadioButton": "nil", # group
	"GtkRadioMenuItem": "nil", # group
	"GtkRadioToolButton": "nil", # group
	"GtkRange": None, # not constructable
	"GtkRuler": None, # not constructable
	"GtkScale": None, # not constructable
	"GtkScrollbar": None, # not constructable
	"GtkScrolledWindow": "nil, nil", # adjustments
	"GtkSeparator": None, # not constructable
	"GtkSettings": None, # not constructable
	"GtkSizeGroup": "TGtkSizeGroupMode(gsBoth)", # GTK_SIZE_GROUP_BOTH",
	"GtkSpinButton": "nil, 1.0, 0", # test that
	"GtkTable": "0, 0, FALSE",
	"GtkTextBuffer": "nil", # tagtable
	"GtkTextMark": None, # not constructable (no new?)
	"GtkTextTag": None, # TODO: name!
	"GtkToggleAction": None, # TODO
	"GtkToolButton": "nil, PGChar(PChar(''))", # iconwidget, szlabel
	"GtkTreeDragDest": None, # interface
	"GtkTreeDragSource": None, # interface
	"GtkTreeModel": None, # base class
	"GtkTreeModelFilter": None, # manually
	"GtkTreeModelSort": None, # manually
	"GtkTreeSelection": None, # not constructable
	"GtkTreeSortable": None, # interface
	"GtkTreeStore": None, # hmm
	"GtkVBox": "FALSE, 0",
	"GtkViewport": "nil, nil", # adjustments
	"GtkVScale": "nil",
	"GtkVScrollbar": "nil",
	"GtkWidget": None, # not constructable
	"GtkWindow": "TGtkWindowType(wiToplevel)", # "GTK_WINDOW_TOPLEVEL",
	
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
	
	## DiaCanvas cclassconstructparams
	"DiaCanvasItem": None, # not constructable, base type.
	"DiaCanvasElement": None, # not constructable, base type.
	"DiaCanvasEditable": None, # interface?
	"DiaCanvasGroupable": None, # interface
	"DiaCanvasView": "nil, True",
	"DiaCanvasViewItem": None, # seems not constructable
	"DiaHandle": "nil", # fixme test if nil owner is ok
	"DiaHandleLayer": None, # internal helper
	"DiaTool": None, # base class
	"DiaUndoManager": None, # seems not constructable
}

# direct type mapping
# contains type mappings for primitive types, for use in the interfaces
# be careful with that.
c2ptypehash = {
	"const gchar*": pstringtype,
	"G_CONST_RETURN gchar": pstringtype,
	"gchararray": pstringtype,
	"gdouble": "Double",
	"GQuark": "DGQuark",
	"gfloat": "Single",
	"glong": "Longint", # signed?
	"gint": "Integer",
	"gint8": "GInt8",
	"guint": "GUInt",
	"guint16": "Word", 
	"guint32": "Cardinal",
	"gboolean": "Boolean",
	"GdkAtom": "DGdkAtom",
	"guchar": "Byte", # pixbuf only
	"double": "Double", # pixbuf only
	"gsize": "gsize", #
	"gulong": "gulong",
	"GdkNativeWindow": "DGdkNativeWindow",
	"GType": "GType",
	"GdkRgbColor": "DGdkRgbColor", # made that up
	#"va_list": "TVarrecArray", # ?
}

# TODO split enum and 'set's
c2penumcopied = [ # enums copied to delphi as-is
	## Atk c2penumcopied
	"AtkRelationType",
	
	## Gtk c2penumcopied
	"GdkAxisUse", "GdkCapStyle", "GdkColorspace", 
	"GdkCursorType",
	"GdkDragAction", "GdkDragProtocol", "GdkEventMask", 
	"GdkExtensionMode", 
	"GdkFill", "GdkFillRule", "GdkFunction",
	"GdkGravity", "GdkImageType", "GdkInputMode", 
	"GdkInputSource", "GdkInterpType", "GdkJoinStyle",
	"GdkLineStyle", "GdkModifierType", "GdkOverlapType", "GdkRgbDither", 
	"GdkSubwindowMode", "GdkVisualType", "GdkWindowEdge", "GdkWindowState", 
	"GdkWindowType", "GdkWindowTypeHint", "GdkWMDecoration", "GdkWMFunction", 

	"GtkAccelFlags", "GtkAnchorType",
	"GtkArrowType", "GtkAttachOptions", "GtkButtonBoxStyle", 
	"GtkButtonsType", "GtkCalendarDisplayOptions", "GtkCellRendererMode", 
	"GtkCellRendererState", "GtkCornerType", 

	#"GtkCTreeExpanderStyle", "GtkCTreeLineStyle", 

	"GtkCurveType", "GtkDeleteType",
	"GtkDialogFlags",
	"GtkDirectionType", "GtkExpanderStyle", "GtkFileChooserAction", 
	"GtkFileFilterFlags", "GtkIconLookupFlags", "GtkIconSize", "GtkImageType",
	"GtkJustification", "GtkMenuDirectionType", "GtkMessageType", "GtkMetricType", 
	"GtkMovementStep", "GtkNotebookTab", "GtkOrientation", 
	"GtkPackType", "GtkPolicyType", "GtkPositionType", "GtkProgressBarOrientation", 
	"GtkProgressBarStyle", "GtkReliefStyle", "GtkResizeMode", 
	"GtkScrollStep", "GtkScrollType", "GtkSelectionMode", 
	"GtkShadowType", "GtkSizeGroupMode", "GtkSortType", "GtkSpinButtonUpdatePolicy", 
	"GtkSpinType", "GtkStateType", "GtkTextDirection", "GtkTextWindowType",
	"GtkTreeViewDropPosition",
	"GtkToolbarSpaceStyle", "GtkToolbarStyle", "GtkTreeViewColumnSizing", 
	"GtkTreeModelFlags", "GtkUIManagerItemType",
	"GtkUpdateType", "GtkWidgetHelpType", "GtkWindowPosition", "GtkWindowType", 
	"GtkWrapMode", 

	## Pango c2penumcopied
	"PangoAlignment", "PangoStretch", "PangoStyle", "PangoTabAlign", 
	"PangoUnderline", "PangoVariant",
	"PangoWeight",
	
	## DiaCanvas c2penumcopied
	"DiaStrength",
	"DiaJoinStyle",
	"DiaCapStyle",
	"DiaEventMask",
]

# structs copied from gtk to the wrapped (into unit u...types) 
c2pstructcopied = { # simple structs copied to delphi as-is
	"ArtPoint": "DArtPoint",
	"ArtBPath": "DArtBPath",
	
	"GtkBorder": "DGtkBorder",
	"GtkRequisition": "DGtkRequisition", # TODO how to get/set
	"GtkBorder": "DGtkBorder", # TODO how to get/set

	"GdkEventAny": "DGdkEventAny",
	"GdkEventExpose": "DGdkEventExpose",
	"GdkEventNoExpose": "DGdkEventNoExpose",
	"GdkEventVisibility": "DGdkEventVisibility",
	"GdkEventMotion": "DGdkEventMotion",
	"GdkEventButton": "DGdkEventButton",
	"GdkEventScroll": "DGdkEventScroll",
	"GdkEventKey": "DGdkEventKey",
	"GdkEventFocus": "DGdkEventFocus",
	"GdkEventCrossing": "DGdkEventCrossing",
	"GdkEventConfigure": "DGdkEventConfigure",
	"GdkEventProperty": "DGdkEventProperty",
	"GdkEventSelection": "DGdkEventSelection",
	"GdkEventProximity": "DGdkEventProximity",
	"GdkEventClient": "DGdkEventClient",
	"GdkEventDND": "DGdkEventDND",
	"GdkEventSetting": "DGdkEventSetting",
	"GdkEvent": "DGdkEvent", # fixme?
	"GdkRectangle": "DGdkRectangle",
	"GdkColor": "DGdkColor",
	"GdkSpan": "DGdkSpan",
	"GdkPoint": "DGdkPoint",
	"GdkSegment": "DGdkSegment",
	#not anymore, "GdkPixbufFormat": "DGdkPixbufFormat",
	"GdkPixbufModulePattern": "DGdkPixbufModulePattern",
	"GTimeVal": "DGTimeVal",
	"GtkAllocation": "DGtkAllocation",
	#"GtkRadioActionEntry": "DGtkRadioActionEntry",
	#  class .."PangoFontDescription": "DPangoFontDescription",
	"GtkTreeIter": "DGtkTreeIter",
	"GtkFileFilterInfo": "DGtkFileFilterInfo",
	"GtkTextIter": "DGtkTextIter",
	"GtkTargetEntry": "DGtkTargetEntry",
	"GtkAccelGroupEntry": "DGtkAccelGroupEntry",
	"GtkAccelKey": "DGtkAccelKey",
	
	## DiaCanvas
	"DiaRectangle": "DDiaRectangle",
	"DiaPoint": "DDiaPoint", # well actually its the same as artpoint
	"DiaCanvasIter": "DDiaCanvasIter",
	"DiaCanvasItemAffine": "DDiaCanvasItemAffine", # made that up
}

# class (not instance) functions to get from C
c2pclassfunctions = { 
}

cskipsignals = [
	## DiaCanvas
	"DiaCanvasItem.event", # deprecated
]

# properties that are to be skipped and not be wrapped (f.e. deprecated properties)
cskipprops = [
	"GtkFontSelection.font",
	"AtkRelation.target", # FIXME: GValueArray
	
	## DiaCanvas cskipprops
	"DiaCanvasItem.connect", # what the heck is that
	"DiaCanvasItem.disconnect", # dont abuse properties for procedures
]

# externals to force
forceexternals = [
	"gdk_gc_copy",
	"gtk_list_store_set_value", # manual override
	"gtk_tree_store_set_value", # manual override
	"gdk_pixbuf_new_subpixbuf",
	"gtk_tree_store_reorder",
	"gtk_list_store_reorder",
	"gtk_widget_class_path",
	"gtk_widget_path",
#	"gdk_pixbuf_save",
#	"gdk_pixbuf_save_to_buffer",
	"gdk_pixbuf_save_to_bufferv",
	"gdk_pixbuf_save_to_callbackv",
	"gdk_pixbuf_savev",
	"gdk_pixbuf_render_pixmap_and_mask", # only in forceexternals and overridden
	"gdk_pixbuf_render_pixmap_and_mask_for_colormap", # only in forceexternals and overridden
	"gdk_region_get_rectangles",
#	"gdk_pixbuf_get_formats",
#	"gdk_pixbuf_format_get_description",
#	"gdk_pixbuf_format_get_extensions",
#	"gdk_pixbuf_format_get_mime_types",
#	"gdk_pixbuf_format_get_name",
#	"gdk_pixbuf_format_is_writable",
	# wonder if radioaction radiobutton radiomenuitem radiotoolbutton all also have a group property fixme
	#has a property "gtk_radio_menu_item_get_group", # GSList* somewhat-id
	#has a property "gtk_radio_menu_item_set_group", # GSList* somewhat-id
	"gtk_tree_view_get_cursor",
	"gtk_tree_view_get_dest_row_at_pos",
	"gtk_tree_view_get_drag_dest_row",
	"gtk_tree_view_get_path_at_pos",
	"gtk_tree_selection_get_selected", # manually
	"gtk_tree_selection_get_selected_rows", # manually
	
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
	
	## DiaCanvas forceexternals
	"dia_canvas_glue_handle", # too many pointers
	"dia_canvas_item_update_child", # manually
	"dia_canvas_item_affine_point_w2i", # manually
	"dia_canvas_item_affine_w2i", # manually
	"dia_canvas_item_bb_affine", # manually
	"dia_canvas_item_affine_i2w", # manually
	"dia_canvas_item_affine_point_i2w", # manually
	"dia_canvas_group_create_item", # manually
	"dia_handle_update_w2i", # manually
	"dia_handle_update_i2w_affine", # manually
	"dia_handle_update_w2i_affine", # manually
	"dia_handle_request_update_w2i", # manually
	"dia_handle_distance_w", # manually
	"dia_handle_distance_i", # manually
	"dia_handle_set_pos_i_affine", # manually
	"dia_canvas_preserve", # manually (variant)
	"dia_canvas_view_move", # renamed (manually)
]

paddmembervars = {
	"DiaCanvasItem": """
		fShapesProxy: IDiaCanvasItemShapes;
		fShapesProxyLocked: Integer;
	""",
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
	"GdkColormap": {
		"Create": """
			public constructor Create(visual: IGdkVisual; isPrivate: Boolean = False); reintroduce;
			var
			  cvisual: PGdkVisual;
			begin
			  assert(Assigned(visual));
			  cvisual := visual.GetUnderlying;
			  assert(Assigned(cvisual));
			  CreateWrapped(gdk_colormap_new(cvisual, isPrivate));
			end;
		""",
	},
	"GdkWindow": {
		"IsPointerGrabbed": """
			public class function IsPointerGrabbed: Boolean;
			begin
			  Result := gdk_pointer_is_grabbed();
			end;
		""",
		"PointerGrab": """
			published function PointerGrab(ownerGetsEvents: Boolean; eventmask: DGdkEventMask; confineTo: IGdkWindow = nil; cursor: IGdkCursor = nil; time: guint32 = 0): DGdkGrabStatus;
			var
			  cconfine: PGdkWindow;
			  ccursor: PGdkCursor;
			begin
			  cconfine := nil;
			  if Assigned(confineTo) then cconfine := confineTo.GetUnderlying;
			  ccursor := nil;
			  if Assigned(cursor) then ccursor := cursor.GetUnderlying;
			  
			  Result := gdk_pointer_grab(PGdkWindow(Fobject), ownerGetsEvents, 
			  	TGdkEventMask(eventmask), cconfine, ccursor, time);
			end;
		""",
		"PointerUngrab": """
			public class procedure PointerUngrab(time: guint32 = 0);
			begin
			  gdk_pointer_ungrab(time);
			end;
		""",
		"KeyboardGrab": """
			published function KeyboardGrab(ownerGetsEvents: Boolean; time: guint32 = 0): DGdkGrabStatus;
			begin
			  Result := gdk_keyboard_grab(PGdkWindow(Fobject), ownerGetsEvents, time);
			end;
		""",
		"KeyboardUngrab": """
			public class procedure KeyboardUngrab(time: guint32 = 0);
			begin
			  gdk_keyboard_ungrab(time);
			end;
		""",
	},
	"GdkRegion": {
		"GetRectangles": """
			published function GetRectangles: TGdkRectangleArray;
			var
			  rects: PGdkRectangle;
			  cnt: gint;
			  i: gint;
			begin 
			  gdk_region_get_rectangles(Fobject, @rects, @cnt);
			  SetLength(Result, cnt);
			  for i := 0 to cnt - 1 do begin
			    Result[i] := rects^;
			    rects := GdkNextRectangle(rects);
			  end;
			  if Assigned(rects) then
			    g_free(rects);
			end;
		""",
		"IsEmpty": """
			published function IsEmpty: Boolean;
			begin
			  Result := Empty;
			end;
		""",
	},
	"GdkPixbuf": {
		"CreateFromString": """
			public constructor CreateFromString(data: AnsiString);
			var
			  p: PChar;
			  l: Integer;
			  itemraw: PGdkPixbuf;
			  error: TGError;
			begin
			  p := PChar(data);
			  l := StrLen(p);
			  
			  itemraw := gdk_pixbuf_new_from_inline(l, Pguint8(p), True, @error);
			  if not Assigned(itemraw) then
			    HandleAndFreeGError(error, EGdkPixbufError);

			  CreateWrapped(itemraw);
			end;
		""",
		"CreateSubPixbuf": """
			public class function CreateSubPixbuf(pix: IGdkPixbuf; srcx,srcy,width,height: Integer): IGdkPixbuf;
			begin
			  assert(Assigned(pix));
			  Result := CreateWrapped(gdk_pixbuf_new_subpixbuf(pix.GetUnderlying, srcx,srcy,width,height)) as IGdkPixbuf;
			end;
		""",
		"RenderPixmapAndMask": """
			published procedure RenderPixmapAndMask(out pixmap: IGdkPixmap; out mask: IGdkBitmap; alphaThreshold: Integer = 255);
			var
			  nativepixmap: PGdkPixmap;
			  nativemask: PGdkBitmap;
			begin
			  gdk_pixbuf_render_pixmap_and_mask(PGdkPixbuf(GetUnderlying), 
			    @nativepixmap, @nativemask, alphaThreshold);

			  pixmap := DGObjectDescendantGetOrCreateWrapper(nativepixmap, DGdkPixmap) as IGdkPixmap;
			  mask := DGObjectDescendantGetOrCreateWrapper(nativemask, DGdkBitmap) as IGdkBitmap;
			end;
		""",
		"RenderPixmapAndMaskForColormap": """
			published procedure RenderPixmapAndMaskForColormap(colormap: IGdkColormap; out pixmap: IGdkPixmap; out mask: IGdkBitmap; alphaThreshold: Integer = 255);
			var
			  nativepixmap: PGdkPixmap;
			  nativemask: PGdkBitmap;
			  nativecolormap: PGdkColormap;
			begin
			  assert(Assigned(colormap));
			  nativecolormap := colormap.GetUnderlying;
			  assert(Assigned(nativecolormap));
			  gdk_pixbuf_render_pixmap_and_mask_for_colormap(PGdkPixbuf(GetUnderlying), 
			    nativecolormap,
			    @nativepixmap, @nativemask, alphaThreshold);

			  pixmap := DGObjectDescendantGetOrCreateWrapper(nativepixmap, DGdkPixmap) as IGdkPixmap;
			  mask := DGObjectDescendantGetOrCreateWrapper(nativemask, DGdkBitmap) as IGdkBitmap;
			end;
		""",
		"SaveToCallback": """
			published procedure SaveToCallback(callback: DGdkPixbufSaveFunc; ftype: string; const options: TUTF8StringArray); overload;
			var
			  optionkeys: PPChar;
			  optionvalues: PPChar;
			  error: TGError;
			  i: Integer;
			begin
			  HelperDGdkPixbufOptions(options, optionkeys, optionvalues);
			  			  
			  if (not gdk_pixbuf_save_to_callbackv(GetUnderlying, 
			    TGdkPixbufSaveFunc(@callback), Self,
			    PChar(ftype),
			    optionkeys, optionvalues, @error)) then
			  begin
			    g_strfreev(PPGChar(optionkeys));
			    g_strfreev(PPGChar(optionvalues));
			    HandleAndFreeGError(error, EGdkPixbufError);
			  end;
			  
			  g_strfreev(PPGChar(optionkeys));
			  g_strfreev(PPGChar(optionvalues));
			end;
		""",
		"SaveToCallback+": """
			published procedure SaveToCallback(callback: DGdkPixbufSaveFunc; ftype: string); overload;
			var
			  opts: TUTF8StringArray;
			begin
			  SetLength(opts, 0);
			  SaveToCallback(callback, ftype, opts);
			end;
		""",
		"Save": """
			published procedure Save(filename: string; ftype: string; const options: TUTF8StringArray); overload;
			var
			  optionkeys: PPChar;
			  optionvalues: PPChar;
			  error: TGError;
			  i: Integer;
			begin
			  HelperDGdkPixbufOptions(options, optionkeys, optionvalues);
			  			  
			  if (not gdk_pixbuf_savev(GetUnderlying, 
			  PChar(filename), PChar(ftype),
			  optionkeys, optionvalues, @error)) then begin
			    g_strfreev(PPGChar(optionkeys));
			    g_strfreev(PPGChar(optionvalues));
			    HandleAndFreeGError(error, EGdkPixbufError);
			  end;
			  
			  g_strfreev(PPGChar(optionkeys));
			  g_strfreev(PPGChar(optionvalues));
			end;
		""",
		"Save+": """
			published procedure Save(filename: string; ftype: string); overload;
			var
			  opts: TUTF8StringArray;
			begin
			  SetLength(opts, 0);
			  Save(filename, ftype, opts);
			end;
		""",
	},
	"GdkPixbufAnimation": {
		"CreateFromFile": """
		public constructor CreateFromFile(filename: string);
		var
		  error: TGError;
		  canimation: PGdkPixbufAnimation;
		begin
		  canimation := gdk_pixbuf_animation_new_from_file(PChar(filename), @error);
		  if not Assigned(canimation) then
		    HandleAndFreeGError(error, EGdkPixbufError);
		    
		  CreateWrapped(canimation);
		end;
		""",
	},
	"GdkPixmap": {
		"Create": """
		public constructor Create(width, height: Integer; depth: Integer); reintroduce; overload;
		begin
		  CreateWrapped(gdk_pixmap_new(nil, gint(width), gint(height), gint(depth)));
		end;
		""",
		"Create+": """
		public constructor Create(drawable: IGdkDrawable; width, height: Integer); reintroduce; overload;
		var
		  cdrawable: PGdkDrawable;
		begin
		  assert(Assigned(drawable));
		  cdrawable := drawable.GetUnderlying;
		  assert(Assigned(cdrawable));
		  CreateWrapped(gdk_pixmap_new(cdrawable, gint(width), gint(height), gint(-1)));
		end;
		""",
	},
	"GdkDisplay": {
		"GetCorePointer": """
		published function GetCorePointer: IGdkDevice;
		var
		  nativeobject: PGdkDevice;
		begin
		  nativeobject := gdk_display_get_core_pointer(PGdkDisplay(Fobject));
		  
		  g_object_ref(nativeobject); // ?
		  
		  Result := DGObjectDescendantGetOrCreateWrapper(nativeobject, DGdkDevice) as IGdkDevice;
		end;
		""",
	},
	"GdkGC": {
		"Create": """
			public constructor Create(drawable: IGdkDrawable); reintroduce;
			var
			  cdrawable: PGdkDrawable;
			begin
			  assert(Assigned(drawable));
			  cdrawable := drawable.GetUnderlying;
			  assert(Assigned(cdrawable));
			  CreateWrapped(gdk_gc_new(cdrawable));
			end;
		""",
		"GetSubwindow": """
		published function GetSubwindow: DGdkSubwindowMode;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := DGdkSubwindowMode(vals.subwindow_mode);
		end;
		""",
		"GetStipple": """
		published function GetStipple: IGdkPixmap;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  if Assigned(vals.stipple) then begin
		    g_object_ref(vals.stipple);
		    Result := DGObjectDescendantGetOrCreateWrapper(vals.stipple, DGdkPixmap) as IGdkPixmap;
		  end else Result := nil;
		end;
		""",
		"GetExposures": """
		published function GetExposures: Boolean;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := vals.graphics_exposures <> 0;
		end;
		""",
		"GetTile": """
		published function GetTile: IGdkPixmap;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  if Assigned(vals.tile) then begin
		    g_object_ref(vals.tile);
		    Result := DGObjectDescendantGetOrCreateWrapper(vals.tile, DGdkPixmap) as IGdkPixmap;
		  end else Result := nil;
		end;
		""",
		"GetForeground": """
		published function GetForeground: DGdkColor;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := DGdkColor(vals.foreground);
		end;
		""",
		"GetBackground": """
		published function GetBackground: DGdkColor;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := DGdkColor(vals.background);
		end;
		""",
		"GetFill": """
		published function GetFill: DGdkFill;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := DGdkFill(vals.fill);
		end;
		""",
		"GetFunction": """
		published function GetFunction: DGdkFunction;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  Result := DGdkFunction(vals._function);
		end;
		""",
		"GetClipMask": """
		published function GetClipMask: IGdkBitmap;
		var
		  vals: TGdkGCValues;
		begin
		  gdk_gc_get_values(PGdkGC(Fobject), @vals);
		  if Assigned(vals.clip_mask) then begin
		    g_object_ref(vals.clip_mask);
		    Result := DGObjectDescendantGetOrCreateWrapper(vals.clip_mask, DGdkPixmap) as IGdkBitmap;
		  end else Result := nil;
		end;
		""",
	},
	"GdkImage": {
		"Create": """
			public constructor Create(visual: IGdkVisual; width, height: Integer); reintroduce;
			var
			  cvisual: PGdkVisual;
			begin
			  assert(Assigned(visual));
			  cvisual := visual.GetUnderlying;
			  assert(Assigned(cvisual));
			  CreateWrapped(gdk_image_new(TGdkImageType(giFastest), cvisual, gint(width), gint(height)));
			end;
		""",
	},
	"GtkAboutDialog": {
		"SetAuthors": """
			published procedure SetAuthors(const authors: TUTF8StringArray);
			begin
			  boo_gtk_about_dialog_set_authors(fObject, authors);
			end;
		""",
		"GetAuthors": """
			published function GetAuthors: TUTF8StringArray;
			begin
			  Result := boo_gtk_about_dialog_get_authors(fObject);
			end;
		""",
		"SetArtists": """
			published procedure SetArtists(const artists: TUTF8StringArray);
			begin
			  boo_gtk_about_dialog_set_artists(fObject, artists);
			end;
		""",
		"GetArtists": """
			published function GetArtists: TUTF8StringArray;
			begin
			  Result := boo_gtk_about_dialog_get_artists(fObject);
			end;
		""",
		"SetDocumenters": """
			published procedure SetDocumenters(const documenters: TUTF8StringArray);
			begin
			  boo_gtk_about_dialog_set_documenters(fObject, documenters);
			end;
		""",
		"GetDocumenters": """
			published function GetDocumenters: TUTF8StringArray;
			begin
			  Result := boo_gtk_about_dialog_get_documenters(fObject);
			end;
		""",
	},
	"GtkRcStyle": {
		"MergeFrom": """
			published procedure MergeFrom(source: IGtkRcStyle);
			begin
			  (* TODO call GTK_RC_STYLE_CLASS(GET_CLASS(Fobject))^.merge^ after it is fixed *)
			end;
		""",
		"GetBgPixmapName": """
			published function GetBgPixmapName(state: DGtkWidgetState): %(pstringtype)s;
			var
			  nvalue: PGChar;
			begin
			  nvalue := PGtkRcStyle(GetUnderlying)^.BgPixmapName[state];
			  if nvalue = nil then
			    Result := ''
			  else
			    Result := PChar(nvalue); (* utf8 *)
			end;
		""" % pvars,
		"SetBgPixmapName": """
			published procedure SetBgPixmapName(state: DGtkWidgetState; value: %(pstringtype)s);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  
			  if Assigned(rc^.BgPixmapName[state]) then begin
			    g_free(rc^.BgPixmapName[state]);
			    rc^.BgPixmapName[state] := nil;
			  end;
			  (* TODO nil ? *)
			  rc^.BgPixmapName[state] := g_strdup(PGChar(PChar(value)));
			end;
		""" % pvars,
		"GetColorFlags": """
			published function GetColorFlags(state: DGtkWidgetState): DGtkRcFlags;
			var
			  rc: PGtkRcStyle;
			  fs: DGtkRcFlags;
			  nfs: TGtkRcFlags;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  
			  nfs := rc^.ColorFlags[state];
			  
			  fs := [];
			  if (nfs and rcFg) <> 0 then fs := fs + [cfFg];
			  if (nfs and rcBg) <> 0 then fs := fs + [cfBg];
			  if (nfs and rcBase) <> 0 then fs := fs + [cfBase];
			  if (nfs and rcText) <> 0 then fs := fs + [cfText];
			  
			  Result := fs;
			end;
		""",
		"SetColorFlags": """
			published procedure SetColorFlags(state: DGtkWidgetState; value: DGtkRcFlags);
			var
			  rc: PGtkRcStyle;
			  fs: DGtkRcFlags;
			  nfs: TGtkRcFlags;
			begin
			  fs := value;
			  
			  rc := PGtkRcStyle(GetUnderlying);

			  nfs := 0;
			  if cfFg in fs then nfs := nfs or rcFg;
			  if cfBg in fs then nfs := nfs or rcBg;
			  if cfBase in fs then nfs := nfs or rcBase;
			  if cfText in fs then nfs := nfs or rcText;
			  
			  rc^.ColorFlags[state] := nfs;
			end;
		""",
		"GetFontDesc": """
			published function GetFontDesc: IPangoFontDescription;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  Result := nil;
			  if not Assigned(rc^.FontDesc) then Exit;
			  Result := DPangoFontDescription.CreateWrapped(rc^.FontDesc);
			end;
		""",
		"SetFontDesc": """
			published procedure SetFontDesc(value: IPangoFontDescription);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  if Assigned(rc^.FontDesc) then begin
			    g_object_unref(rc^.FontDesc);
			    rc^.FontDesc := nil;
			  end;
			  
			  rc^.FontDesc := value.GetUnderlying;
			end;
		""",
		"GetFgColor": """
			published function GetFgColor(state: DGtkWidgetState): DGdkColor;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  if (rc^.ColorFlags[state] and rcFg) = 0 then
			    raise EPropertyValueNotAvailable.Create('(rcstyle) Property value of fg not available');
			    
			  Result := rc^.Fg[state];
			end;
		""",
		"SetFgColor": """
			published procedure SetFgColor(state: DGtkWidgetState; const value: DGdkColor);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.ColorFlags[state] := rc^.ColorFlags[state] or rcFg;
			  rc^.Fg[state] := value;
			end;
		""",
		"GetBgColor": """
			published function GetBgColor(state: DGtkWidgetState): DGdkColor;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  if (rc^.ColorFlags[state] and rcBg) = 0 then
			    raise EPropertyValueNotAvailable.Create('(rcstyle) Property value of Bg not available');
			    
			  Result := rc^.Bg[state];
			end;
		""",
		"SetBgColor": """
			published procedure SetBgColor(state: DGtkWidgetState; const value: DGdkColor);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.ColorFlags[state] := rc^.ColorFlags[state] or rcBg;
			  rc^.Bg[state] := value;
			end;
		""",
		"GetTextColor": """
			published function GetTextColor(state: DGtkWidgetState): DGdkColor;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  if (rc^.ColorFlags[state] and rcText) = 0 then
			    raise EPropertyValueNotAvailable.Create('(rcstyle) Property value of Text not available');
			  Result := rc^.Text[state];
			end;
		""",
		"SetTextColor": """
			published procedure SetTextColor(state: DGtkWidgetState; const value: DGdkColor);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.ColorFlags[state] := rc^.ColorFlags[state] or rcText;
			  rc^.Text[state] := value;
			end;
		""",
		"GetBaseColor": """
			published function GetBaseColor(state: DGtkWidgetState): DGdkColor;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  if (rc^.ColorFlags[state] and rcBase) = 0 then 
			    raise EPropertyValueNotAvailable.Create('(rcstyle) Property value of Base not available');
			  Result := rc^.Base[state];
			end;
		""",
		"SetBaseColor": """
			published procedure SetBaseColor(state: DGtkWidgetState; const value: DGdkColor);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.ColorFlags[state] := rc^.ColorFlags[state] or rcBase;
			  rc^.Base[state] := value;
			end;
		""",
		"GetXThickness": """
			published function GetXThickness: Integer;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  Result := rc^.XThickness;
			end;
		""",
		"SetXThickness": """
			published procedure SetXThickness(const value: Integer);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.XThickness := value;
			end;
		""",
		"GetYThickness": """
			published function GetYThickness: Integer;
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  Result := rc^.YThickness;
			end;
		""",
		"SetYThickness": """
			published procedure SetYThickness(const value: Integer);
			var
			  rc: PGtkRcStyle;
			begin
			  rc := PGtkRcStyle(GetUnderlying);
			  rc^.YThickness := value;
			end;
		""",
	},
	"GtkObject": { # make that a property ? guess not
		# for now, I sink on destroy and not on create
		#"Created": """
		#	published procedure Created; override;
		#	begin
		#	  if IsFloating then begin
		#	    (* RefUnderlyingObject; done already (before CreateWrapped or in Create) *)
		#	    SinkUnderlyingObject;
		#	  end;
		#	  inherited;
		#	end;
		#""",
		"IsFloating": """
			published function IsFloating: Boolean;
			const
			  gtkFloating = 1 shl 1; // hacky
			begin
			  Result := (PGtkObject(Fobject)^.Flags and gtkFloating) <> 0;
			end;
		""",
	},
	"GtkTreeModelFilter": {
		"Create": """
			public constructor Create(model: IGtkTreeModel; virtualRoot: IGtkTreePath = nil); reintroduce;
			var
			  croot: PGtkTreePath;
			  cmodel: PGtkTreeModel;
			begin 
			  croot := nil;
			  assert(Assigned(model));
			  cmodel := model.GetUnderlying;
			  assert(Assigned(cmodel));
			  if Assigned(virtualRoot) then
			    croot := virtualRoot.GetUnderlying;
			    
			  CreateWrapped(gtk_tree_model_filter_new(cmodel, croot));
			end;
		""",
	},
	"GtkTreeModelSort": {
		"Create": """
			public constructor Create(model: IGtkTreeModel); reintroduce;
			begin
			  assert(Assigned(model));
			  CreateWrapped(gtk_tree_model_sort_new_with_model(model.GetUnderlying));
			end;
		""",
	},
	"GtkTreeStore": {
		"Reorder": """
			published procedure Reorder(const parent: DGtkTreeIter; neworder: TIntegerArray);
			var
			  i: Integer;
			  arr: TgintArray;
			begin
			  assert(Length(neworder) >= gtk_tree_model_iter_n_children(PGtkTreeModel(Fobject), @parent));
			  SetLength(arr, Length(neworder));
			  for i := Low(neworder) to High(neworder) do
			    arr[i] := neworder[i];
			    
			  gtk_tree_store_reorder(PGtkTreeStore(Fobject), @parent, arr);
			end;
		""",
		"SetValue": """
			published procedure SetValue(const iter: DGtkTreeIter; column: Integer; value: Variant);
			var
			  gvalue: TGValue;
			begin
			  gvalue := gValueInit(G_TYPE_INT);
			  gValueFromVariant(gvalue, value);
			  gtk_tree_store_set_value(PGtkTreeStore(Fobject), PGtkTreeIter(@iter), column, @gvalue);
			  gValueUnset(gvalue);
			end;
		"""
	},
	"GtkListStore": {
		"GetCellValue": """
			published function GetCellValue(row, column: Integer): Variant;
			var
			  iter: DGtkTreeIter;
			begin
			  (* slow *)
			  if not GetIter(iter, DGtkTreePath.CreateFromIndices([row])) then
			    Result := Null (* FIXME exception? *)
			  else
			    GetValue(iter, column, Result);
			end;
		""",
		"SetCellValue": """
			published procedure SetCellValue(row, column: Integer; const value: Variant);
			var
			  iter: DGtkTreeIter;
			begin
			  (* slow *)
			  if GetIter(iter, DGtkTreePath.CreateFromIndices([row])) then
			    SetValue(iter, column, value);
			  (* FIXME else exception ? *)
			end;
		""",
		"Reorder": """
			published procedure Reorder(neworder: TIntegerArray);
			var
			  i: Integer;
			  arr: TgintArray;
			begin
			  assert(Length(neworder) >= gtk_tree_model_iter_n_children(PGtkTreeModel(Fobject), nil));
			  SetLength(arr, Length(neworder));
			  for i := Low(neworder) to High(neworder) do
			    arr[i] := neworder[i];
			    
			  gtk_list_store_reorder(PGtkListStore(Fobject), arr);
			end;
		""",
		"SetValue": """
			published procedure SetValue(const iter: DGtkTreeIter; column: Integer; value: Variant);
			var
			  gvalue: TGValue;
			begin
			  gvalue := gValueInit(G_TYPE_INT);
			  gValueFromVariant(gvalue, value);
			  gtk_list_store_set_value(PGtkListStore(Fobject), PGtkTreeIter(@iter), column, @gvalue);
			  gValueUnset(gvalue);
			end;
		"""
	},
	"GtkTreeSelection": {
		"GetSelected": """
			published function GetSelected(out model: IGtkTreeModel; out iter: DGtkTreeIter): Boolean; overload;
			var 
			  cmodel: PGtkTreeModel;
			begin
			  cmodel := nil;
			  Result := gtk_tree_selection_get_selected(PGtkTreeSelection(Fobject), @cmodel, @iter);
			  
			  if Assigned(cmodel) then
			    model := DGObjectDescendantGetOrCreateWrapper(cmodel, DGtkTreeModel) as IGtkTreeModel
			  else
			    model := nil;
			end;
		""",
		"GetSelected+": """
			published function GetSelected(out iter: DGtkTreeIter): Boolean; overload;
			begin
			  Result := gtk_tree_selection_get_selected(PGtkTreeSelection(Fobject), nil, @iter);
			end;
		""",
		"GetSelectedRows": """
			published function GetSelectedRows(out model: IGtkTreeModel): TDGtkTreeIterArray; overload;
			var 
			  cmodel: PGtkTreeModel;
			  aglist: PGList;
			  xaglist: PGList;
			  xiter: PGtkTreeIter;
			  i: Integer;
			begin
			  aglist := gtk_tree_selection_get_selected_rows(PGtkTreeSelection(Fobject), @cmodel);
			  if Assigned(cmodel) then
			    model := DGObjectDescendantGetOrCreateWrapper(cmodel, DGtkTreeModel) as IGtkTreeModel
			  else
			    model := nil;

                          SetLength(Result, 0);
                          if Assigned(aglist) then begin
                            SetLength(Result, g_list_length(aglist));
                            xaglist := aglist;
                            i := 0;
                            while Assigned(xaglist) do begin
                              xiter := PGtkTreeIter(xaglist^.data);
                              Result[i] := DGtkTreeIter(xiter^);
                              gtk_tree_path_free(xiter);
                              xaglist := g_list_next(xaglist);
                              Inc(i);
                            end;
                            g_list_free(aglist);
                          end;
			end;
		""",
		"GetSelectedRows+": """
			published function GetSelectedRows: TDGtkTreeIterArray; overload;
			var 
			  aglist: PGList;
			  xaglist: PGList;
			  xiter: PGtkTreeIter;
			  i: Integer;
			begin
			  aglist := gtk_tree_selection_get_selected_rows(PGtkTreeSelection(Fobject), nil);

                          SetLength(Result, 0);
                          if Assigned(aglist) then begin
                            SetLength(Result, g_list_length(aglist));
                            xaglist := aglist;
                            i := 0;
                            while Assigned(xaglist) do begin
                              xiter := PGtkTreeIter(xaglist^.data);
                              Result[i] := DGtkTreeIter(xiter^);
                              gtk_tree_path_free(xiter);
                              xaglist := g_list_next(xaglist);
                              Inc(i);
                            end;
                            g_list_free(aglist);
                          end;
			end;
		""",
	},
	"GtkTreeView": {
		"GetCursor": """
			published procedure GetCursor(out path: IGtkTreePath; out focusedColumn: IGtkTreeViewColumn);
			var
			  cpath: PGtkTreePath;
			  ccolumn: PGtkTreeViewColumn;
			begin
			  gtk_tree_view_get_cursor(PGtkTreeView(Fobject), @cpath, @ccolumn);
			  if Assigned(cpath) then
			    path := DGtkTreePath.CreateWrapped(cpath)
			  else
			    path := nil;
			    
			  if Assigned(ccolumn) then
			    focusedColumn := DGObjectDescendantGetOrCreateWrapper(ccolumn, DGtkTreeViewColumn) as IGtkTreeViewColumn
			  else
			    focusedColumn := nil;
			end;
		""",
		"GetDestRowAtPos": """
			published function GetDestRowAtPos(dragX, dragY: Integer; out path: IGtkTreePath; out pos: DGtkTreeViewDropPosition): Boolean;
			var
			  cdroppos: TGtkTreeViewDropPosition;
			  cpath: PGtkTreePath;
			begin
			  cpath := nil;
			  Result := gtk_tree_view_get_dest_row_at_pos(PGtkTreeView(Fobject), gint(dragX), gint(dragY),
			    @cpath, @cdroppos);
			  pos := DGtkTreeViewDropPosition(cdroppos);
			  if Assigned(cpath) then
			    path := DGtkTreePath.CreateWrapped(cpath)
			  else
			    path := nil;
			end;
		""",
		"GetDragDestRow": """
			published procedure GetDragDestRow(out path: IGtkTreePath; out pos: DGtkTreeViewDropPosition);
			var
			  cdroppos: TGtkTreeViewDropPosition;
			  cpath: PGtkTreePath;
			begin
			  gtk_tree_view_get_drag_dest_row(PGtkTreeView(Fobject), @cpath, @cdroppos);
			  pos := DGtkTreeViewDropPosition(cdroppos);
			  if Assigned(cpath) then
			    path := DGtkTreePath.CreateWrapped(cpath)
			  else
			    path := nil;
			end;
		""",
		"GetPathAtPos": """
			published function GetPathAtPos(x,y: Integer; out path: IGtkTreePath; out column: IGtkTreeViewColumn; var cellX, cellY: Integer): Boolean;
			var
			  cpath: PGtkTreePath;
			  ccolumn: PGtkTreeViewColumn;
			  ccellx, ccelly: gint;
			begin
			  Result := gtk_tree_view_get_path_at_pos(PGtkTreeView(Fobject), gint(x), gint(y),
			    @cpath, @ccolumn, @ccellx, @ccelly);
			    
			  if Assigned(cpath) then
			    path := DGtkTreePath.CreateWrapped(cpath)
			  else
			    path := nil;
			    
			  if Assigned(ccolumn) then
			    column := DGObjectDescendantGetOrCreateWrapper(ccolumn, DGtkTreeViewColumn) as IGtkTreeViewColumn
			  else
			    column := nil;
			    
			  CellX := Integer(ccellx);
			  CellY := Integer(ccelly);
			end;
		""",
	},
	"GtkWidget": {
		"GetPath": """
			published function GetPath: %(pstringtype)s;
			var
			  aglist: PGChar;
			begin
			  SetLength(Result, 0);
			  
			  aglist := nil;
			  gtk_widget_path(PGtkWidget(Fobject), nil, @aglist, nil);
			  
			  Result := PChar(aglist); // utf ?
			  g_free(aglist);
			end;
		""" % pvars,
		"GetClassPath": """
			published function GetClassPath: %(pstringtype)s;
			var
			  aglist: PGChar;
			begin
			  SetLength(Result, 0);
			  aglist := nil;
			  gtk_widget_class_path(PGtkWidget(Fobject), nil, @aglist, nil);
			  
			  Result := PChar(aglist); // utf ?
			  g_free(aglist);
			end;
		""" % pvars,
		"GetWidgetFlags": """
			published function GetWidgetFlags: DGtkWidgetFlags;
			begin
			  Result := gtkWidgetFlagsFromNative(GTK_WIDGET_GET_FLAGS(PGtkWidget(Fobject)));
			end;
		""",
		"SetWidgetFlags": """
			published procedure SetWidgetFlags(flags: DGtkWidgetFlags);
			begin
			  GTK_WIDGET_SET_FLAGS(PGtkWidget(Fobject), gtkWidgetFlagsToNative(flags));
			end;
		""",
	},
	
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
			  Result := DGObjectDescendantGetOrCreateWrapper(cgroup, DGnomeCanvasGroup) as IGnomeCanvasGroup;
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
	
	## DiaCanvas
	"DiaCanvas": {
		"GetRoot": """
			published function GetRoot: IDiaCanvasGroup;
			begin
			  Result := DDiaCanvasGroup.CreateWrapped(dia_canvas_root(PDiaCanvas(fObject))) as IDiaCanvasGroup;
			end;
		""",
		"GlueHandle": """
			published function GlueHandle(const handle: IDiaHandle; const destX, destY: gdouble; out glueX, glueY: gdouble; out item: IDiaCanvasItem): gdouble;
			var
			  citem: PDiaCanvasItem;
			begin
			  assert(Assigned(handle));
			  citem := nil;
			  Result := dia_canvas_glue_handle(PDiaCanvas(Fobject), 
			    handle.GetUnderlying,
			    destX, destY, @glueX, @glueY,
			    @citem			    
			  );
			  
			  if Assigned(citem) then
			    item := DGObjectDescendantGetOrCreateWrapper(citem, DDiaCanvasItem) as IDiaCanvasItem
			  else
			    item := nil;
			end;
		""",
		"Preserve": """
			published procedure Preserve(object1: IGObject; propertyName: UTF8String; value: Variant; after: Boolean = False);
			var
			  gvalue: TGValue;
			begin
			  assert(Assigned(object1));
			  assert(Assigned(object1.GetUnderlying));
			  gvalue := gValueInit(G_TYPE_INT);
			  gValueFromVariant(gvalue, value);
			  dia_canvas_preserve(PDiaCanvas(Fobject), object1.GetUnderlying, PChar(propertyName),
			    @gvalue, after);
			  gValueUnset(gvalue);
			end;
		""",
	},
	"DiaCanvasItem": {
		"GetItemToWorldAffine": """
			published function GetItemToWorldAffine: TAffineTransform;
			begin
			  dia_canvas_item_affine_i2w(PDiaCanvasItem(Fobject), Result);
			end;
		""",
		"GetWorldToItemAffine": """
			published function GetWorldToItemAffine: TAffineTransform;
			begin
			  dia_canvas_item_affine_w2i(PDiaCanvasItem(Fobject), Result);
			end;
		""",
		#"GetItemToCanvasPixelAffine":
		"WorldToItemCoords": """
			published function WorldToItemCoords(const source: DArtPoint): DArtPoint;
			begin
			  Result.x := source.x;
			  Result.y := source.y;
			  dia_canvas_item_affine_point_w2i(PDiaCanvasItem(Fobject), @Result.x, @Result.y);
			end;
		""",
		"ItemToWorldCoords": """
			published function ItemToWorldCoords(const source: DArtPoint): DArtPoint;
			begin
			  Result.x := source.x;
			  Result.y := source.y;
			  dia_canvas_item_affine_point_i2w(PDiaCanvasItem(Fobject), @Result.x, @Result.y);
			end;
		""",
		#"SetAffine":
		#"ModAffineRelative":
		# calculate the bounding box of item after a affine transformation
		
		"GetBoundingBoxAffine": """
			published function GetBoundingBoxAfterAffine(const affine: TAffineTransform): DDiaRectangle;
			begin
			  dia_canvas_item_bb_affine(PDiaCanvasItem(Fobject), affine, 
			   @Result.left,
			   @Result.top,
			   @Result.right,
			   @Result.bottom
			  );
			end;
		""",
		"GetShapes": """
			protected function GetShapes: IDiaCanvasItemShapes;
			begin
			  if not Assigned(FshapesProxy) then
			    if InterlockedIncrement(FshapesProxyLocked) = 1 then
			      FshapesProxy := DDiaCanvasItemShapes.Create(Self)
			    else
			      InterlockedDecrement(FshapesProxyLocked);
			      
			  Result := FshapesProxy;
			end;
		""",
		"UpdateChild": """
			published procedure UpdateChild(child: IDiaCanvasItem; const affine: TAffineTransform);
			begin
			  assert(Assigned(child));
			  dia_canvas_item_update_child(PDiaCanvasItem(Fobject), child.GetUnderlying,
			    affine
			  );
			end;
		""",
	},
	"DiaCanvasGroup": {
		"Next": "function IDiaCanvasGroupable.Next=IterNext;",
		"Pos": "function IDiaCanvasGroupable.Pos=IndexOf;",
		"Length": "function IDiaCanvasGroupable.Length=Count;",
		"Value": "function IDiaCanvasGroupable.Value=GetItem1;",
		"GetIter": "function IDiaCanvasGroupable.GetIter=IterFirst;",
		
		# ugh!
		"CreateItem": """
			published function CreateItem(kind: TGObjectClass): IDiaCanvasItem;
			begin
			  (* TODO ! *)
			  Result := nil;
			  (*dia_canvas_group_create_item(GetUnderlying, kind.GType??, nil);*)
			end;
		""",
		
		"IterFirst": """
			published function IterFirst(out iter: DDiaCanvasIter): Boolean;
			begin
			  Result := dia_canvas_groupable_get_iter(Fobject, @iter);
			end;
		""",
		"IndexOf": """
			published function IndexOf(item: IDiaCanvasItem): Integer;
			begin
			  assert(Assigned(item));
			  assert(Assigned(item.GetUnderlying));
			  Result := dia_canvas_groupable_pos(Fobject, item.GetUnderlying);
			end;
		""",
		"Count": """
			published function Count: Integer;
			begin
			  Result := dia_canvas_groupable_length(Fobject);
			end;
		""",
		"GetItem1": """
			published function GetItem1(const iter: DDiaCanvasIter): IDiaCanvasItem;
			var
			  citem: Pointer;
			begin
			  citem := dia_canvas_groupable_value(Fobject, @iter);
			  if Assigned(citem) then
			    Result := DGObjectDescendantGetOrCreateWrapper(citem) as IDiaCanvasItem
			  else
			    Result := nil (* fixme exception ? *)
			end;
		""",
		"IterNext": """
			published function IterNext(var iter: DDiaCanvasIter): Boolean;
			begin
			  Result := dia_canvas_groupable_next(Fobject, @iter);
			end;
		""",
		"Add": """
			published procedure Add(item: IDiaCanvasItem);
			begin
			  assert(Assigned(item));
			  assert(Assigned(item.GetUnderlying));
			  dia_canvas_groupable_add(Fobject, item.GetUnderlying);
			end;
		""",
		"Remove": """
			published procedure Remove(item: IDiaCanvasItem);
			begin
			  assert(Assigned(item));
			  assert(Assigned(item.GetUnderlying));
			  dia_canvas_groupable_remove(Fobject, item.GetUnderlying);
			end;
		""",
	},
	"DiaHandle": {
		"UpdateWorldToItem": """
			published procedure UpdateWorldToItem;
			begin
			  dia_handle_update_w2i(PDiaHandle(Fobject));
			end;
		""",
		"UpdateItemToWorldWithAffine": """
			published procedure UpdateItemToWorldWithAffine(const affine: TAffineTransform);
			begin
			  dia_handle_update_i2w_affine(PDiaHandle(Fobject), affine);
			end;
		""",
		"UpdateWorldToItemWithAffine": """
			published procedure UpdateWorldToItemWithAffine(const affine: TAffineTransform);
			begin
			  dia_handle_update_w2i_affine(PDiaHandle(Fobject), affine);
			end;
		""",
		"RequestUpdateWorldToItem": """
			published procedure RequestUpdateWorldToItem;
			begin
			  dia_handle_request_update_w2i(PDiaHandle(Fobject));
			end;
		""",
		"DistanceWorld": """
			published function DistanceWorld(const x,y: Double): Double;
			begin
			  Result := dia_handle_distance_w(PDiaHandle(Fobject), x,y);
			end;
		""",
		"DistanceItem": """
			published function DistanceItem(const x,y: Double): Double;
			begin
			  Result := dia_handle_distance_i(PDiaHandle(Fobject), x,y);
			end;
		""",
		"SetPosItemAffine": """
			published procedure SetPosItemAffine(const x,y: Double; const affine: TAffineTransform);
			begin
			  dia_handle_set_pos_i_affine(PDiaHandle(Fobject), x,y, affine);
			end;
		""",
	},
	"DiaCanvasView": {
		"MoveSelected": """
			published procedure MoveSelected(dx,dy: Double; originator: IDiaCanvasViewItem);
			var
			  corig: Pointer;
			begin
			  if Assigned(originator) then
			    corig := originator.GetUnderlying
			  else
			    corig := nil;
			  
			  dia_canvas_view_move(PDiaCanvasView(Fobject), dx, dy, corig);
			end;
		""",
	},
	"DiaCanvasText": {
		"EditingDone": """
			published procedure EditingDone(textShape: IDiaShapeText; newText: UTF8String);
			var
			  cshape: PDiaShapeText;
			begin
			  // implements IDiaCanvasEditable
			  assert(Assigned(textShape));
			  cshape := textShape.GetUnderlying;
			  dia_canvas_editable_editing_done(PDiaCanvasEditable(Fobject), cshape, PGChar(PChar(newText)));
			end;
		""",
		"TextChanged": """
			published procedure TextChanged(textShape: IDiaShapeText; newText: UTF8String);
			var
			  cshape: PDiaShapeText;
			begin
			  // implements IDiaCanvasEditable
			  assert(Assigned(textShape));
			  cshape := textShape.GetUnderlying;
			  dia_canvas_editable_text_changed(PDiaCanvasEditable(Fobject), cshape, PGChar(PChar(newText)));
			end;
		""",
		"StartEditing": """
			published procedure StartEditing(textShape: IDiaShapeText);
			var
			  cshape: PDiaShapeText;
			begin
			  // implements IDiaCanvasEditable
			  assert(Assigned(textShape));
			  cshape := textShape.GetUnderlying;
			  dia_canvas_editable_start_editing(PDiaCanvasEditable(Fobject), cshape);
			end;
		""",
	}
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
	"GdkGC": {
		"Screen": "public property Screen: IGdkScreen read GetScreen;",
		"Colormap": "public property Colormap: IGdkColormap read GetColormap write SetColormap;",
		"SubwindowMode": "public property SubwindowMode: DGdkSubwindowMode read GetSubwindow write SetSubwindow;",
		#"RgbBgColor": "public property Color: DGdkColor write SetRgbBgColor;",
		#"RgbFgColor": "public property Color: DGdkColor write SetRgbFgColor;",
		"Stipple": "public property Stipple: IGdkPixmap read GetStipple write SetStipple;",
		#"TSOriginX,y",
		#"Dashes",
		"Tile": "public property Tile: IGdkPixmap read GetTile write SetTile;",
		"ClipRegion": "public property ClipRegion: IGdkRegion write SetClipRegion;",
		"FillMode": "public property FillMode: DGdkFill read GetFill write SetFill;",
		"ClipRectangle": "public property ClipRectangle: DGdkRectangle write SetClipRectangle;",
		#"LineAttributes",
		# ClipOrigin
		"Foreground": "public property Foreground: DGdkColor read GetForeground write SetForeground;",
		"Background": "public property Background: DGdkColor read GetBackground write SetBackground;",
		"FunctionMode": "public property FunctionMode: DGdkFunction read GetFunction write SetFunction;",
		# Offset,
		"ClipMask": "public property ClipMask: IGdkBitmap read GetClipMask write SetClipMask;",
		"Exposures": "public property Exposures: Boolean write SetExposures;",
	},
	"GtkFileFilter": {
		"Name": "public property Name: %(pstringtype)s read GetName write SetName;" % pvars,
	},
	"GtkRcStyle": {
		"BgPixmapName": "public property BgPixmapName[state: DGtkWidgetState]: %(pstringtype)s read GetBgPixmapName write SetBgPixmapName;" % pvars,
		"ColorFlags": "public property ColorFlags[state: DGtkWidgetState]: DGtkRcFlags read GetColorFlags write SetColorFlags;",
		"FontDesc": "public property FontDesc: IPangoFontDescription read GetFontDesc write SetFontDesc; // nullable",
		"Fg": "public property Fg[state: DGtkWidgetState]: DGdkColor read GetFgColor write SetFgColor;",
		"Bg": "public property Bg[state: DGtkWidgetState]: DGdkColor read GetBgColor write SetBgColor;",
		"Text": "public property Text[state: DGtkWidgetState]: DGdkColor read GetTextColor write SetTextColor;",
		"Base": "public property Base[state: DGtkWidgetState]: DGdkColor read GetBaseColor write SetBaseColor;",
		"XThickness": "public property XThickness: Integer read GetXThickness write SetXThickness;",
		"YThickness": "public property YThickness: Integer read GetYThickness write SetYThickness;",
	},
	"GtkCalendar": {
		"DisplayOptions": "published property DisplayOptions: DGtkCalendarDisplayOptions read GetDisplayOptions write SetDisplayOptions;",
	},
	"GtkWidget": {
		"Path": "public property Path: %(pstringtype)s read GetPath;" % pvars,
		"ClassPath": "public property ClassPath: %(pstringtype)s read GetClasspath;" % pvars, # that seems SO wrong
		"WidgetFlags": "published property WidgetFlags: DGtkWidgetFlags read GetWidgetFlags write SetWidgetFlags;",
	},
	"GtkListModel": {
		"Items": "public property Items[row, column: Integer]: Variant read GetCellValue; default;",
	},
	"GtkListStore": {
		"Items": "public property Items[row, column: Integer]: Variant read GetCellValue write SetCellValue; default;",
	},
	"GtkTable": {
		"ColSpacing": "public property ColSpacing: guint read GetDefaultColSpacing write SetColSpacings;",
	},
	"GtkToggleAction": {
		"Active": "public property Active: Boolean read GetActive write SetActive;",
	},
	
	## GnomeCanvas
	"GnomeCanvas": {
		"Root": "published property Root: IGnomeCanvasGroup read GetRoot;",
	},
	
	## DiaCanvas
	"DiaCanvasItem": {
		#already there "Visible": "published property Visible: Boolean read IsVisible write SetVisible;",
		"Focused": "published property Focused: Boolean read IsFocused;",
		"Selected": "published property Selected: Boolean read IsSelected;",
		"Grabbed": "published property Grabbed: Boolean read IsGrabbed;",
		"Shapes": "published property Shapes: IDiaCanvasItemShapes read GetShapes;",
	},
	"DiaCanvas": {
		"Root": "published property Root: IDiaCanvasGroup read GetRoot;",
	},
}

# functions to be skipped and not be wrapped
cskipfuncs = [
	"gdk_gc_copy", # this is more like 'transfer'
	"gdk_gc_new_with_values", # no need
	"gdk_display_get_pointer",
	"gdk_spawn_on_screen", # not exposed in a class
	"gdk_spawn_on_screen_with_pipes", # not exposed in a class
	"gtk_clist_get_pixmap", # clist not wrapped
	"gtk_clist_get_pixtext", # clist not wrapped
	"gtk_clist_get_text", # clist not wrapped
	"gtk_color_selection_palette_from_string", # FIXME
	"gtk_container_get_focus_chain", # FIXME
	"gtk_ctree_get_node_info", # ctree not wrapped
	"gtk_ctree_node_get_pixmap", # ctree not wrapped
	"gtk_ctree_node_get_pixtext", # ctree not wrapped
	"gtk_ctree_node_get_text", # ctree not wrapped
	"gtk_icon_info_get_attach_points",
	"gtk_icon_theme_get_search_path", # FIXME
	"gtk_icon_theme_set_search_path", # FIXME doesnt work either for some reason
	"gtk_image_get", # DEPRECATED
	"gtk_im_context_get_preedit_string", 
	"gtk_im_context_get_surrounding",
	"gtk_label_get", # DEPRECATED
	"gtk_pixmap_get", # DEPRECATED
	"gtk_tooltips_get_info_from_tip_window", ### ???
	"gtk_tree_selection_get_selected", # manually
	"gtk_tree_selection_get_selected_rows", # manually
	"gtk_tree_view_get_cursor", # manually
	"gtk_tree_view_get_dest_row_at_pos", # manually 
	"gtk_tree_view_get_drag_dest_row", # manually
	"gtk_tree_view_get_path_at_pos", # manually
	"gtk_widget_class_path", # manually
	"gtk_widget_destroyed",
	"gtk_widget_path", # manually
	"gdk_display_peek_event", # needs event FIXME
	"gdk_display_put_event", # needs event FIXME
	"gdk_display_get_event", # needs event FIXME
	"gdk_screen_broadcast_client_message", # needs event FIXME
	"gdk_display_set_pointer_hooks",
	"gdk_pixmap_colormap_create_from_xpm", # FIXME
	"gdk_pixmap_colormap_create_from_xpm_d", # FIXME
	"gdk_pixmap_create_from_xpm", # FIXME
	"gdk_pixmap_create_from_xpm_d", # FIXME
	"gdk_window_get_internal_paint_info", # ??
	"gdk_device_get_history", # FIXME
	"gdk_device_free_history", # FIXME
	"gtk_container_class_list_child_properties",
	"gdk_drawable_unref", # DEPRECATED
	"gtk_widget_unref", # DEPRECATED
	"gtk_style_unref", # DEPRECATED
	"gtk_object_unref", # DEPRECATED
	"gdk_drawable_ref", # DEPRECATED
	"gtk_widget_ref", # DEPRECATED
	"gtk_style_ref", # DEPRECATED
	"gtk_object_ref", # DEPRECATED
	"gdk_query_depths", # O_o
	"gdk_query_visual_types",
	"gdk_colormap_ref", # DEPRECATED
	"gdk_colormap_unref", # DEPRECATED
	"gdk_region_get_rectangles", # manually
	"gdk_colors_alloc", # DEPRECATED
	"gdk_colors_free", # DEPRECATED
	"gdk_gc_get_values", # instead expose new properties.
	"gdk_gc_set_values", # instead expose new properties.
	"gdk_gc_ref", # DEPRECATED
	"gdk_gc_unref", # DEPRECATED
	"gdk_gc_set_font", # DEPRECATED
	"gdk_drawable_get_data", # DEPRECATED
	"gdk_drawable_set_data", # DEPRECATED
	"gdk_draw_layout_line", # structure... FIXME
	"gdk_draw_string", # DEPRECATED
	"gdk_draw_text", # DEPRECATED
	"gdk_draw_text_wc", # DEPRECATED
	"gdk_draw_layout_line_with_colors", # DEPRECATED
	"gdk_draw_glyphs", # havent done IPangoGlyphString yet
	"gdk_window_set_geometry_hints", # dont have the struct yet
	"gdk_window_constrain_size", # dont have the struct yet
	"gdk_window_set_user_data", # 'nearly' deprecated
	"gdk_window_get_user_data", # 'nearly' deprecated
	"gdk_window_invalidate_maybe_recurse", # dont want to do that. someone fix that.
	"gdk_screen_get_setting", # dont support GValues yet
	"gdk_display_get_core_pointer", # wrong section in docs (display_manager)
	"gdk_spawn_command_line_on_screen", # not wrapped in lowlevel [part of gdkscreen?]
	"gdk_pixbuf_loader_get_format", # type mismatch, too lazy to look why
	"gtk_object_remove_data_by_id", # DEPRECATED
	"gtk_action_group_add_actions", # dont have the struct
	"gtk_action_group_add_actions_full", # dont have the struct
	"gtk_action_group_add_radio_actions", # dont have the struct
	"gtk_action_group_add_radio_actions_full", # dont have the struct
	"gtk_action_group_add_toggle_actions", # dont have the struct
	"gtk_action_group_add_toggle_actions_full", # dont have the struct
	"gtk_object_weakref", # DEPRECATED
	"gtk_object_weakunref", # DEPRECATED
	"gtk_object_get", # DEPRECATED
	"gtk_object_new", # DEPRECATED
	#"gtk_widget_get_accessible", # dont have atk yet
	"gtk_widget_get_ancestor", # looks cool, but I dont want to expose GType. Add class support and fix that.
	"gtk_widget_style_get_valist", # valist
	"gtk_widget_style_get", # dot dot dot
	"gtk_widget_style_get_property", # TODO
	"gtk_widget_class_list_style_properties", # ??
	"gtk_container_child_type", # TODO (GType)
	"gtk_container_set_focus_chain", # TODO passing of GLists
	"gtk_container_add_with_properties", # dot dot dot
	"gtk_container_child_set_valist", # varargs
	"gtk_container_child_get_valist", # varargs
	"gtk_container_child_set", # dot dot dot
	"gtk_container_child_get", # dot dot dot
	"gtk_container_child_set_property", # gvalue
	"gtk_container_child_get_property", # gvalue
	"gtk_cell_layout_set_attributes", # dot dot dot FIXME provide replacement
	"gtk_tree_view_column_set_attributes", # dot dot dot FIXME provide replacement
	"pango_attr_list_ref",
	"pango_attr_list_unref",
	"gtk_window_set_geometry_hints", # fixme, i dont have that struct yet
	"gtk_dialog_add_buttons", # dot dot dot (fixme provide alternative)
	"gtk_font_selection_dialog_get_font", # DEPRECATED
	"gtk_font_selection_get_font", # DEPRECATED
	#"gtk_list_store_set_column_types", # TODO (GType)
	"gtk_radio_menu_item_get_group", # write-only property suffices for now
	"gtk_radio_menu_item_set_group", # write-only property suffices for now. there are more radio classes.
	"gtk_settings_set_property_value", # fixme, dont have GtkSettingsValue yet
	"gtk_style_render_icon", # const GtkIconSource? huh?
	"gtk_text_tag_event", # just no. perhaps when I'm really bored.
	"gtk_tree_selection_get_user_data", # ?
	"gdk_set_pointer_hooks", # dont need
	"gtk_tree_view_insert_column_with_data_func", # too redundant
	"gtk_tree_view_get_search_equal_func", # dont need
	"gtk_tree_view_set_destroy_count_func", # internal function it says
	"gtk_accel_group_ref", # DEPRECATED
	"gtk_accel_group_unref", # DEPRECATED
	"gtk_clipboard_wait_for_targets", # cannot do GdkAtom ** (too many pointers)
	"gtk_rc_set_default_files", # fixme too many pointers
	"gtk_object_remove_data", # DEPRECATED
	"gtk_object_new", # DEPRECATED
	"gtk_requisition_copy", # not needed in pascal, I think
	"gtk_widget_list_accel_closures", # cant do closures
	"gtk_widget_class_find_style_property", # cant do widget classes
	"gtk_widget_class_install_style_property", # cant do widget classes
	"gtk_widget_class_install_style_property_parser", # cant do widget classes
	# container_class likewise...
	#gtk_widget_push_colormap, pop_colormap ?
	"gtk_alignment_get_padding", # have properties already
	"gtk_alignment_set_padding", # have properties already
	"gtk_alignment_set", # have properties already
	"gtk_alignment_get", # have properties already
	"gtk_button_set_alignment", # have properties already
	"gtk_button_get_alignment", # have properties already
	"gtk_menu_item_activate", # gtk_widget_activate seems to do the same. fixme test.
	"gtk_rc_property_parse_requisition", # cant handle paramspec
	"gtk_rc_property_parse_border", # cant handle paramspec
	"gtk_rc_property_parse_color", # cant handle paramspec
	"gtk_rc_property_parse_enum", # cant handle paramspec
	"gtk_rc_property_parse_flags", # cant handle paramspec
	"gtk_rc_parse_state", # cant handle gscanner
	"gtk_rc_parse_priority", # cant handle gscanner
	"gtk_rc_parse_color", # cant handle gscanner
	"gtk_settings_install_property", # TODO
	"gtk_border_copy", # I think pascal does this
	"gtk_text_child_anchor_get_widgets", # manually in static/
	"gtk_text_child_anchor_get_deleted", # manually in static/
	"gtk_tooltips_data_get", # TODO ?
	"gtk_tree_path_get_depth", # manually in static/
	"gtk_tree_path_compare", # manually in static/
	"gtk_tree_path_copy", # manually in static/
	"gtk_tree_path_up", # manually in static/
	"gtk_tree_path_prev", # manually in static/
	"gtk_tree_path_is_descendant", # manually in static/
	"gtk_tree_path_to_string", # manually in static/
	"gtk_tree_path_get_indices", # manually in static/
	"gtk_tree_path_is_ancestor", # manually in static/
	"gtk_tree_path_down", # manually in static/
	"gtk_tree_path_next", # manually in static/
	"gtk_tree_path_prepend_index", # manually in static/
	"gtk_tree_path_append_index", # manually in static/
	"gtk_tree_path_free", # manually in static/
	"gtk_tree_iter_copy", # manually in static/
	"gtk_decorated_window_init", # TODO what is that
	"gtk_decorated_window_move_resize_window", # TODO what is that
	"gtk_decorated_window_calculate_frame_size", # TODO what is that
	"gtk_settings_install_property_parser", # not supported, paramspec
	"gtk_curve_get_vector", # too lazy
	"gtk_curve_set_vector", # too lazy, FIXME!!
	"gdk_window_new", # too lazy
	#"gdk_image_new", # too lazy, GdkImageType
	"gtk_tree_iter_free", # not exposed
	"gtk_tree_row_reference_get_path", # manually in static/
	"gtk_tree_row_reference_copy", # manually in static/
	"gtk_tree_row_reference_free", # manually in static/
	"gtk_tree_row_reference_valid", # manually in static/
	"gtk_tree_row_reference_inserted", # ?
	"gtk_tree_row_reference_deleted", # ?
	"gtk_tree_row_reference_reordered", # ?
	"gtk_icon_info_get_display_name", # manually in static/
	"gtk_icon_info_get_embedded_rect", # manually in static/
	"gtk_icon_info_copy", # manually in static/
	"gtk_icon_info_get_base_size", # manually in static/
	"gtk_icon_info_get_filename", # manually in static/
	"gtk_icon_info_free", # manually in static/
	"gtk_icon_info_set_raw_coordinates", # manually in static/
	"gtk_icon_info_load_icon", # manually in static/
	"gtk_icon_info_get_builtin_pixbuf", # manually in static/
	"gtk_icon_theme_load_icon", # use gtk_icon_theme_lookup_icon and then gtk_icon_info_load_icon; TODO: add convenience func by hand
	"gtk_im_context_simple_add_table", # TODO overload that by hand O_O
	"gtk_text_attributes_copy", # manually!
	"gtk_text_attributes_unref", # manually!
	"gtk_text_attributes_ref", # manually!
	"gtk_text_attributes_copy_values", # manually!
	"gtk_tree_view_insert_column_with_attributes", # dot dot dot
	"gtk_rc_find_pixmap_in_path", # gscanner ?
	"gtk_rc_style_unref",
	"gtk_rc_style_ref",
	"gdk_color_copy",
	"gdk_color_hash", # hmm
	"gdk_color_equal",
	"gdk_color_free",
	"gtk_list_store_set_valist",
	"gtk_list_store_set",
	"gtk_list_store_set_value", # manual override
	"gtk_tree_store_set_value", # manual override
	"gtk_tree_store_set_valist",
	"gtk_tree_store_set",
	"gtk_tree_model_get",
	"gtk_tree_model_get_valist",
	"gtk_text_buffer_create_tag", # convenience only, just create the tag and add it to the buffer tag table
	"gtk_text_buffer_insert_with_tags", # convenience only, just call text_buffer_insert and then text_buffer_apply_tag
	"gtk_text_buffer_insert_with_tags_by_name",
	"gdk_drag_find_window", # fixme too many pointers
	"gdk_drag_find_window_for_screen", # fixme too many pointers
	#"gtk_widget_new", # dot dot dot
	"gtk_window_propagate_key_event", # dont have eventkey handy FIXME
	"gtk_window_activate_key", # dont have eventkey handy FIXME
	"gtk_im_context_filter_keypress", # dont have eventkey handy FIXME
	#"gtk_dialog_new_with_buttons", # dot dot dot
	#"gtk_file_chooser_dialog_new_with_backend", # dot dot dot
	"gtk_rc_scanner_new", # gscanner...
	"gtk_border_free", # gtkstyle messing
	"gtk_rc_get_default_files", # cant since gchar** returns are not handled properly it seems. here, that is.
	"gdk_pixbuf_format_get_description", # by hand
	"gdk_pixbuf_format_get_extensions", # by hand
	"gdk_pixbuf_format_get_mime_types", # by hand
	"gdk_pixbuf_format_get_name", # by hand
	"gdk_pixbuf_format_is_writable", # by hand
	"gdk_pixbuf_save", # GError not the last parameter: unsupported (use the V function and simulate)
	"gdk_pixbuf_save_to_buffer", # GError not the last parameter: unsupported (use the V function and simulate)
	"gdk_pixbuf_save_to_callback", # GError not the last parameter: unsupported (use the V function and simulate)
	"gdk_pixbuf_save_to_bufferv", # only in forceexternals and overridden
	"gdk_pixbuf_save_to_callbackv", # only in forceexternals and overridden
	"gdk_pixbuf_savev", # only in forceexternals and overridden
	"gtk_tree_store_reorder", # only in forceexternals and overridden
	"gtk_list_store_reorder", # only in forceexternals and overridden
	"gtk_box_pack_start_defaults", # already provided by normal defaults
	"gtk_box_pack_end_defaults", # already provided by normal defaults
	"gdk_pixbuf_render_pixmap_and_mask", # only in forceexternals and overridden
	"gdk_pixbuf_render_pixmap_and_mask_for_colormap", # only in forceexternals and overridden
	"gtk_container_foreach_full", # FIXME
	"gtk_tree_set_row_drag_data", # FIXME!
	"gtk_tree_get_row_drag_data", # FIXME!!
	"gtk_widget_destroy", # = gtk_object_destroy
	"atk_table_get_selected_rows", # too many pointers
	"atk_table_get_selected_columns", # too many pointers
	"atk_text_get_bounded_ranges", # too many pointers
	"atk_text_free_ranges", # too many pointers
	"gtk_show_about_dialog", # convenience
	"gtk_about_dialog_set_authors", # char**
	"gtk_about_dialog_set_documenters", # char**
	"gtk_about_dialog_set_artists", # char**
	"gtk_about_dialog_get_artists", # char**
	"gtk_about_dialog_get_authors", # char**
	"gtk_about_dialog_get_documenters", # char**
	
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
	
	## DiaCanvas cskipfuncs
	"dia_handle_layer_grab_handle", # DEPRECATED
	"dia_canvas_push_undo", # DEPRECATED
	"dia_canvas_pop_undo", # DEPRECATED
	"dia_canvas_clear_undo", # DEPRECATED
	"dia_canvas_get_undo_depth", # DEPRECATED
	"dia_canvas_pop_redo", # DEPRECATED
	"dia_canvas_clear_redo", # DEPRECATED
	"dia_canvas_get_redo_depth", # DEPRECATED
	"dia_canvas_set_undo_stack_depth", # DEPRECATED
	"dia_canvas_get_undo_stack_depth", # DEPRECATED
	"dia_canvas_groupable_add_construction", # DEPRECATED, use dia_canvas_item_set_parent
	"dia_canvas_groupable_remove_destruction", # DEPRECATED
	"dia_canvas_glue_handle", # too many pointers
	"dia_canvas_item_update_child", # manually
	"dia_canvas_item_affine_point_w2i", # manually
	"dia_canvas_item_affine_w2i", # manually
	"dia_canvas_item_bb_affine", # manually
	"dia_canvas_item_affine_i2w", # manually
	"dia_canvas_item_affine_point_i2w", # manually
	"dia_canvas_group_create_item", # manually
	"dia_handle_update_w2i", # manually
	"dia_handle_update_i2w_affine", # manually
	"dia_handle_update_w2i_affine", # manually
	"dia_handle_request_update_w2i", # manually
	"dia_handle_distance_w", # manually
	"dia_handle_distance_i", # manually
	"dia_handle_set_pos_i_affine", # manually
	"dia_canvas_item_create", # fixme use that ?
	"dia_canvas_preserve", # manually (variant)
	"dia_canvas_view_move", # renamed (manually)
	#"dia_default_tool_new",
	#"dia_placement_tool_new",
	#"dia_selection_tool_new",
	#"dia_item_tool_new",
	#"dia_handle_tool_new",
	"dia_stack_tool_push",
	"dia_stack_tool_pop",
	#"dia_stack_tool_new",
	"dia_canvas_group_foreach",
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
	"GdkFilterFunc": "DGdkFilterFunc",
	"GdkSpanFunc": "DGdkSpanFunc",
	"GdkPixbufSaveFunc": "TGdkPixbufSaveFunc",
	"GtkTranslateFunc": "DGtkTranslateFunc",
	"GDestroyNotify": "DGDestroyNotify",
	"GtkDestroyNotify": "DGDestroyNotify", # they are the same, it seems
	"GtkCallback": "DGtkCallback",
	"GtkCellLayoutDataFunc": "DGtkCellLayoutDataFunc",
	"GtkEntryCompletionMatchFunc": "DGtkEntryCompletionMatchFunc",
	"GtkFileFilterFunc": "DGtkFileFilterFunc",
	"GtkIconViewForeachFunc": "DGtkIconViewForeachFunc",
	"GtkMenuDetachFunc": "DGtkMenuDetachFunc",
	"GtkMenuPositionFunc": "DGtkMenuPositionFunc",
	"GtkTextTagTableForeach": "DGtkTextTagTableForeach",
	"GtkTreeModelFilterVisibleFunc": "DGtkTreeModelFilterVisibleFunc",
	"GtkTreeModelFilterModifyFunc": "DGtkTreeModelFilterModifyFunc",
	"GtkTreeModelForeachFunc": "DGtkTreeModelForeachFunc",
	"GtkTreeSelectionFunc": "DGtkTreeSelectionFunc",
	"GtkTreeSelectionForeachFunc": "DGtkTreeSelectionForeachFunc",
	"GtkTreeIterCompareFunc": "DGtkTreeIterCompareFunc",
	"GtkTreeCellDataFunc": "DGtkTreeCellDataFunc",
	"GtkTreeViewColumnDropFunc": "DGtkTreeViewColumnDropFunc",
	"GtkTreeViewSearchEqualFunc": "DGtkTreeViewSearchEqualFunc",
	"GtkTreeViewMappingFunc": "DGtkTreeViewMappingFunc",
	"GtkAccelGroupActivate": "DGtkAccelGroupActivate",
	"GtkAccelGroupFindFunc": "DGtkAccelGroupFindFunc",
	"GtkClipboardReceivedFunc": "DGtkClipboardReceivedFunc",
	"GtkClipboardTextReceivedFunc": "DGtkClipboardTextReceivedFunc",
	"GtkClipboardTargetsReceivedFunc": "DGtkClipboardTargetsReceivedFunc",
	"GtkClipboardGetFunc": "DGtkClipboardGetFunc",
	"GtkClipboardClearFunc": "DGtkClipboardClearFunc",
	"GtkColorSelectionChangePaletteWithScreenFunc": "DGtkColorSelectionChangePaletteWithScreenFunc",
	"GtkAboutDialogActivateLinkFunc": "DGtkAboutDialogActivateLinkFunc",
	
	## DiaCanvas c2pcallbackpointers
	"DiaCanvasItemForeachFunc": "DDiaCanvasItemForeachFunc",
	"DiaUndoFunc": "DDiaUndoFunc",
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
	"gtk_style_attach": [
		["interface", "IGtkStyle", "", "(*new*)"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_composite_color_simple": [
		["interface", "IGdkPixbuf", "", "(*new*)"], # return value override: new instance, fixme NULL on run out of memory
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_add_alpha": [
		["interface", "IGdkPixbuf", "", "(*new*)"], # return value override: new instance
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_scale_simple": [
		["interface", "IGdkPixbuf", "", "(*new*)"], # return value override: new instance
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_get_file_info": [
		["interface", "IGdkPixbufFormat", "", "(*new*)"], # return value override: gdkpixbuf owned info
		# TODO overload with just the format ?
	],	
	"gtk_icon_theme_lookup_icon": [
		["interface", "IGtkIconInfo", "gtk_icon_info_free(aglist);", ""], # GtkIconInfo is not a public struct
	],
	"gtk_rc_style_copy": [
		["interface", "IGtkRcStyle", "", ""],
	],
	"gtk_style_copy": [
		["interface", "IGtkStyle", "", ""],
	],
	"gtk_clipboard_get_display": [
		["interface", "IGdkDisplay", "", "g_object_ref(itemraw);"], 
	],
	"gtk_clipboard_get_owner": [
		["interface", "IGObject", "", "g_object_ref(itemraw);"], 
	],
	"gtk_clipboard_get": [
		["interface", "IGtkClipboard", "", "g_object_ref(itemraw);"], # actually the docs say dont do unref, but I cant
	],
	"gtk_clipboard_wait_for_contents": [
		["interface", "IGtkSelectionData", "gtk_selection_data_free(aglist);", ""], # nullable
	],
	"gtk_clipboard_wait_for_image": [
		["interface", "IGtkImage", "", ""], # TODO ref?  think not; this is 2.6 stuff
	],
	"gtk_clipboard_get_for_display": [
		["interface", "IGtkClipboard", "", "g_object_ref(itemraw);"],
	],
	"gtk_bin_get_child": [
		["interface", "IGtkWidget", "", "g_object_ref(itemraw);"],
	],
	"gdk_display_get_screen": [
		["interface", "IGdkScreen", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_drawable_get_display": [
		["interface", "IGdkDisplay", "", "g_object_ref(itemraw);"],
	],
	"gdk_drawable_get_clip_region": [
		["interface", "IGdkRegion", "", "(**)"], # fixme
	],
	"gdk_drawable_get_visible_region": [
		["interface", "IGdkRegion", "", "(**)"], # fixme
	],
	"gdk_drawable_copy_to_image": [
		["interface", "IGdkImage", "", "g_object_ref(itemraw);"],
	],
	"gdk_drawable_get_image": [
		["interface", "IGdkImage", "", "g_object_ref(itemraw);"],
	],
	"gdk_drawable_get_screen": [
		["interface", "IGdkScreen", "", "g_object_ref(itemraw);"],
	],
	"gdk_drawable_get_visual": [
		["interface", "IGdkVisual", "", "g_object_ref(itemraw);"],
	],
	"gdk_drawable_get_colormap": [
		["interface", "IGdkColormap", "", "g_object_ref(itemraw);"],
	],
	"gdk_gc_get_screen": [
		["interface", "IGdkScreen", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_gc_get_colormap": [
		["interface", "IGdkColormap", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_colormap_get_screen": [
		["interface", "IGdkScreen", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_display_manager_get": [
		["interface", "IGdkDisplayManager", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_accel_groups_from_object": [  # fixme test!
		["array", "GtkAccelGroup*", "", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_accelerator_name": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_icon_theme_get_example_icon_name": [
		[ "allocedstring", "char*", "g_free(aglist);", "" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_text_buffer_get_slice": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_text_buffer_get_text": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_icon_theme_list_icons": [
		["array", "gchar*", "g_list_free(aglist);", "// itemraw => String", "g_list_next", "g_free(itemraw);" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_widget_list_mnemonic_labels": [
		["array", "GtkWidget*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_icon_view_get_selected_items": [
		["array", "GtkTreePath*", "g_list_free(aglist);", "", "g_list_next", "(*auto gtk_tree_path_free(itemraw);*)"], # fixme this is a non-gobject
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_widget_list_accel_closures": [
		["array", "GClosure*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"], # TODO test
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_action_get_proxies": [
		["array", "GtkWidget*", "", "g_object_ref(itemraw);", "g_slist_next" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_screen_get_toplevel_windows": [
		["array", "GdkWindow*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_action_group_list_actions": [
		["array", "GtkAction*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_container_get_children": [
		[ "array", "GtkWidget*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	#"gtk_container_set_focus_chain": [
	#	[ "arrayset", "GtkWidget*", "g_list_free(aglist);", "", "g_list_append" ], # the source code comments says something about only containers in the chain. FIXME
	#	# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	#],
	"gdk_display_list_devices": [
		["array", "GdkDevice*", "", "" ]
	],
	
	"gdk_list_visuals": [
		["array", "GdkVisual*", "g_list_free(aglist);", "g_object_ref(itemraw);" ]
	],
	
	"gdk_display_manager_list_displays": [
		["array", "GdkDisplay*", "g_slist_free(aglist);", "g_object_ref(itemraw);" ]
	],
	
	"gdk_colormap_alloc_color": [
		None, # return value override
		None, # 1st (C) param override
		["var"] # 2nd (C) param: i/o
	],
	"gdk_colormap_alloc_colors": [
		None, # return value override
		None, # 1st (C) param override
		["varcarray", "GdkColor", "", ""], # 2nd (C) param
		["carrcount"], # 3rd (C) param
		None, # writable
		None, # bestmatch
		None, # success
	],
	"gdk_draw_lines": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["carray", "GdkPoint", "", ""], # 3rd (C) param override
		["carrcount"] # 4th (C) param override
	],
	"gdk_draw_points": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["carray", "GdkPoint", "", ""], # 3rd (C) param override
	],	
	"gdk_draw_polygon": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		["carray", "GdkPoint", "", ""], # 4th (C) param override
	],
	"gdk_region_spans_intersect_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["carray", "GdkSpan", "", ""], # 2nd (C) param override
		["carrcount"], # 3rd (C) param override
		None, # 4th (C) param override
		["ccallback"], # 5th (C) param override
		["userdata"], # 6th
	],
	
	"gdk_gc_set_dashes": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["carray", "gint8", "", ""], # 3rd
		["carrcount"] # 4th
	],
		
	"g_object_get_data": [
		["pointer"] # return value override. 
		# I make it a policy to have to explicity specify when I *do* want to use a pointer
		# (because in the future I'll likely scrap pointers altogether)
	],
	
	
	"gtk_file_filter_add_custom": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["ccallback"], # 3rd (C) param override
		["userdata"], # 4th (C) param override, user data
		["destroynotify"],
	],
	"gtk_cell_layout_set_cell_data_func": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["ccallback"], # 3rd (C) param override
		["userdata"],  # 4th (C) param override
		["destroynotify"],
	],
	"gtk_icon_view_selected_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override, user data
	],
	
	"gdk_object_set_data": [
		None, # return value override
		None, # 1st (C) param override
		["pointer"], # 2nd (C) param override
	],
	
	"gdk_window_remove_filter": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["pointer"], # 3rd (C) param override
	],
	
	"gdk_display_add_client_message_filter": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd
		None, # 3rd
		["pointer"] # 4th (C) param override
	],
	"gtk_action_group_set_translate_func": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
		["destroynotify"],
	],
	"gtk_container_forall": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_container_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gdk_window_add_filter": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["pointer"], # 3rd (C) param override
	],
	"gtk_entry_completion_set_match_func": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
		["destroynotify"],
	],	
	"gtk_window_get_icon_list": [
		["array", "GdkPixbuf*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gdk_window_set_icon_list": [
		None, # return value override
		None, # 1st (C) param override
		["array", "GdkPixbuf*", "g_list_free(aglist);", "" ] # 2nd (C) param override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gtk_window_set_icon_list": [
		None, # return value override
		None, # 1st (C) param override
		["array", "GdkPixbuf*", "g_list_free(aglist);", "" ] # 2nd (C) param override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gdk_window_get_children": [
		["array", "GdkWindow*", "g_list_free(aglist);", "g_object_ref(itemraw);" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gdk_window_peek_children": [
		["array", "GdkWindow*", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gtk_widget_get_composite_name": [
		[ "allocedstring", "", "" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gdk_screen_make_display_name": [
		[ "allocedstring", "", "g_free(aglist);", "" ],
		#  'listtype', itemtype(none), howtofree, actionforeach
	],
	
	"gdk_screen_list_visuals": [
		[ "array", "GdkVisual*", "g_list_free(aglist);", "", "g_list_next" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gdk_devices_list": [
		[ "array", "GdkDevice*", "", "", "g_list_next" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	
	"gtk_editable_get_chars": [
		[ "allocedstring", "", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],		
	"gdk_pixbuf_loader_close": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gdk_pixbuf_loader_write": [
		[ "errorcode", "FALSE" ], # return value override
		None, # 1st (C) param override
		[ "varany" ], # 2nd (C) param override
	],
	"gtk_file_chooser_add_shortcut_folder_uri": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_file_chooser_add_shortcut_folder": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_file_chooser_remove_shortcut_folder": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_file_chooser_remove_shortcut_folder_uri": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_file_chooser_list_shortcut_folders": [
		[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free(itemraw);" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_list_shortcut_folder_uris": [
		[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free(itemraw);" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_list_filters": [
		[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_preview_uri": [
		[ "allocedstring", "char*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_preview_filename": [
		[ "allocedstring", "char*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_current_folder": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_current_folder_uri": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_uri": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_filenames": [
		[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free(itemraw);" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_uris": [
		[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free(itemraw);" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_list_store_set_value": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # iter
		None, # column
		[ "type", "Variant" ], # gvalue
	],
	"gtk_tree_store_set_value": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # iter
		None, # column
		[ "type", "Variant" ], # gvalue
	],
	"gtk_list_store_set_column_types": [
		None, # return value override
		None, # 1st (C) param override
		["carrcountforward"], # 2nd (C) param override
		["carray", "GType", "", ""], # 2nd (C) param
		#[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_file_chooser_get_filename": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		#  'listtype', itemtype(none), howtofree actionforeach
	],
	"gtk_file_filter_get_name": [
		[ "allocedstring", "", "", "" ],
		#  'listtype', itemtype(none), howtofree actionforeach
	],
	"gtk_font_selection_dialog_get_font_name": [
		[ "allocedstring", "", "g_free(aglist);", "" ],
		#  'listtype', itemtype(none), howtofree actionforeach
	],
	"gtk_font_selection_get_font_name": [
		[ "allocedstring", "", "g_free(aglist);", "" ],
		#  'listtype', itemtype(none), howtofree actionforeach
	],
	"gtk_text_buffer_create_tag": [ #  fixme use and test
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, tagname
		None, # 3rd (C) param override, firstpropname
		[ "varargs" ], # 4th (C) param override, dot dot dot
	],
	"gtk_text_buffer_insert_with_tags": [ # fixme use and test
		None, # return value override
		None, # 1st (C) param override, self
		None, # 2nd (C) param override, iter
		None, # 3rd (C) param override, text
		["carrcount"], # 4th (C) param override, len
		None, # 5th (C) param override, firsttag (IGtkTextTag)
		[ "varargs" ], # 6th (C) param override
	],
	"gtk_text_buffer_insert_with_tags_by_name": [ # fixme use and test
		None, # return value override
		None, # 1st (C) param override, self
		None, # 2nd (C) param override, iter
		None, # 3rd (C) param override, text
		["carrcount"], # 4th (C) param override, len
		None, # 5th (C) param override, firsttagname (string)
		[ "varargs" ], # 6th (C) param override, string array ? fixme
	],
	"gtk_list_store_set_valist": [ 
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override, iter
		[ "tvarargs" ], # 3rd (C) param override
	],
	"gtk_list_store_set": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override
		[ "varargs" ], # 3rd (C) param override
	],
	"gtk_tree_store_set_valist": [ 
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override, iter
		[ "tvarargs" ], # 3rd (C) param override
	],
	"gtk_tree_store_set": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override
		[ "varargs" ], # 3rd (C) param override
	],
	"gtk_menu_popup": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		[ "ccallback" ], # 4th (C) param override; callback
		[ "userdata" ], # 5th (C) param override, userdata
	],
	"gtk_paint_shadow_gap": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		None, # 4th (C)
		None, # 5th (C)
		None, # 6th (C)
		["forceinstring"], # 7th (C)
	],
	"gtk_paint_box_gap": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		None, # 4th (C)
		None, # 5th (C)
		None, # 6th (C)
		["forceinstring"], # 7th (C)
	],
	"gtk_paint_extension": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		None, # 4th (C)
		None, # 5th (C)
		None, # 6th (C)
		["forceinstring"], # 7th (C)
	],
	"gtk_text_tag_table_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_tree_model_filter_set_modify_func": [ # fixme test
		None, # return value override
		None, # 1st (C) param override
		["carrcountforward"], # 2nd (C) param override
		["carray", "GType", "", ""], # 3rd (C) param override
		["ccallback"], # 4th (C) param override
		["userdata"], # 5th (C) param override
		["destroynotify"], # 6th (C) param override
	],
	"gtk_tree_model_filter_set_visible_func": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
		["destroynotify"], # 4th (C) param override
	],
	"gtk_tree_model_get": [ # fixme use and test
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["varargs"], # 3rd (C) param override
	],
	"gtk_tree_model_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_tree_model_get_valist": [ 
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		[ "tvarargs" ], # 3rd (C) param override
	],
	"gtk_tree_selection_selected_foreach": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override, user data
	],
	#"gtk_tree_selection_foreach": [
	#	None, # return value override
	#	None, # 1st (C) param override
	#	["ccallback"], # 2nd (C) param override
	#	["userdata"], # 3rd (C) param override
	#],
	"gtk_tree_selection_get_selected_rows": [
		["array", "GtkTreePath*", "g_list_free(aglist);", "//autoref", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
		None, # 1st (C) param override
		None, # 2nd (C) param override: model output parameter! optionalize ?
	],
	"gtk_tree_selection_set_select_function": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_tree_sortable_set_sort_func": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["ccallback"],
		["userdata"],
	],
	"gtk_tree_sortable_set_default_sort_func": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"],
		["userdata"],
		["destroynotify"],
	],
	"gtk_tree_view_column_get_cell_renderers": [
		["array", "GtkCellRenderer*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_tree_view_column_set_attributes": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["varargs"], # 3rd (C) param override
	],
	"gtk_tree_view_insert_column_with_attributes": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, position
		None, # 3rd (C) param override, title
		None, # 4th (C) param override, cellrenderer
		["varargs"], # 5th (C) param override, fixme use and test
	],
	"gtk_tree_view_get_columns": [
		["array", "GtkTreeViewColumn*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_tree_view_set_column_drag_function": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"],
		["userdata"],
		["destroynotify"],
	],
	"gtk_tree_view_set_search_equal_func": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"],
		["userdata"],
		["destroynotify"],
	],
	"gtk_tree_view_column_set_cell_data_func": [
		None, #  return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["ccallback"], # 3rd (C) param override
		["userdata"],  # 4th (C) param override
		["destroynotify"], # 5th (C) param override
	],
	"gdk_window_get_toplevels": [
		["array", "GdkWindow*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_tree_view_enable_model_drag_source": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["carray", "GtkTargetEntry", "", ""],
		["carrcount"],
		None, 
	],
	"gtk_tree_view_enable_model_drag_dest": [
		None, # return value override
		None, # 1st (C) param override
		["carray", "GtkTargetEntry", "", ""],
		["carrcount"],
		None, # actions
	],
	"gtk_clipboard_set_with_owner": [
		None, # return value override
		None, # 1st (C) param override
		["carray", "GtkTargetEntry", "", ""],
		["carrcount"],
	],
	"gdk_drag_begin": [
		["interface", "IGdkDragContext", "", "(*new*)"],# return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
		None, # 1st (C) param override, window
		["array", "GdkAtom", "", ""], # 2nd (C) param override, targets
	],
	"gtk_clipboard_set_with_data": [
		None, # return value override
		None, # 1st (C) param override
		["carray", "GtkTargetEntry", "", ""],
		["carrcount"],
		["ccallback"], # get_func
		["ccallback"], # clear_func
		["userdata"],
	],
	"gtk_clipboard_request_targets": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_tree_view_map_expanded_rows": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"],
		["userdata"],
	],
	"gtk_ui_manager_get_action_groups": [
		["array", "GtkActionGroup*", "//GTK", "g_object_ref(itemraw);", "g_list_next", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_save_to_bufferv": [
		["errorcode", "FALSE"], # return value override
	],
	"gdk_pixbuf_save_to_buffer": [
		["errorcode", "FALSE"], # return value override
	],
	"gdk_pixbuf_save": [
		["errorcode", "FALSE"], # return value override
	],
	"gdk_pixbuf_savev": [
		["errorcode", "FALSE"], # return value override
	],
	"gtk_ui_manager_add_ui_from_file": [
		[ "errorcode", "0"], # return value override
	],
	"gtk_ui_manager_add_ui_from_string": [
		["errorcode", "0"], # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, buffer
		["carrcount"], # length (-1 => nul terminated)
	],
	"gtk_ui_manager_get_toplevels": [
		["array", "GtkWidget*", "g_slist_free(aglist);", "g_object_ref(itemraw);", "g_slist_next", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_accel_group_find": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"gtk_clipboard_wait_for_text": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ]
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_clipboard_set_text": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, buffer
		["carrcount"],
	],
	"gtk_clipboard_request_text": [
		None, # return value override
		None, # 1st (C) param override
		["ccallback"], # 2nd (C) param override, buffer
		["userdata"],
	],
	"gtk_clipboard_request_contents": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, atom
		["ccallback"],
		["userdata"],
	],
	"gtk_color_selection_palette_to_string": [
		["allocedstring", "gchar*", "g_free(aglist);", "" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
		["carray", "GdkColor", "", ""],
		["carrcount"],
	],
	"gtk_window_get_default_icon_list": [
		["array", "GdkPixbuf*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_default_files": [
		["array", "gchar*", "", "", "Inc"], 
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_window_set_default_icon_list": [
		None, # return value override
		["array", "GdkPixbuf*", "g_list_free(aglist);", "" ] # 1st (C) param override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_window_list_toplevels": [
		["array", "GtkWindow*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_icon_theme_set_search_path": [
		None,
		None,
		["carray", "gchar*", "g_list_free(aglist);", "", "g_list_next", "g_free"],
		["carrcount"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_label_set_text": [
		None,
		None,
		["allocedstring", "", ""], # gtk_label_set_text prototype is whacky so help it a big by that
	],
	"gtk_rc_find_module_in_path": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_theme_dir": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_module_dir": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_im_module_path": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_im_module_file": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_find_pixmap_in_path": [
		[ "allocedstring", "gchar*", "g_free(aglist);", "" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_rc_get_style_by_paths": [ # can return NULL. fixme.
		["interface", "IGtkStyle", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_animation_get_iter": [
		["interface", "IGdkPixbufAnimationIter", "", ""],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_pixbuf_animation_iter_get_pixbuf": [ # fixme test.
		["interface", "IGtkPixbuf", "", "g_object_ref(itemraw);"],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gdk_gc_set_clip_rectangle": [
		None, # return value override
		None, # 1st (C) param override
		["const"], # 2nd (C) param override
	],
	"gtk_window_set_icon_from_file": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_window_set_default_icon_from_file": [
		[ "errorcode", "FALSE" ], # return value override
	],
	"gtk_accel_group_query": [
		[ "array", "GtkAccelGroupEntry", "", "" ], # return value override
		None, # 1st (C) param
		None, # 2nd (C) param
		None, # 3rd (C) param
		[ "overlay", "@cnt" ], # 4th (C) param
	],
	"gtk_list_store_move_before": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override # fixme
		[ "const" ], # 3rd (C) param override
	],
	"gtk_list_store_move_after": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override # fixme
		[ "const" ], # 3rd (C) param override
	],
	"gtk_tree_store_set_column_types": [
		None, # return value override
		None, # 1st (C) param override
		["carrcountforward"], # 2nd (C) param override
		["carray", "GType", "", ""], # 2nd (C) param
		#[ "array", "gchar*",  "g_slist_free(aglist);",   "",  "g_slist_next", "g_free" ], # return value override
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
	],
	"gtk_tree_store_move_before": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override # fixme
		[ "const" ], # 3rd (C) param override
	],
	"gtk_tree_store_move_after": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override # fixme
		[ "const" ], # 3rd (C) param override
	],
	"gtk_tree_store_insert": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, iter
		[ "const" ], # 3rd (C) param override, parent
		None, # 4th (C) param override, position
	],
	"gtk_tree_store_iter_is_valid": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # iter
	],
	"gtk_list_store_iter_is_valid": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # iter
	],
	"gtk_tree_store_iter_depth": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override
	],
	"gtk_tree_store_is_ancestor": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # iter
		[ "const" ], # descendant
	],
	"gtk_tree_sortable_get_sort_column_id": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override (sort_column_id)
		[ "out" ], # 3rd (C) param override (sort_order)
	],
	"gtk_tree_store_append": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # iter, var
		[ "const" ], # parent
	],
	"gtk_pixbuf_get_file_info": [
		None, # return value override
		None, # 1st (C) param override, filename
		[ "out" ], # 2nd (C) param override, width
		[ "out" ], # 3rd (C) param override, height
	],
	"gtk_list_store_append": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # iter, var
	],
	"gtk_tree_store_insert_after": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, iter
		[ "const" ], # parent
		[ "const" ], # siblings
	],
	"gtk_tree_store_insert_before": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, iter
		[ "const" ], # parent
		[ "const" ], # siblings
	],
	"gtk_tree_store_reorder": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # parent
		[ "carray", "gint" ], # neworder (array) manually
	],
	"gtk_list_store_reorder": [
		None, # return value override
		None, # 1st (C) param override
		[ "carray", "gint" ], # neworder (array) manually
	],
	"gtk_tree_store_prepend": [
		None, # return value override
		None, # 1st (C) param override
		None, # iter
		[ "const" ], # parent		
	],
	"gtk_list_store_prepend": [
		None, # return value override
		None, # 1st (C) param override
		None, # iter
	],
	"gtk_list_store_insert_after": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, iter
		[ "const" ], # siblings
	],
	"gtk_list_store_insert_before": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, iter
		[ "const" ], # siblings
	],
	"gtk_tree_model_iter_nth_child": [ None, None, ["const"], ["const"], None ],
	"gtk_tree_model_iter_n_children": [ None, None, ["const"] ],
	"gtk_tree_model_get_iter_from_string": [ None, None, ["out"], None ],
	"gtk_tree_model_get_iter_first": [ None, None, ["out"], None ],
	"gtk_tree_model_get_path": [ None, None, ["const"] ],
	"gtk_tree_model_get_iter_first": [ None, None, None ],
	"gtk_tree_model_iter_has_child": [ None, None, ["const"] ],
	"gtk_tree_model_iter_children": [ None, None, None, ["const"] ],
	"gtk_tree_model_get_iter": [ None, None, ["out"], None, ],
	"gtk_tree_model_iter_parent": [ None, None, ["out"], None, ],
	"gtk_tree_model_get_string_from_iter": [
		[ "allocedstring", "", "g_free(aglist);", "" ],
		#  'listtype', itemtype(none), howtofree actionforeach
		None,  # instance
		["const"], # iter
	],
	"gtk_tree_model_row_changed": [ None, None, None, ["const"] ],
	"gtk_tree_model_get_value": [
		None, # return value override
		None, # 1st (C) param override
		[ "const" ], # 2nd (C) param override, iter
		None, # column #
		[ "type", "out Variant" ], # value
	],
	"gtk_tree_model_row_inserted": [ None, None, None, ["const"] ],
	"gtk_tree_model_rows_reordered": [
		None, # reutrn value override
		None, # 1st (C) param override
		None, # 2nd (C) param override, path
		["const"], # 3rd (C) param override, iter
		["carray", "gint", "", ""], # 4th (C) param override
	],
	"gtk_tree_model_row_has_child_toggled": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["const"], # 3rd (C) param override
	],
	"gdk_region_get_clipbox": [
		None, # return value override
		None, # 1st (C) param override
		["out"], # 2nd (C) param override, the rectangle
	],
	"gdk_region_polygon": [
		None, # return value override
		["carray", "GdkPoint", "", ""],
		["carrcount"],
		None,
	],
	"gdk_rectangle_intersect": [
		None, # return value override
		["const"],
		["const"],
		["out"],
	],
	"gdk_rectangle_union": [
		None, # return value override
		["const"],
		["const"],
		["out"],
	],
	"gdk_region_rectangle": [
		None, # return value override
		["const"], # rectangle
	],
	"gdk_region_rect_in": [
		None, # return value override
		None, # instance
		["const"], # rectangle
	],
	"gdk_region_union_with_rect": [
		None, # return value override
		None, # instance
		["const"], # rectangle
	],
	"gtk_about_dialog_set_email_hook": [
		None, # return value override
		["ccallback"], # 1st (C) param override
		["userdata"], # 2nd (C) param override
		["destroynotify"],
	],	
	"gtk_about_dialog_set_url_hook": [
		None, # return value override
		["ccallback"], # 1st (C) param override
		["userdata"], # 2nd (C) param override
		["destroynotify"],
	],	

	
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
		[ "type", "DGdkEventMask" ], # 2nd (C) param override
	],
	"gnome_canvas_item_get_bounds": [
		None, # return value override
		None, # 1st (C) param override
		[ "out" ], # 2nd (C) param override, x1
		[ "out" ], # 3rd (C) param override, y1
		[ "out" ], # 4th (C) param override, x2
		[ "out" ], # 5th (C) param override, y2
	],
	
	## DiaCanvas c2pfuncparamoverride

	# gone:
	#"dia_canvas_group_foreach": [ # I guess that is meant.
	#	None, # return value override
	#	None, # 1st (C) param override
	#	["ccallback"], # 2nd (C) param override
	#	["userdata"], # 3rd (C) param override
	#],

	"dia_canvas_find_objects_in_rectangle": [ # only finds non-composite
		[ "array", "DiaCanvasItem*", "g_list_free(aglist);", "g_object_ref(itemraw);", "g_list_next" ],
		# ^listtype, itemtype,     howtofree,           actionforeachitem       nextforeachitem freeforeachitem
		None, # 1st (C) param overide
		["const"], # 2nd (C) param override
	],
	"dia_canvas_view_select_rectangle": [
		None, # return value override
		None, # 1st (C) param override
		["const"],
	],
	"dia_canvas_view_gdk_event_to_dia_event": [
		None, # return value override
		None, # 1st (C) param overide
		None, # 2nd (C) param overide
		["const"], # 3nd (C) param overide, gdk event
		["type", "DDiaEvent"], # 4th (C) param override, dia event record
	],
	"dia_canvas_view_item_emit_event": [
		None, # return value override
		None, # 1st (C) param override
		["type", "DDiaEvent"], # 2nd (C) param override, I think
	],
	"dia_canvas_groupable_value": [
		None, # return value override
		None, # 1st (C) param override
		["const"], # 2nd (C) param ovrride, iter
	],
	"dia_canvas_groupable_get_iter": [
		None, # return value override
		None, # 1st (C) param override
		["out"], # 2nd (C) param override, iter
	],
}

c2psignalparamoverride = {
	"GnomeCanvas.render-background": [
		None, # return value override
		None, # 1st (C) param override
		["type", "IGnomeCanvasBuf"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"AtkObject.children-changed": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		["type", "IAtkObject"], # seems ok
		["userdata"], # 4th (C) param override
	],
	"AtkObject.active-descendant-changed": [
		None, # return value override
		None, # 1st (C) param override
		["type", "IAtkObject"], # unconfirmed!
		["userdata"], # 3rd (C) param override
	],
	"AtkObject.property-change": [
		None, # return value override
		None, # 1st (C) param override
		["type", "UTF8String"], # 2nd (C) param override
		["userdata"], # 3rd (C) param override
	],
	"GtkTreeModel.rows-reordered": [
		None, # return value override
		None, # 1st (C) param override
		None, # 2nd (C) param override
		None, # 3rd (C) param override
		["userdata"], # 4th, userdata
	],
	"GtkMenuItem.toggle-size-request": [
		None, # return value override
		None, # 1st (C) param override 
		["type", "var Integer"], # 2nd (C) param override # fixme
	],
	"GtkSpinButton.input": [
		None, # return value override
		None, # 1st (C) param override
		["type", "var Double"], # 2nd (C) param override
	],
	"GtkNotebook.focus-tab": [
		None, # return value override
		None, # 1st (C) param override
		["type", "DGtkNotebookTab"], # 2nd (C) param override
		#["userdata"], # 3rd (C) param override, userdata
	],
	"GtkNotebook.switch-page": [
		None, # return value override
		None, # 1st (C) param override
		["type", "IGtkNotebookPage"], # 2nd (C) param override
		None, # 3rd (C) param override
	],
	"GtkWidget.child-notify": [
		None, # return value override
		None, # 1st (C) param override
		["type", "DGParamSpecName"],
	],
	"GtkScale.format-value": [
		["type", "UTF8String"], # return value override
	],
	
	## DiaCanvas
	"DiaCanvas.extents-changed": [
		None, # return value override
		None, # 1st (C) param override
		["type", "DDiaRectangle"], # 2nd (C) param override.. sigh...
	],
	"DiaUndoManager.add-undo-action": [
		None, # return value override
		None, # 1st (C) param overide
		["type", "IDiaUndoAction"], # 2nd (C) param override
	],
}

c2pproptypeoverride = {
	"GnomeCanvasBpath.bpath": ["ctype", "GnomeCanvasPathDef"],
	"GnomeCanvasClipgroup.path": ["ctype", "GnomeCanvasPathDef"],
	"GnomeCanvasLine.points": ["ctype", "boxed GnomeCanvasPoints"],
	"GnomeCanvasPolygon.points": ["ctype", "boxed GnomeCanvasPoints"],
	"GnomeCanvasShape.dash": ["ctype", "unboxed ArtVpathDash"],

	## DiaCanvas c2pproptypeoverride
}
 
# TODO: use that:
c2pfuncparamnullable = {
	"gtk_box_pack_start": [
		None, # 1st (C) param nullable: no, box
		None, # 2nd (C) param nullable: no, child
		"True", # 3rd (C) param nullable: expand
		"True", # 4th (C) param nullable: fill
		"0", # 5th (C) param nullable: padding
	],
	"gtk_box_pack_end": [
		None, # 1st (C) param nullable: no, box
		None, # 2nd (C) param nullable: no, child
		"True", # 3rd (C) param nullable: expand
		"True", # 4th (C) param nullable: fill
		"0", # 5th (C) param nullable: padding
	],
	"gdk_drawable_copy_to_image": [
		None, # 1st (C) param nullable: no
		"nil",  # 2nd (C) param nullable: yes, place "nil" in there
		None, # 3rd (C) param nullable: no
	],
	"gdk_pixbuf_composite_color_simple": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no; destwidth
		None, # 3rd (C) param nullable: no; destheight
		"inBilinear", # 4th (C) param nullable; interp
		"255", # 5th (C) param nullable; alpha
		"1", # 6th (C) param nullable; checksize
		None, # 7th (C) param nullable: no; color1, rgba
		None, # 8th (C) param nullable: no; color2, rgba
	],
	"gdk_pixbuf_composite": [
		None, # 1st (C) param nullable: no, src
		None, # 1st (C) param nullable: no, dest
		None, # 1st (C) param nullable: no, dest_x
		None, # 1st (C) param nullable: no, dest_y
		None, # 1st (C) param nullable: no, dest_width
		None, # 1st (C) param nullable: no, dest_height
		"0.0", # 1st (C) param nullable, offset_x
		"0.0", # 1st (C) param nullable, offset_y
		"1.0", # 1st (C) param nullable, scale_x
		"1.0", # 1st (C) param nullable, scale_y
		"inBilinear", # 1st (C) param nullable, interp
		"255", # 1st (C) param nullable, overall_alpha
	],
	"gdk_pixbuf_composite_color": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no
		None, # 3rd (C) param nullable: no
		None, # 4th (C) param nullable: no
		None, # 5th (C) param nullable: no
		None, # 6th (C) param nullable: no
		None, # 7th (C) param nullable: no
		None, # 8th (C) param nullable: no
		"1.0", # 9th (C) param nullable
		"1.0", # 10th (C) param nullable
		"inBilinear", # 11th (C) param nullable
		"255", # 12th (C) param nullable
		"0", # 13th (C) param nullable
		"0", # 14th (C) param nullable
		"1", # 15th (C) param nullable
		None, # 16th (C) param nullable: no, color1, rgba
		None, # 17th (C) param nullable: no, color2, rgba
	],
	"gdk_pixbuf_fill": [
		None, # 1st (C) param nullable: no
		"0", # 2nd (C) param nullable, color, rgba
	],
	"gdk_pixbuf_saturate_and_pixelate": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no
		"0.5", # 3rd (C) param nullable
		"FALSE", # 4th (C) param nullable
	],
	"gdk_pixbuf_copy_area": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no
		None, # 3rd (C) param nullable: no
		None, # 4th (C) param nullable: no
		None, # 5th (C) param nullable: no
		None, # 6th (C) param nullable: no
		"0", # 7th (C) param nullable, dest_x
		"0", # 8th (C) param nullable, dest_y
	],
	"gdk_pixbuf_scale_simple": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no
		None, # 3rd (C) param nullable: no
		"inBilinear", # 4th (C) param nullable
	],
	"gdk_pixbuf_scale": [
		None, # 1st (C) param nullable: no
		None, # 2nd (C) param nullable: no, dest
		None, # 3rd (C) param nullable: no, dest_x
		None, # 4th (C) param nullable: no, dest_y
		None, # 5th (C) param nullable: no, dest_width
		None, # 6th (C) param nullable: no, dest_height
		"0.0", # 7th (C) param nullable, offset_x
		"0.0", # 8th (C) param nullable, offset_y
		"1.0", # 9th (C) param nullable, scale_x
		"1.0", # 10th (C) param nullable, scale_y
		"inBilinear", # 11th (C) param nullable, interp
	]
}

signalintf = ""
signalimpl = ""

# where to add xxx_get_type external function explicitly (since its missing in the source xml)
paddexternalgettype = [
	## Gdk paddexternalgettype
	"GdkDragContext",
	"GdkDrawable", "GdkScreen", "GdkVisual", "GdkDisplay",
	"GdkDisplayManager", "GdkPixmap", "GdkGC", "GdkImage",
	"GdkPixbuf", "GdkPixbufAnimation", 
	"GdkPixbufLoader",

	## Gtk paddexternalgettype
	"GtkObject",
		
	"GtkAboutDialog", "GtkAccelGroup", "GtkAccelLabel", "GtkAccessible", 
	"GtkAction", "GtkActionGroup", "GtkAdjustment", 
	"GtkAlignment",
	"GtkArrow", "GtkAspectFrame",
	"GtkBin", "GtkBox", "GtkButton", "GtkButtonBox",
	"GtkCalendar",
	"GtkCellEditable", "GtkCellLayout", "GtkCellRenderer", 
	"GtkCellRendererPixbuf",
	"GtkCellRendererText", "GtkCellRendererToggle", 
	"GtkCellRendererProgress", "GtkCellRendererCombo",
	"GtkCheckButton", "GtkCheckMenuItem",
	"GtkClipboard", "GtkColorButton", "GtkColorSelection", 
	"GtkColorSelectionDialog",
	"GtkComboBox", "GtkComboBoxEntry", "GtkContainer", "GtkCurve",
	"GtkGammaCurve",
	"GtkDialog", "GtkDrawingArea",
	"GtkEditable", "GtkEntry", "GtkEntryCompletion", 
	"GtkEventBox", "GtkExpander",
	"GtkFileChooser", "GtkFileChooserButton",
	"GtkFileChooserDialog",  "GtkFileChooserWidget",
	"GtkFileFilter", "GtkFileSelection",
	"GtkFontButton", "GtkFixed", 
	"GtkFontSelection", "GtkFontSelectionDialog",
	"GtkFrame",
	"GtkHandleBox",

	"GtkHBox", "GtkHButtonBox", "GtkHPaned", "GtkHRuler", "GtkHScale", "GtkHScrollbar",
	"GtkHSeparator",

	"GtkIMContext",  "GtkIMContextSimple", "GtkIMMulticontext",
	"GtkIconTheme", "GtkIconView",
	"GtkInputDialog",
	"GtkImage", "GtkImageMenuItem", "GtkInvisible", "GtkItem",
	"GtkLabel", "GtkLayout", "GtkListStore",
	"GtkMenu", "GtkMenuBar", "GtkMenuItem", "GtkMenuShell", 
	"GtkMenuToolButton",
	"GtkMessageDialog", "GtkMisc",
	"GtkNotebook",
	"GtkObject", 
	"GtkPaned", "GtkPlug", "GtkProgressBar",
	"GtkRadioAction", "GtkRadioButton", 
	"GtkRadioMenuItem", "GtkRadioToolButton", 
	"GtkRange", "GtkRuler",
	"GtkScale", "GtkScrollbar", "GtkScrolledWindow", 
	"GtkSeparator", "GtkSeparatorMenuItem", "GtkSeparatorToolItem",
	"GtkSettings", "GtkSizeGroup",
	"GtkSocket",
	"GtkSpinButton", "GtkStatusbar",
	"GtkRcStyle", "GtkSelectionData", "GtkStyle", 
	"GtkTable", "GtkTearoffMenuItem",
	
	"GtkTextBuffer", "GtkTextMark", "GtkTextTag", "GtkTextTagTable",
	"GtkTextView", "GtkTipsQuery",
	"GtkToggleAction", "GtkToggleButton",
	"GtkToggleToolButton",
	"GtkToolbar", "GtkToolButton", "GtkToolItem", "GtkTooltips",
	"GtkTreeModel", "GtkTreeModelFilter", "GtkTreeModelSort",
	"GtkTreePath", "GtkTreeSelection", 
	"GtkTreeStore",
	"GtkTreeView", 
	"GtkTreeViewColumn", "GtkTreeSortable",
	"GtkUIManager",
	"GtkHPaned", 
	"GtkViewport",
	"GtkVBox", "GtkVButtonBox", "GtkVPaned", 
	"GtkVRuler",
	"GtkVSeparator",
	"GtkVScale", "GtkVScrollbar", 
	"GtkWidget", "GtkWindow", "GtkWindowGroup",
	
	## Pango paddexternalgettype
	"PangoAttrList", "PangoContext", "PangoFont", "PangoLayout", 
	"PangoTabArray",
	
	## GnomeCanvas paddexternalgettype
	
	"GnomeCanvas", "GnomeCanvasBpath", "GnomeCanvasClipgroup",
	"GnomeCanvasEllipse", "GnomeCanvasGroup", 
	"GnomeCanvasItem", "GnomeCanvasLine", "GnomeCanvasPixbuf",
	"GnomeCanvasPolygon", "GnomeCanvasRE", "GnomeCanvasRichText",
	"GnomeCanvasRect", "GnomeCanvasShape", "GnomeCanvasText",
	"GnomeCanvasWidget",
	
	## DiaCanvas paddexternalgettype
	
	"DiaCanvas",
	"DiaCanvasElement",
	"DiaCanvasItem",
	"DiaCanvasView",
	"DiaCanvasViewItem",
	"DiaCanvasImage",
	"DiaCanvasText",
	#"DiaShape", nope
	"DiaHandle",
	"DiaHandleLayer",
	"DiaUndoAction",
	"DiaUndoManager",
	"DiaVariable",
	"DiaConstraint",
	"DiaSolver",
	"DiaTool",
	"DiaStackTool",
	"DiaDefaultTool",
	"DiaPlacementTool",
	"DiaSelectionTool",
	"DiaItemTool",
	"DiaHandleTool",
]

# typemap for external declarations (C) -> pascal
externaltypemap = {
	"const gchar*": "const PGChar",
	"const char*": "const PChar",
	"char**": "PPChar", # gdk_pixbuf_save # weird
	"gboolean*": "Pgboolean",
	"gint*": "Pgint",
	"gint8*": "Pgint8",
	"gdouble*": "Pgdouble",
	"gchar**": "PPgchar",
	"GList*": "PGList",
	"GSList*": "PGSList",
	"gfloat*": "Pgfloat",
	"guint*": "Pguint",
	"GError**": "PPGError",
	"GdkColor*": "PGdkColor",
	"GtkTargetEntry*": "PGtkTargetEntry",
	"GType*": "PGType",
	"guchar*": "Pointer", # gdk pixbuf does that for pixels
	"unsigned int": "guint", # gnome-canvas has that
	#"GParamSpec**": "PPGParamSpec",
}

csignalhandlerargtype2definemap = {
	"gint": "SIMPLE", "gboolean": "SIMPLE",
	"Boolean": "SIMPLE", "Integer": "SIMPLE",
	"DGParamSpecName": "PARAMSPEC",
	"GUInt": "SIMPLE",
	#"String": "SIMPLE",
	"UTF8String": "SIMPLE",
	"Double": "SIMPLE",
	"DGdkModifierType": "ENUM",
	"DGtkDeleteType": "ENUM",
	"DGtkMovementStep": "ENUM",
	"DGtkMenuDirectionType": "ENUM",
	"DGtkDirectionType": "ENUM",
	"DGtkScrollType": "ENUM",
	"DGtkScrollStep": "ENUM",
	"DGtkToolbarStyle": "ENUM",
	"DGtkOrientation": "ENUM",
	"DGtkTextDirection": "ENUM",
	"DGtkStateType": "ENUM",
	"DGtkWidgetHelpType": "ENUM",
	"DGtkNotebookTab": "ENUM",
	"IGtkTreePath": "MEDIATOROBJECT",
	"IGtkSelectionData": "MEDIATOROBJECT",
	"IGtkNotebookPage": "MEDIATOROBJECT",
	"IAtkObject": "OBJECT",
	"IGnomeCanvasBuf": "MEDIATOROBJECT",
	"var Double": "SIMPLE",
	"var Integer": "SIMPLE",
	"const DGtkTreeIter": "RECORD", # ?
	"const DGtkTextIter": "RECORD", # ?
	"const DGdkEvent": "RECORD",
	"const DGdkEventButton": "RECORD", 
	"const DGdkEventSelection": "RECORD", 
	"const DGdkEventFocus": "RECORD",
	"const DGdkEventMotion": "RECORD",
	"const DGdkEventKey": "RECORD",
	"const DGdkEventCrossing": "RECORD",
	"const DGdkEventNoExpose": "RECORD",
	"const DGdkEventProximity": "RECORD", 
	"const DGdkEventProperty": "RECORD",
	"const DGdkEventClient": "RECORD",
	"const DGdkEventConfigure": "RECORD",
	"const DGdkEventExpose": "RECORD",

	"const DGtkRequisition": "RECORD",
	"const DGtkAllocation": "RECORD",
	
	## DiaCanvas
	"DDiaRectangle": "RECORD",
	"IDiaUndoAction": "OBJECT",
}


# for determining whether to include c*.inc or not:
# this should become less with time
underivable = [
	"GClosure", "GObject",
	"GdkBitmap", "GdkColormap", "GdkCursor", "GdkDevice", "GdkDisplay", 
	"GdkDisplayManager", "GdkDragContext", "GdkDrawable", "GdkFont", 
	"GdkGc", "GdkGC",   # ugh
	"GdkImage",
	"GdkPixbuf", "GdkPixbufAnimation", "GdkPixbufAnimationIter",
	"GdkPixbufFormat", # 
	"GdkPixbufLoader",
	"GdkPixmap", "GdkRegion", "GdkScreen", "GdkVisual", "GdkWindow", 

	"GtkAboutDialog", "GtkAccelGroup", "GtkAccelLabel", "GtkAccessible", 
	"GtkAction", "GtkActionGroup", "GtkAdjustment", 
	"GtkAlignment",
	"GtkArrow", "GtkAspectFrame",
	"GtkBin", "GtkBox", "GtkButton", "GtkButtonBox",
	"GtkCalendar",
	"GtkCellEditable", "GtkCellLayout", "GtkCellRenderer", 
	"GtkCellRendererPixbuf",
	"GtkCellRendererText", "GtkCellRendererToggle", "GtkCheckButton",
	"GtkCheckMenuItem",
	"GtkClipboard", "GtkColorButton", "GtkColorSelection",
	"GtkColorSelectionDialog",
	"GtkComboBox", "GtkComboBoxEntry", "GtkContainer", "GtkCurve",
	"GtkGammaCurve",
	"GtkDialog", "GtkDrawingArea",
	"GtkEditable", "GtkEntry", "GtkEntryCompletion", 
	"GtkEventBox", "GtkExpander",
	"GtkFileChooser", "GtkFileChooserDialog", "GtkFileChooserWidget",
	"GtkFileFilter", "GtkFileSelection",
	"GtkFontButton", "GtkFixed", 
	"GtkFontSelection", "GtkFontSelectionDialog",
	"GtkFrame",
	"GtkHandleBox",

	"GtkHBox", "GtkHButtonBox", "GtkHPaned", "GtkHRuler", "GtkHScale", "GtkHScrollbar",
	"GtkHSeparator",

	"GtkIconInfo", 
	"GtkIconSet", "GtkIconTheme", "GtkIconView", "GtkImage",
	
	"GtkIMContext", "GtkIMContextSimple", "GtkIMMulticontext",
	
	"GtkImage",
	"GtkImageMenuItem", 
	"GtkInputDialog",
	"GtkInvisible",
	"GtkItem",
	"GtkLabel", "GtkLayout", "GtkListStore",
	"GtkMenu", "GtkMenuBar", "GtkMenuItem", "GtkMenuShell", 
	"GtkMessageDialog", "GtkMisc",
	"GtkNotebook",
	"GtkObject", 
	"GtkPaned", "GtkPlug", "GtkProgress", "GtkProgressBar",
	"GtkRadioAction", "GtkRadioButton", 
	"GtkRadioMenuItem", "GtkRadioToolButton", 
	"GtkRange", "GtkRuler",
	"GtkScale", "GtkScrollbar",
	"GtkScrolledWindow",
	"GtkSeparator", "GtkSeparatorMenuItem", "GtkSeparatorToolItem",
	"GtkSettings", "GtkSizeGroup",
	"GtkSpinButton", "GtkStatusbar",
	"GtkRcStyle", "GtkSelectionData", "GtkStyle", 
	"GtkTable", "GtkTearoffMenuItem",
	"GtkTextAttributes", # not quite
	"GtkTextBuffer", 
	"GtkTextChildAnchor", 
	"GtkTextMark",	"GtkTextTag", "GtkTextTagTable",
	"GtkTextView", 
	"GtkTipsQuery",
	"GtkToggleAction", "GtkToggleButton",
	"GtkToggleToolButton",
	"GtkToolbar", "GtkToolButton", "GtkToolItem", "GtkTooltips",
	"GtkTreeModel", "GtkTreeModelFilter", "GtkTreeModelSort",
	"GtkTreePath", "GtkTreeSelection", 
	"GtkTreeStore", "GtkTreeView", 
	"GtkTreeViewColumn", "GtkTreeSortable",
	"GtkUIManager",
	"GtkHPaned", 
	"GtkViewport",
	"GtkVBox", "GtkVButtonBox",
	"GtkVPaned", 
	"GtkVRuler",
	"GtkVSeparator",
	"GtkVScale", "GtkVScrollbar", 
	"GtkWidget", "GtkWindow", "GtkWindowGroup",
	"PangoAttrList", "PangoContext", "PangoFont", "PangoLayout", 
	"PangoTabArray", "PangoFontDescription",

]

# TODO use that
classoverridables = {
	"GObject": """
    (*function DoConstructor ... huh *)
    procedure DoGetProperty(name: UTF8String; out value: Variant); virtual; (* paramspec fixme *)
    procedure DoSetProperty(name: UTF8String; const value: Variant); virtual; (* paramspec fixme *)
    (*procedure DoDispose; virtual;*)
    procedure DoFinalize; virtual;
    (* seldomly overridden: *)
    (*procedure DoDispatchPropertiesChanged(var paramspecs: TIGParamSpecArray); virtual; *)
    procedure DoNotify(name: UTF8String); virtual; (* paramspec *)
	""",
    	"GtkObject": """
    (* destroy signal default handler *)
    procedure DoDestroy; virtual;
	""",
	"GtkCellRenderer": """
    procedure DoGetSize(const widget: IGtkWidget; const cellarea: DGdkRectangle; out xOffset, yOffset, width, height: Integer); virtual;
    procedure DoRender(const window: IGdkDrawable; widget: IGtkWidget; const backgroundArea, cellArea, exposeArea: DGdkRectangle; flags: DGtkCellRendererState); virtual;
    procedure DoActivate(const event: IGdkEvent; widget: IGtkWidget; path: UTF8String; const backgroundArea, cellArea: DGdkRectangle; flags: DGtkCellRendererState); virtual;
    function DoStartEditing(const event: IGdkEvent; widget: IGtkWidget; path: UTF8String; const backgroundArea, cellArea: DGdkRectangle; flags: DGtkCellRendererState): IGtkCellEditable;
	""",
}

# widgets that will be created without passing a C widget instance (ie NEW instances)
# will use this code after construction:
pextraconstructcode = {
	"GtkVBox": """
BorderWidth := 7;
Spacing := 7;
""",
	"GtkHBox": """
BorderWidth := 7;
Spacing := 7;
""",
	"GtkTable": """
BorderWidth := 7;
RowSpacing := 5;
SetColSpacings(5);""",
}

superclassoverride = {
	## Gdk superclassoverride
	"GdkDevice": "GObject",
	"GdkImage": "GObject",
	"GdkColormap": "GObject",
	"GdkVisual": "GObject",
	"GdkRegion": "GObject",
	"GdkDragContext": "GObject",
	## Gtk superclassoverride
	"GtkClipboard": "GObject",
	## Atk superclassoverride
	"AtkObject": "GObject",
	## DiaCanvas superclassoverride
	"DiaVariable": "GObject",
	## EggTray superclassoverride
	"EggTrayManager": "GObject",
	"EggTrayIcon": "GtkPlug",
	## Netk (xfcegui) superclassoverride
	"NetkApplication": "GObject",
	"NetkClassGroup": "GObject",
	"NetkPager": "GObject",
	"NetkScreen": "GObject",
	"NetkTasklist": "GObject",
	"NetkWindow": "GObject",
	"NetkWorkspace": "GObject",
}
