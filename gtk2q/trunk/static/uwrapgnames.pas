unit uwrapgnames;

// contains lowlevel stuff only
// (some weird types it needs for importing and I dont)

interface
uses ugtypes, iugobject;

{$INCLUDE clinksettings.inc}

const
(*$IFDEF WIN32*)
  glib = 'libglib-2.0-0.dll';
  gobjectlib = 'libgobject-2.0-0.dll';
  gthreadlib = 'libgthread-2.0-0.dll';
(*$ELSE*)
  glib = 'libglib-2.0.so';
  gobjectlib = 'libgobject-2.0.so';
  gthreadlib = 'libgthread-2.0.so';
(*$ENDIF WIN32*)

const
  //TGParamFlags
  gpfReadable = 1 shl 0;
  gpfWritable = 1 shl 1;
  gpfConstruct = 1 shl 2;
  gpfConstructOnly = 1 shl 3;
  gpfLaxValidation = 1 shl 4;
  gpfPrivate =  1 shl 5;

type
  PWgint = ^gint;
  PWguint8 = ^guint8;
  PWgboolean = ^gboolean;
  PWguint = ^guint;
  PWgsize = ^gsize;
  PWgfloat = ^gfloat;
  PWgdouble = ^gdouble;
  gssize = Longint; // or int64 but I dont think C supports that
  TGTimeVal = record // C
    tv_sec: glong;
    tv_usec: glong;
  end;
  PWGTimeVal = ^TGTimeVal;
  

type
  //DGQuark = GUInt32; -> ugtypes
  PPGChar = ^PGChar;
  PGChar = ^GChar;
  GChar = Char;
  PWGchar = PGchar;

  PGStrv = PPGChar; // stringlist, array of pointers to pchar-string, nil-terminated
  
  PWchar = PChar; (* filechooser sometimes uses that. maybe make that a type by itself ? *)
  
  //guchar = Byte; -> ugtypes
  
  PWguchar = ^guchar;

  WgintArray = array of gint;
  Wgint8Array = array of gint8;

  PWGValue = Pointer; // eek

  Pgulong = ^gulong;

  PGTimer = Pointer; 
  
  PPWGError = ^PWGError;
  PWGError = ^WGError;
  WGError = record
    domain: TGQuark;
    code: GInt;
    message: PGChar;
  end;
  //PGBoolean = ^gboolean;
  ///gboolean = LongBool; ugtypes
  

  gpointer = Pointer;
  gconstpointer = Pointer;
  WGDestroyNotify = DGDestroyNotify;

  WGTypeFlags = gint; // (1<<4)=Abstract, (1<<5)=ValueAbstract

  PWGSList = ^WGSList;
  WGSList = record
    data: gpointer;
    next: PWGSList;
  end;

  PWGList = ^WGList;
  WGList = record
    data: gpointer;
    next, prev: PWGList;
  end;

  PGType = ^TGType; (* TODO move to ugtypes.pas ? *)
  

  PWGTypeInstance = ^WGTypeInstance;
  WGTypeInstance = record
    g_class: Pointer; // PGTypeClass
  end;

  PGData = Pointer;
  
  PWGObject = ^WGObject;
  WGObject = record
    g_type_instance: WGTypeInstance;
    ref_count: guint;
    qdata: PGData;
  end;

  PWGClosure = ^WGClosure;
   PWGClosureNotifyData = ^WGClosureNotifyData;
   WGClosureNotify = procedure (data:gpointer; closure:PWGClosure); cdecl;

   WGClosureNotifyData = record
        data : gpointer;
        notify : WGClosureNotify;
     end;


