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
}

# signal units uses clause, used interfaces for interface section, p name = key
psignalusedioc = {
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
  "TGstCaps",
  "TGstStructure",
]

# maps from interface name to interface unit name for special cases
interfaceunitoverride = {
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
	"GstElement",
	"GstPad",
	"GstObject",
	"GstPadTemplate", 
]

# list of parameters that are used as 'const ...*' uselessly (from a pascal point of view)
c2pconstpointerparam = [ # 'const GdkColor*' as parameter
]

# map of C class -> construction parameters
#   None => not constructable
cclassconstructparams = {
}

# direct type mapping
# contains type mappings for primitive types, for use in the interfaces
# be careful with that.
c2ptypehash = {
}

c2penumcopied = [ # enums copied to delphi as-is
	"GstPadDirection",
	"GstQueueLeaky",
]

# structs copied from gtk to the wrapped (into unit u...types) 
c2pstructcopied = { # simple structs copied to delphi as-is
	"GstIndexEntry": "TGstIndexEntry",
	"GstCaps": "TGstCaps",
}

# class (not instance) functions to get from C
c2pclassfunctions = { 
}

cskipsignals = [
	"GstObject.object-saved", # xml...
	"GstXML.object-loaded", # xml...
]

# properties that are to be skipped and not be wrapped (f.e. deprecated properties)
cskipprops = [
]

# externals to force
forceexternals = [
  "gst_pad_alloc_buffer",
  "gst_pad_alloc_buffer_and_set_caps",
]

paddmembervars = {
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
  "TypeRegister": """
      class procedure TypeRegister;
      begin
        GstreamerInit;
        inherited TypeRegister;
        DTypeRegister('TGstObject', 'gst', TGstObject, gst_object_get_type, IGstObject);
      end;
  """,
  "HandleFlowReturn": """
      protected function HandleFlowReturn(code: TGstFlowReturn): Boolean;
      begin (* returns: ok? *)
        (* TODO what about resend? *)
        Result := code = frOk;
        
        if not Result
        then
          raise EGstFlowError.Create(code);
        end;
      end;
  """,
  "AllocateBuffer": """
      published function AllocateBuffer(offset: guint64; size: gint; const caps: IGstCaps): IGstBuffer;
      var 
        cbuffer: PWGstBuffer;
      begin
        Result := nil;
        cbuffer := nil;
        if HandleFlowReturn(gst_pad_alloc_buffer(GetUnderlying,
                                              offset,
                                              size,
                                              caps.GetUnderlying,
                                              @cbuffer)) 
        then
          Result := CreateWrapped(cbuffer);
        end;                                      
      end;
  """,
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
}

# functions to be skipped and not be wrapped
cskipfuncs = [
	"gst_object_replace",
	"gst_object_default_deep_notify",
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
	## Gst c2pcallbackpointers
	"GstIndexResolver": "TGstIndexResolver",
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
}


c2psignalparamoverride = {
	# UGH! FIXME when gstreamer fixes that :) for now, skipped
	"GstObject.object-saved": [
		None, # return value override
		None, # 1st (C) param override
		["type", "PLibxml2Node"], # 2nd (C) param override XXX
		["userdata"], # 3rd (C) param override
	],
	"GstXML.object-loaded": [
		None, # return value override
		None, # 1st (C) param override
		["type", "PLibxml2Node"], # 2nd (C) param override XXX
		["userdata"], # 3rd (C) param override
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
]

# typemap for external declarations (C) -> pascal, prefix "const " for const-params
externaltypemap = {
}

# ptypename: {"SIMPLE"|"PARAMSPEC"|"ENUM"|"MEDIATOROBJECT"|"OBJECT"|"RECORD"}
csignalhandlerargtype2definemap = {
	"const TGstIndexEntry": "RECORD",
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
