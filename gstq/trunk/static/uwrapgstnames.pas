unit uwrapgstnames;

interface
uses ugtypes;

{$INCLUDE clinksettings.inc}
const
(*$IFDEF WIN32*)
  gstlib = 'libgst-0.9-0.dll'; (* no clue *)
(*$ELSE*)
  gstlib = 'libgst-0.9.so'; (* no clue *)
(*$ENDIF*)
    
type
  WGstIndexEntryType = gint;
  WGstFormat = gint;
  
  WGstIndexAssociation = record (* C *)
    format: WGstFormat;
    value: gint64;
  end;
      
  
  WGstIndexEntryId = record (* C, artificial *)
  end;
  WGstIndexEntry = record (* C *)
    type1: WGstIndexEntryType;
    id: gint;
     
    case Integer of
    0: (
      description: PGChar;
    ); // id
    1: (
      nassocs: gint;
      assocs: PWGstIndexAssociation;
      flags: WGstAssocFlags;
    ); // assoc
    2: (
      key: PGChar;
      type11: GType;
      object1: gpointer;
    ); // object
    3: (
      format: WGstFormat;
      key: PGChar;
    ); // format
  end;
  
  // callback:
  WGstIndexResolver = function(
     index: PWGstIndex; 
     writer: PWGstObject; 
     writerString: PPgchar;
     userData: gpointer): gboolean; cdecl;

  PWGstObject = type PWGObject;
  
  PWGstElement = type PWGstObject;
  PWGstPad = type PWGstObject;
  PWGstObject = type PWGstObject;
  PWGstPadTemplate = type PWGstObject;

  PWGstCaps = ^WGstCaps;
  WGstCaps = record (* C *)
    type1: GType;

    (*< public >*) (* with COW *)
    (* refcounting *)
    refcount: gint;
          
    flags: guint16;
    structs: PGPtrArray;
              
    (*< private >*)
    _gst_reserved0: gpointer;
    _gst_reserved1: gpointer;
    _gst_reserved2: gpointer;
    _gst_reserved3: gpointer;
    (* gst_reserved is unrolled from [GST_PADDING], also hardcoded in scanclasses.py *)
  end;
  
  WGstPadDirection = gint;
  WGstQueueLeaky = gint;

(*$IFDEF gtk2q_standalone*)

function gst_caps_get_type: TGType; cdecl; external gstlib;

function gst_caps_new_empty: PWGstCaps; cdecl; external gstlib;

function gst_caps_new_any: PWGstCaps; cdecl; external gstlib;

function gst_caps_new_simple(
  mediatype: PChar;
  fieldname: PChar;
  args: array of const): PWGstCaps; cdecl; external gstlib;

function gst_caps_new_full(
  struct1: PWGstStructure;
  args: array of const): PGGstCaps; cdecl; external gstlib;

(* reference counting *)
function gst_caps_ref(caps: PWGstCaps): PWGstCaps; cdecl; external gstlib;
procedure gst_caps_unref(caps: PWGstCaps); cdecl; external gstlib;
function gst_caps_copy(caps: PWGstCaps): PWGstCaps; cdecl; external gstlib;

(* helpers *)

function gst_caps_to_string(caps: PWGstCaps): PGChar; cdecl; external gstlib;  
function gst_caps_from_string(s: PGChar): PWGstCaps; cdecl; external gstlib;

(* tests *)
function gst_caps_is_any(caps: PWGstCaps): gboolean; cdecl; external gstlib;
function gst_caps_is_empty(caps: PWGstCaps): gboolean; cdecl; external gstlib;
function gst_caps_is_fixed(caps: PWGstCaps): gboolean; cdecl; external gstlib;    
function gst_caps_is_always_compatible(caps1, caps2: PWGstCaps): gboolean; cdecl; external gstlib;
function gst_caps_is_subset(subset, superset: PWGstCaps): gboolean; cdecl; external gstlib;
function gst_caps_is_equal(caps1, caps2: PWGstCaps): gboolean; cdecl; external gstlib;

(* operations *)
function gst_caps_intersect(caps1, caps2: PWGstCaps): PWGstCaps; cdecl; external gstlib;
function gst_caps_subtract(minuend, subtrahend: PWGstCaps): PWGstCaps; cdecl; external gstlib;
function gst_caps_union(caps1, caps2: PWGstCaps): PWGstCaps:  cdecl; external gstlib;
function gst_caps_normalize(caps: PWGstCaps): PWGstCaps; cdecl; external gstlib;

function gst_caps_do_simplify(caps: PWGstCaps): gboolean; cdecl; external gstlib;

function gst_caps_make_writable(caps: PWGstCaps): PWGstCaps; cdecl; external gstlib;

procedure gst_caps_set_simple(caps: PWGstCaps; field: PChar; args: array of const); cdecl; external gstlib;

procedure gst_caps_append(caps1, caps2: PWGstCaps); cdecl; external gstlib;
                                                                                                                                                  
(*$ENDIF gtk2q_standalone*)

implementation

end.