{ invariants/constrains:
     - ->marshal and ->data are _invalid_ as soon as ->is_invalid==TRUE
     - invocation of all inotifiers occours prior to fnotifiers
     - order of inotifiers is random
       inotifiers may _not_ free/invalidate parameter values (e.g. ->data)
     - order of fnotifiers is random
     - each notifier may only be removed before or during its invocation
     - reference counting may only happen prior to fnotify invocation
       (in that sense, fnotifiers are really finalization handlers)
    }
  WGClosure = record
        flag0 : longint;
        marshal : procedure (closure:PWGClosure; return_value:PWGValue; n_param_values:guint; param_values:PWGValue; invocation_hint:gpointer;
                      marshal_data:gpointer); cdecl;
        data : gpointer;
        notifiers : PWGClosureNotifyData;
  end;

  PWGTypeClass = ^WGTypeClass;
  WGTypeClass = record
    gtype: TGType;
  end;

type
   TGBaseInitFunc = procedure (g_class:gpointer); cdecl;

   TGBaseFinalizeFunc = procedure (g_class:gpointer); cdecl;

   TGClassInitFunc = procedure (g_class:gpointer; class_data:gpointer); cdecl;

   TGClassFinalizeFunc = procedure (g_class:gpointer; class_data:gpointer); cdecl;

   TGInstanceInitFunc = procedure (instance:WGTypeInstance; g_class:gpointer); cdecl;

   TGInterfaceInitFunc = procedure (g_iface:gpointer; iface_data:gpointer); cdecl;

   TGInterfaceFinalizeFunc = procedure (g_iface:gpointer; iface_data:gpointer); cdecl;

   TGTypeClassCacheFunc = function (cache_data:gpointer; g_class:PWGTypeClass):gboolean; cdecl;

   PWGTypeCValue = ^WGTypeCValue;
   WGTypeCValue = record
       case longint of
          0 : ( v_int : gint );
          1 : ( v_long : glong );
          2 : ( v_int64 : gint64 );
          3 : ( v_double : gdouble );
          4 : ( v_pointer : gpointer );
       end;
   
   { varargs functionality (optional)  }
   PGTypeValueTable = ^TGTypeValueTable;
   TGTypeValueTable = record
        value_init : procedure (value:PWGValue); cdecl;
        value_free : procedure (value:PWGValue); cdecl;
        value_copy : procedure (src_value:PWGValue; dest_value:PWGValue); cdecl;
        value_peek_pointer : function (value:PWGValue):gpointer; cdecl;
        collect_format : Pgchar;
        collect_value : function (value:PWGValue; n_collect_values:guint; collect_values:PWGTypeCValue; collect_flags:guint):Pgchar; cdecl;
        lcopy_format : Pgchar;
        lcopy_value : function (value:PWGValue; n_collect_values:guint; collect_values:PWGTypeCValue; collect_flags:guint):Pgchar; cdecl;
     end;



  PWGTypeInfo = ^WGTypeInfo;
  WGTypeInfo = record
    classSize : guint16;
    baseInit : TGBaseInitFunc;
    baseFinalize : TGBaseFinalizeFunc;
    classInit : TGClassInitFunc;
    classFinalize : TGClassFinalizeFunc;
    classData : gconstpointer;
    instanceSize : guint16;
    nPreallocs : guint16;
    instanceInit : TGInstanceInitFunc;
    valueTable : PGTypeValueTable;
  end;

  (*TGTypeInstance = record
    gclass: PWGTypeClass;
  end;*)
  (*PGData = Pointer;*)
  TGParamFlags = gint;
  PWPGParamSpec = ^PWGParamSpec; (* sigh *)
  PWGParamSpec = ^WGParamSpec;
  WGParamSpec = record
    gtype: WGTypeInstance;

    name: PGChar;
    flags: TGParamFlags;
    valuetype: TGType;
    ownertype: TGType;
    
    (* <private> *)
    
    nick, blurb: PGChar;
    qdata: PGData;
    refCount: guint;
    paramID: guint; (* sort criteria *)
  end;
  PWGObjectConstructParam = ^WGObjectConstructParam;
  WGObjectConstructParam = record
    pspec: PWGParamSpec;
    value: PWGValue;
  end;
  
  
  PWGObjectClass = ^WGObjectClass;
  WGObjectClass = record
    gTypeClass: WGTypeClass;

    (*< private >*)
    constructProperties: PWGSList;

    (*< public >*)
    (* overridable methods *)
    aconstructor: function(atype: TGType; nConstructProperties: guint; constructProperties: PWGObjectConstructParam): PWGObject; cdecl;
    setProperty: procedure(aobject: PWGObject; propertyID: guint; {const} value: PWGValue; pspec: PWGParamSpec); cdecl;
    getProperty: procedure(aobject: PWGObject; propertyID: guint; value: PWGValue; pspec: PWGParamSpec); cdecl;
    dispose: procedure(aobject: PWGObject); cdecl;
    finalize: procedure(aobject: PWGObject); cdecl;
  
    (* seldomly overidden *)
    dispatchPropertiesChanged: procedure(aobject: PWGObject; nPSpecs: guint; pspecs: PWPGParamSpec); cdecl;

    (* signals *)
    notify: procedure(aobject: PWGObject; pspec: PGParamSpec); cdecl;

    (*< private >*)
    (* padding *)

    (* actually array[8] *)
    pdummy0: Pointer;
    pdummy1: Pointer;
    pdummy2: Pointer;
    pdummy3: Pointer;
    pdummy4: Pointer;
    pdummy5: Pointer;
    pdummy6: Pointer;
    pdummy7: Pointer;
  end;


  
  PWGParamSpecString = ^WGParamSpecString;
  WGParamSpecString = record
    pspec: WGParamSpec;
    
    defaultValue, csetfirst, csetnth: PGChar;
    substitutor: gchar;
    nullfoldifempty: gint; // :1
    ensurenonnull: gint; // :1
  end;
  PGParamSpecByte = ^WGParamSpecByte;
  WGParamSpecByte = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue: guint8;
  end;
  PWGParamSpecInt = ^WGParamSpecInt;
  WGParamSpecInt = record
    pspec: WGParamSpec;
  
    minimum, maximum, defaultValue: gint;
  end;
  PGParamSpecInt64 = ^WGParamSpecInt64;
  WGParamSpecInt64 = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue: Int64;
  end;
  PWGParamSpecInt8 = ^WGParamSpecInt8;
  WGParamSpecInt8 = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue: gint8;
  end;
  PWGParamSpecBoolean = ^WGParamSpecBoolean;
  WGParamSpecBoolean = record
    pspec: WGParamSpec;

    defaultValue: gboolean;
  end;

  PWGParamSpecFloat = ^WGParamSpecFloat;
  WGParamSpecFloat = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue, epsilon: gfloat;
  end;
  
  PWGParamSpecDouble = ^WGParamSpecDouble;
  WGParamSpecDouble = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue, epsilon: gdouble;
  end;
  
  PWGParamSpecLong = ^WGParamSpecLong;
  WGParamSpecLong = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue: glong;
  end;
  
  PWGParamSpecUnichar = ^WGParamSpecUnichar;
  WGParamSpecUnichar = record
    pspec: WGParamSpec;
    
    defaultValue: gunichar;
  end;
  
  PWGParamSpecUInt = ^WGParamSpecUInt;
  WGParamSpecUint = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultvalue: guint;
  end;
  
  PWGParamSpecUInt64 = ^WGParamSpecUInt64;
  WGParamSpecUint64 = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultvalue: guint64;
  end;
  
  PWGParamSpecULong = ^WGParamSpecULong;
  WGParamSpecULong = record
    pspec: WGParamSpec;
    
    minimum, maximum, defaultValue: gulong;
  end;
  
  WGWeakNotify = procedure(data: Pointer; whereitwas: PWGObject); cdecl;
  
  PWGTypeQuery = ^WGTypeQuery;
  WGTypeQuery = record
    atype: TGType;
    typeName: PGChar;
    classSize: guint;
    instanceSize: guint;
  end;
  
  TGQuark = guint32;
  
