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
  "TPangoLayout": ["TPangoFontDescription", "TPangoLayoutIter", "TPangoTabArray"],
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
]

# maps from interface name to interface unit name for special cases
interfaceunitoverride = {
}

# list of available C 'classes' (that have been wrapped)
cclasses = [ # only a subset, mostly for properties of that type
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
  "GtkFileFilter.name", # that is a stupid name for the property. renaming to "Caption"
]

# externals to force
forceexternals = [
  "gtk_file_filter_get_name",
  "gtk_file_filter_set_name",
  
  ## Pango forceexternals
  "pango_layout_get_font_description",
  "pango_layout_set_font_description",
  "pango_layout_set_text",
  "pango_layout_get_iter",
  "pango_layout_get_tabs",
  "pango_font_description_copy",
]

paddmembervars = {
}

# functions to add to class and interface (C class: {pascal function name: pascal function body})
paddfuncs = {
  "GtkFileFilter": {
    "GetCaption": """
      protected function GetCaption: UTF8String;
      var
        cname: PGChar;
      begin
        cname := gtk_file_filter_get_name(fObject);
        if Assigned(cname) then begin
          Result := PChar(cname);
          // not g_free
        end else 
          Result := '';
      end;
    """,
    "SetCaption": """
      protected procedure SetCaption(const value: UTF8String);
      begin 
        gtk_file_filter_set_name(fObject, PGChar(PChar(value)));
      end;
    """,
  },
  "PangoLayout": {
    "GetFontDescription": """
      protected function GetFontDescription: IPangoFontDescription;
      var
        clowlevel: PWPangoFontDescription;
      begin
        clowlevel := pango_layout_get_font_description(fObject);
        // ^- don't free
        
        clowlevel := pango_font_description_copy(clowlevel);
        Result := TPangoFontDescription.CreateWrapped(clowlevel);
      end;
    """,
    "SetFontDescription": """
      protected procedure SetFontDescription(const value: IPangoFontDescription);
      begin
        pango_layout_set_font_description(fObject, value.GetUnderlying);
      end;
    """,
    "GetInkExtents": """
			published function GetInkExtents: TPangoRectangle;
			var
			  InkExtents, LogicalExtents: TPangoRectangle;
			begin
			  GetExtents(InkExtents, LogicalExtents);
			  Result := InkExtents;
			end;
    """,
    "GetLogicalExtents": """
			published function GetLogicalExtents: TPangoRectangle;
			var
			  InkExtents, LogicalExtents: TPangoRectangle;
			begin
			  GetExtents(InkExtents, LogicalExtents);
			  Result := LogicalExtents;
			end;
    """,
    "GetInkPixelExtents": """
			published function GetInkPixelExtents: TPangoRectangle;
			var
			  InkExtents, LogicalExtents: TPangoRectangle;
			begin
			  GetPixelExtents(InkExtents, LogicalExtents);
			  Result := LogicalExtents;
			end;
    """,
    "GetLogicalPixelExtents": """
			published function GetLogicalPixelExtents: TPangoRectangle;
			var
			  InkExtents, LogicalExtents: TPangoRectangle;
			begin
			  GetPixelExtents(InkExtents, LogicalExtents);
			  Result := LogicalExtents;
			end;
    """,
    "SetText": """
      published procedure SetText(value: UTF8String);
      begin
        pango_layout_set_text(fObject, PChar(value), Length(value));
      end;
    """,
    "GetIter": """
      published function GetIter: IPangoLayoutIter;
      begin
        Result := TPangoLayoutIter.CreateWrappedPin(pango_layout_get_iter(fObject), Self);
      end;
    """,
    "GetTabs": """
      published function GetTabs: IPangoTabArray;
      var
        clowlevel: PWPangoTabArray;
      begin
        clowlevel := pango_layout_get_tabs(fObject);
        if Assigned(clowlevel) then begin
          Result := TPangoTabArray.CreateWrappedPin(clowlevel, Self);
        end else begin
          Result := nil;
        end;
      end;
    """,
  },
}

# properties to add (C class: {pascal property name:  pascal property line})
paddprops = {
  "GtkFileFilter": {
    "Caption": "public property Caption: UTF8String read GetCaption write SetCaption;",
  }
}

# functions to be skipped and not be wrapped
cskipfuncs = [
  "gtk_file_filter_get_name",
  "gtk_file_filter_set_name",
  "pango_layout_get_log_attrs",
  "pango_layout_get_lines", # too lazy

  "pango_layout_get_font_description", # manually
  "pango_layout_set_font_description", # manually
  "pango_layout_set_text", # manually
  "pango_layout_get_iter", # manually
  "pango_layout_get_tabs", # manually
  
  # moved to their own manual class:
  "pango_layout_line_get_x_ranges",
  "pango_layout_line_ref",
  "pango_layout_line_unref",
  "pango_layout_line_index_to_x",
  "pango_layout_line_get_extents",
  "pango_layout_line_get_pixel_extents",
  "pango_layout_line_x_to_index",

  # moved to their own manual class:
  "pango_layout_iter_next_run",
  "pango_layout_iter_get_line",
  "pango_layout_iter_next_line",
  "pango_layout_iter_next_cluster",
  "pango_layout_iter_get_line_yrange",
  "pango_layout_iter_get_char_extents",
  "pango_layout_iter_get_cluster_extents",
  "pango_layout_iter_at_last_line",
  "pango_layout_iter_get_baseline",
  "pango_layout_iter_get_line_extents",
  "pango_layout_iter_get_run",
  "pango_layout_iter_free",
  "pango_layout_iter_get_index",
  "pango_layout_iter_get_run_extents",
  "pango_layout_iter_next_char",
  "pango_layout_iter_get_layout_extents",
]

# callback function types in the wrapper (these will be superceded soon)
c2pcallbackpointers = {
}

# override of function parameters
# for example, return values that have to be memory managed,
# interfaces to wrapped classes, c arrays, lists
c2pfuncparamoverride = {
}


c2psignalparamoverride = {
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
