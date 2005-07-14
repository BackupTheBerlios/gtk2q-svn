#!/usr/bin/env python

# pstringtype = "UTF8String"
# classprefix = "T"
# enumprefix = "T"
# interfaceprefix = "I"
interfaceunitprefix = "iu"
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
	## DiaCanvas pusedclasses
	"TDiaCanvas": ["TDiaCanvasItem", "TDiaCanvasGroup"],
	"TDiaCanvasItem": ["TDiaCanvasItemShapes", "IPangoLayout"],
	"TDiaCanvasImage": ["IGdkPixbuf"],
	"TDiaVariable": ["IDiaVariable"],
	"TDiaCanvasView": ["IGnomeCanvas", "IGtkLayout", "TGdkEvent"],
	"TDiaCanvasViewItem": ["IGtkObject", "IArtUta"],
	"TDiaHandle": ["IGnomeCanvasItem", "IGtkObject"],
	"TDiaHandleLayer": ["IGnomeCanvasItem", "IGtkObject"],
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
	## DiaCanvas psignalusedioc
	"TDiaCanvas": ["TDiaRectangle"],
	"TDiaUndoManager": ["IDiaUndoAction"],
	"TDiaTool": ["TGdkEvent"],
}

# signal units uses clause, used classes for implementation section
psignalusediocimpl = {
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
	"IDiaUndoAction": interfaceunitprefix + "diaundoaction",
	"IDiaVariable": interfaceunitprefix + "diacanvas",
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
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
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
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
}

c2penumcopied = [ # enums copied to delphi as-is
	## DiaCanvas c2penumcopied
	"DiaStrength",
	"DiaJoinStyle",
	"DiaCapStyle",
	"DiaEventMask",
]

# structs copied from gtk to the wrapped (into unit u...types) 
c2pstructcopied = { # simple structs copied to delphi as-is
	## DiaCanvas
	"DiaRectangle": "TDiaRectangle",
	"DiaPoint": "TDiaPoint", # well actually its the same as artpoint
	"DiaCanvasIter": "TDiaCanvasIter",
	"DiaCanvasItemAffine": "TDiaCanvasItemAffine", # made that up
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
	## DiaCanvas cskipprops
	"DiaCanvasItem.connect", # what the heck is that
	"DiaCanvasItem.disconnect", # dont abuse properties for procedures
]

# externals to force
forceexternals = [
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
	## DiaCanvas
	"DiaCanvas": {
		"GetRoot": """
			published function GetRoot: IDiaCanvasGroup;
			begin
			  Result := TDiaCanvasGroup.CreateWrapped(dia_canvas_root(PDiaCanvas(fObject))) as IDiaCanvasGroup;
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
			    item := WrapGObject(citem, TDiaCanvasItem) as IDiaCanvasItem
			  else
			    item := nil;
			end;
		""",
		"Preserve": """
			published procedure Preserve(object1: IGObject; propertyName: UTF8String; value: Variant; after: Boolean = False);
			var
			  gvalue: WGValue;
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
			published function GetBoundingBoxAfterAffine(const affine: TAffineTransform): TDiaRectangle;
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
			      FshapesProxy := TDiaCanvasItemShapes.Create(Self)
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
			published function IterFirst(out iter: TDiaCanvasIter): Boolean;
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
			published function GetItem1(const iter: TDiaCanvasIter): IDiaCanvasItem;
			var
			  citem: Pointer;
			begin
			  citem := dia_canvas_groupable_value(Fobject, @iter);
			  if Assigned(citem) then
			    Result := WrapGObject(citem) as IDiaCanvasItem
			  else
			    Result := nil (* fixme exception ? *)
			end;
		""",
		"IterNext": """
			published function IterNext(var iter: TDiaCanvasIter): Boolean;
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
	## DiaCanvas c2pcallbackpointers
	"DiaCanvasItemForeachFunc": "TDiaCanvasItemForeachFunc",
	"DiaUndoFunc": "TDiaUndoFunc",
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
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
		["type", "TDiaEvent"], # 4th (C) param override, dia event record
	],
	"dia_canvas_view_item_emit_event": [
		None, # return value override
		None, # 1st (C) param override
		["type", "TDiaEvent"], # 2nd (C) param override, I think
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
	## DiaCanvas
	"DiaCanvas.extents-changed": [
		None, # return value override
		None, # 1st (C) param override
		["type", "TDiaRectangle"], # 2nd (C) param override.. sigh...
	],
	"DiaUndoManager.add-undo-action": [
		None, # return value override
		None, # 1st (C) param overide
		["type", "IDiaUndoAction"], # 2nd (C) param override
	],
}

c2pproptypeoverride = {
}

c2pfuncparamnullable = {
}

#signalintf = ""
#signalimpl = ""

# where to add xxx_get_type external function explicitly (since its missing in the source xml)
paddexternalgettype = [
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

# typemap for external declarations (C) -> pascal, prefix "const " for const-params
externaltypemap = {
}

# ptypename: {"SIMPLE"|"PARAMSPEC"|"ENUM"|"MEDIATOROBJECT"|"OBJECT"|"RECORD"}
csignalhandlerargtype2definemap = {
	## DiaCanvas
	"TDiaRectangle": "RECORD",
	"IDiaUndoAction": "OBJECT",
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
	## DiaCanvas superclassoverride
	"DiaVariable": "GObject",
}

csettypes = [
]