type
(*$IFDEF DELPHI*)
  WCastSetType = Byte;
(*$ELSE*)
(*$IFDEF FPC*)
  WCastSetType = Integer;
(*$ELSE*)
  WCastSetType = Integer; (* be careful *)
(*$ENDIF FPC*)
(*$ENDIF DELPHI*)

(*$IFDEF gtk2q_standalone*)
procedure g_list_free(list: PWGList); cdecl; external glib;
function g_list_length(list: PWGList): guint; cdecl; external glib;
function g_list_append(list: PWGList): PWGList; cdecl; external glib;
function g_list_next(list: PWGList): PWGList;

procedure g_slist_free(list: PWGSList); cdecl; external glib;
function g_slist_length(list: PWGSList): guint;
//function g_list_append(list: PGList): PGList; external glib;
function g_slist_next(list: PWGSList): PWGSList;
function g_slist_append(list: PWGSList; data: gpointer): PWGSList; cdecl; external glib;

function g_type_class_peek_parent(gclass: gpointer): gpointer; cdecl; external glib;
function g_type_interface_peek_parent(iface: gpointer): gpointer; cdecl; external glib; (* null on non-conforming *)
function g_type_register_static(parenttype: TGType;
  {const} typeName: PGChar; {const} info: PWGTypeInfo;
  flags: WGTypeFlags): TGType; cdecl; external gobjectlib;

procedure g_type_query(agtype: TGType; atypeinfo: PWGTypeInfo); cdecl; external gobjectlib;
function g_quark_from_static_string(astring: PGChar): TGQuark; cdecl; external glib;

procedure g_error_free(error:PWGError);cdecl;external glib name 'g_error_free';

function g_new0(sz: Cardinal; nstructs: Cardinal): Pointer; (*cdecl;*)


procedure g_free(memory: pointer); cdecl; external glib;
function g_strdup(orig: PGChar): PGChar; cdecl; external glib;

function g_strv_length(list: PGStrv): guint; cdecl; external glib;

function g_type_check_instance_is_a(instance: PWGTypeInstance; iface: TGType): gboolean; cdecl; external glib;
(*$ENDIF gtk2q_standalone*)

function G_TYPE_FROM_INSTANCE(instance: pointer): TGType;
function G_TYPE_CHECK_INSTANCE_TYPE(instance: pointer; compareto: TGType): Boolean;
function SignalHandlerNextParam(param: PWGValue): PWGValue;
procedure AssertGInstanceStructSize(ithinksize: Cardinal; gtype: TGType);

function UTF8StringArrayFromStrv(value: PGStrv): TUTF8StringArray;
function UTF8StringArrayFromStrvAndDispose(value: PGStrv): TUTF8StringArray;
function StrvFromUTF8StringArray(value: TUTF8StringArray): PGStrv;

const
  G_TYPE_FUNDAMENTAL_SHIFT = 2;
  G_TYPE_INT = TGType(6 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_INT64 = TGType(10 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_UINT64 = TGType(11 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_LONG = TGType(8 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_ULONG = TGType(9 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_CHAR = TGType(3 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_BOXED = TGType(18 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_ENUM = TGType(12 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_BOOLEAN = TGType(5 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_UINT = TGType(7 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_STRING = TGType(16 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_DOUBLE = TGType(15 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_FLOAT = TGType(14 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_OBJECT = TGType(20 shl G_TYPE_FUNDAMENTAL_SHIFT);
  G_TYPE_UCHAR = TGType(4 shl G_TYPE_FUNDAMENTAL_SHIFT);

procedure g_strfreev(strarray: PPGChar); cdecl; external glib;
// closures

//type
//  PWGClosure = Pointer;
  // PWGValue -> ugvalue

procedure HandleAndFreeGError(var error: PWGError; eclass: EGErrorClass); (* raises exception. be careful. *)

implementation
uses ugvalue;


function G_TYPE_FROM_CLASS(g_class: pointer): TGType;
begin
  Result := PWGTypeClass(g_class)^.gtype;
end;

function G_TYPE_FROM_INSTANCE(instance: pointer): TGType;
begin
  Result := G_TYPE_FROM_CLASS(PWGTypeInstance(instance)^.g_class);
end;

function G_TYPE_CHECK_INSTANCE_TYPE(instance: pointer; compareto: TGType): Boolean;
begin
  Result := G_TYPE_FROM_CLASS(PWGTypeInstance(instance)^.g_class) = compareto;
end;

function g_slist_length(list: PWGSList): guint; 
var
  cnt: guint;
begin
  // SLOW

  cnt := 0;
  while Assigned(list) do begin
    Inc(cnt);
    list := list.next;
  end;
  Result := cnt;
end;

function g_slist_next(list: PWGSList): PWGSList;
begin
 // what to do with nil ?
  Result := list.next;
end;

function g_list_next(list: PWGList): PWGList;
begin
 // what to do with nil ?
  Result := list.next;
end;

(*$IFDEF FPC*)
function SignalHandlerNextParam(param: PWGValue): PWGValue;
begin
  Result := param;
  Inc(Result);
end;
(*$ELSE*)
function SignalHandlerNextParam(param: PWGValue): PWGValue;
asm
  mov edx, param
  add edx, DWORD PTR sizeof(TGValue)
  mov Result, edx
end;
(*$ENDIF*)

function g_malloc0(sz: gulong): gpointer; cdecl; external glib; 

function g_new0(sz: Cardinal; nstructs: Cardinal): Pointer;
begin
  Result := g_malloc0(sz * nstructs);
end;


procedure HandleAndFreeGError(var error: PWGError; eclass: EGErrorClass); (* raises exception. be careful. *)
var
  msg: UTF8String;
  code: Integer;
  domain: Cardinal;
begin
  try
    (*error.message := nil;*)
    raise eclass.Create(Pointer(error));
  finally
    g_error_free(error);
    error := nil;
  end;
end;

procedure AssertGInstanceStructSize(ithinksize: Cardinal; gtype: TGType);
var
  typeinfo: WGTypeInfo;
begin
  (* not cross platform assert(sizeof(typeinfo) = 36);*)
  typeinfo.instanceSize := 0;
  g_type_query(gtype, @typeinfo);
  assert(ithinksize = typeinfo.instanceSize);
end;

function UTF8StringArrayFromStrv(value: PGStrv): TUTF8StringArray;
var
  item: PPChar;
  count: Cardinal;
  i: Cardinal;
begin
  if not Assigned(value) then begin
    SetLength(Result, 0);
    Exit;
  end;
  
  count := g_strv_length(value);
  SetLength(Result, count);
  
  i := 0;
  item := PPChar(value);
  while Assigned(item) do begin
    Result[i] := (item^);
    Inc(i);
    
    Inc(item);
  end;
end;

function UTF8StringArrayFromStrvAndDispose(value: PGStrv): TUTF8StringArray;
begin
  Result := UTF8StringArrayFromStrv(value);
  g_strfreev(value);
end;

function StrvFromUTF8StringArray(value: TUTF8StringArray): PGStrv;
var
  i: Integer;
  count: Integer;
  cstrv: PPChar;
begin
  count := Length(value);
  cstrv := g_malloc0(sizeof(PChar) * (count + 1));
  Result := cstrv;
  
  if count > 0 then begin
    for i := 0 to count - 1 do begin
      cstrv^ := g_strdup(PGChar(PChar(value[i])));
      Inc(cstrv);
    end;
  end;
  cstrv^ := nil;
end;

(* GObjectClass *)
(* wrapper functions that call the objects methods. DO NOT ASSIGN EVERY FUNCTION *)
(* reason is that most of the functions are probably signal handlers that are not allowed to be assigned *)
(* you only may assign 'vtable' members. *)

{
procedure LLgtktextTsetscrolladjustments( text: PWGtkText; 
 hadjustment: PWGtkAdjustment; 
 vadjustment: PWGtkAdjustment); cdecl;
var
  me: Dgtktext;
begin
  me := Dgtktext(TGObject.GetWrapperDirect(text));
end;
}

end.
