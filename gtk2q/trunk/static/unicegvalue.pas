unit unicegvalue;

interface
uses ugvalue, uwrapgnames, ugtypes, sysutils, variants, iugobject;

function gValueInit(typ: Integer): WGValue;

type
  EGValueTypeMismatch = class(Exception)
  end;

  PGParamSpec = Pointer;

// all these functions can raise EGValueTypeMismatch
function gValueGetEnumLike(const gvalue: WGValue): Integer;
procedure gValueGetValue(const gvalue: WGValue; out value: PWGObject); overload;
(*function gValueInit(typ: Integer): WGValue;*)

function gValueGetObject(const gvalue: WGValue): PWGObject;

procedure gValueGetValue(const gvalue: WGValue; out value: gint); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: gboolean); overload; // LongBool
procedure gValueGetValue(const gvalue: WGValue; out value: Boolean); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: gfloat); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: gdouble); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: guint); overload;
//procedure gValueGetValue(const gvalue: WGValue; out value: AnsiString); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: UTF8String); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: WideString); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: Byte); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: Int64); overload;
procedure gValueGetValue(const gvalue: WGValue; out value: gchar); overload;
function gValueGetBoxed(const gvalue: WGValue): PGBoxed;
function gValueGetEnum(const gvalue: WGValue): gint;
procedure gValueFromVariant(var gvalue: WGValue; value: Variant);
function gValueToVariant(const gvalue: WGValue): Variant;

procedure gValueSetValue(var gvalue: WGValue; const value: gint); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: gboolean); overload;
//procedure gValueSetValue(var gvalue: WGValue; const value: Boolean); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: gfloat); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: gdouble); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: guint); overload;
//procedure gValueSetValue(var gvalue: WGValue; const value: AnsiString); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: UTF8String); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: WideString); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: Byte); overload;
procedure gValueSetValue(var gvalue: WGValue; const value: Int64); overload;
procedure gValueSetValue(var gvalue: WGValue; const anobject: PWGObject); overload;
procedure gValueUnset(var gvalue: WGValue);

procedure gValueSetUTF8String(var gvalue: WGValue; const value: UTF8String);
function gParamSpecGetName(var paramspec): UTF8String;

implementation
uses utyperegistry
(*$IFDEF FPCOOLD*)
, uutf8codec
(*$ENDIF FPCOOLD*)
;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
function g_value_init(value: PWGValue; g_type: TGType): PWGValue; cdecl; external gobjectlib;
function g_value_get_int(const value: PWGValue): gint; cdecl; external gobjectlib;
function g_value_get_float(const value: PWGValue): gfloat; cdecl; external gobjectlib;
function g_value_get_double(const value: PWGValue): gdouble; cdecl; external gobjectlib;
function g_value_get_uchar(const value: PWGValue): guchar; cdecl; external gobjectlib;
function g_value_get_char(const value: PWGValue): gchar; cdecl; external gobjectlib;
function g_value_get_object(const value: PWGValue): PWGObject; cdecl; external gobjectlib;
function g_value_get_uint(const value: PWGValue): guint; cdecl; external gobjectlib;
function g_value_get_boolean(const value: PWGValue): gboolean; cdecl; external gobjectlib;
function g_value_get_string(const value: PWGValue): PGChar; cdecl; external gobjectlib;
procedure g_value_set_string(value: PWGValue; v_string: PGChar); cdecl; external gobjectlib;
procedure g_value_set_string_take_ownership(value: PWGValue; v_string: PGChar); cdecl; external gobjectlib;
procedure g_value_unset(value: PWGValue); cdecl; external gobjectlib;
procedure g_value_set_int(value: PWGValue; v_int: gint); cdecl; external gobjectlib;
procedure g_value_set_int64(value: PWGValue; v_int64: Int64); cdecl; external gobjectlib;
procedure g_value_set_float(value: PWGValue; v_float: gfloat); cdecl; external gobjectlib;
procedure g_value_set_double(value: PWGValue; v_double: gdouble); cdecl; external gobjectlib;
procedure g_value_set_boolean(value: PWGValue; v_bool: gboolean); cdecl; external gobjectlib;
procedure g_value_set_uint(value: PWGValue; v_uint: guint); cdecl; external gobjectlib;
procedure g_value_set_uchar(value: PWGValue; v_uchar: guchar); cdecl; external gobjectlib;
procedure g_value_set_object(value: PWGValue; v_object: PWGObject); cdecl; external gobjectlib;
function g_value_get_boxed(value: PWGValue): {g}Pointer; cdecl; external gobjectlib;
function g_value_dup_boxed(value: PWGValue): {g}Pointer; cdecl; external gobjectlib;
function g_value_get_enum(const value: PWGValue): gint; cdecl; external gobjectlib;
function g_param_spec_get_name(paramspec: Pointer): PGChar; cdecl; external gobjectlib; // const
function g_value_get_int64(const value: PWGValue): gint64; cdecl; external gobjectlib;
{$endif gtk2q_standalone}

function gValueInit(typ: Integer): WGValue;
begin
  FillChar(Result, sizeof(Result), 0);
  g_value_init(@Result, typ);
end;

procedure gValueUnset(var gvalue: WGValue);
begin
  g_value_unset(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: gchar); overload;
begin
  value := g_value_get_char(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: Byte); overload;
begin
  value := g_value_get_uchar(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: Int64); overload;
begin
  value := g_value_get_int64(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: gint); overload;
begin
  value := g_value_get_int(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: Boolean); overload;
begin
  value := g_value_get_boolean(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: gboolean); overload;
begin
  value := g_value_get_boolean(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: gfloat); overload;
begin
  value := g_value_get_float(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: gdouble); overload;
begin
  value := g_value_get_double(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: guint); overload;
begin
  // assert g_value_type = uint TODO
  value := g_value_get_uint(@gvalue);
end;

procedure gValueGetValue(const gvalue: WGValue; out value: PWGObject); overload;
begin
  // assert type
  value := g_value_get_object(@gvalue);
end;

function gValueGetEnumLike(const gvalue: WGValue): Integer; overload;
begin
  // assert type
  Result := g_value_get_int(@gvalue);
end;

(*
procedure gValueGetValue(const gvalue: WGValue; out value: AnsiString); overload;
var
  s: PGChar;
begin
  // TODO check that it doesnt contain utf8 ?
  s := g_value_get_string(@gvalue);
  value := PChar(s);
  //g_free(s); not allowed
end;
*)

procedure gValueGetValue(const gvalue: WGValue; out value: UTF8String); overload;
var
  s: PGChar;
begin
  s := g_value_get_string(@gvalue);
  value := PChar(s);
  //g_free(s); not allowed
end;

procedure gValueGetValue(const gvalue: WGValue; out value: WideString); overload;
var
  s: UTF8String;
begin
  gValueGetValue(gvalue, s);
  value := UTF8Decode(s);
end;

(*
function gValueGetgint(const gvalue: WGValue): gint; 
begin
  Result := g_value_get_int(@gvalue);
end;
*)

procedure gValueSetValue(var gvalue: WGValue; const value: Int64); overload;
begin
  g_value_set_int64(@gvalue, value);
end;

procedure gValueSetValue(var gvalue: WGValue; const value: gint); overload;
begin
  g_value_set_int(@gvalue, value);
end;

{procedure gValueSetValue(var gvalue: WGValue; const value: Boolean); overload;
begin
  g_value_set_boolean(@gvalue, value);
end;}

procedure gValueSetValue(var gvalue: WGValue; const value: gboolean); overload;
begin
  g_value_set_boolean(@gvalue, value);
end;

procedure gValueSetValue(var gvalue: WGValue; const value: gfloat); overload;
begin
  g_value_set_float(@gvalue, value);
end;

procedure gValueSetValue(var gvalue: WGValue; const value: gdouble); overload;
begin
  g_value_set_double(@gvalue, value);
end;

procedure gValueSetValue(var gvalue: WGValue; const value: guint); overload;
begin
  g_value_set_uint(@gvalue, value);
end;

{procedure gValueSetValue(var gvalue: WGValue; const value: AnsiString);
var
  us: UTF8String;
begin
  us := value;
  gValueSetUTF8String(gvalue, value);
end;}

procedure gValueSetValue(var gvalue: WGValue; const value: UTF8String); overload;
begin
  gValueSetUTF8String(gvalue, value);
end;

procedure gValueSetUTF8String(var gvalue: WGValue; const value: UTF8String);
begin
  g_value_set_string(@gvalue, PGChar(PChar(value))); // utf ?
end;

procedure gValueSetValue(var gvalue: WGValue; const value: WideString); overload;
var
  us: UTF8String;
begin
  us := UTF8Encode(value);
  gValueSetUTF8String(gvalue, us);
end;

procedure gValueSetValue(var gvalue: WGValue; const value: Byte); overload;
begin
  g_value_set_uchar(@gvalue, value);
end;

procedure gValueSetValue(var gvalue: WGValue; const anobject: PWGObject); overload;
begin
  //assert(G_TYPE_CHECK_INSTANCE_TYPE(anobject, G_TYPE_OBJECT)); // or derived
  g_value_set_object(@gvalue, anobject);
end;

function gValueGetEnum(const gvalue: WGValue): gint;
begin
  Result := g_value_get_enum(@gvalue);
end;

function gValueGetBoxed(const gvalue: WGValue): PGBoxed;
begin
  Result := g_value_get_boxed(@gvalue);
end;

function gValueGetObject(const gvalue: WGValue): PWGObject;
begin
  gValueGetValue(gvalue, Result);
end;

function gValueToVariant(const gvalue: WGValue): Variant;
var
  vint: gint; (*Integer;*)
  vuint: guint;
  vbool: Boolean;
  vstring: UTF8String;
  vlong: Longint;
  vulong: gulong;
  vchar: char;
  vuchar: Byte;
  vfloat: Single;
  vdouble: Double;
  vint64: Int64;
  vi: IGObject;
begin
  Result := Null;
  case gvalue.g_type of
  G_TYPE_INT: begin gValueGetValue(gvalue, vint); Result := vint; end;
  G_TYPE_INT64: begin gValueGetValue(gvalue, vint64); Result := vint64; end;
  G_TYPE_UINT: begin gValueGetValue(gvalue, vuint); Result := vuint; end;
  G_TYPE_UINT64: raise EVariantError.Create('gValueToVariant: UInt64 unsupported');
  G_TYPE_STRING: begin gValueGetValue(gvalue, vstring); Result := vstring; end;
  G_TYPE_LONG: begin gValueGetValue(gvalue, vlong); Result := vlong; end;
  G_TYPE_ULONG: begin gValueGetValue(gvalue, vulong); Result := vulong; end;
  G_TYPE_BOOLEAN: begin gValueGetValue(gvalue, vbool); Result := vbool; end;
  G_TYPE_CHAR: begin gValueGetValue(gvalue, vchar); Result := vchar; end;
  G_TYPE_UCHAR: begin gValueGetValue(gvalue, vuchar); Result := vuchar; end;
  G_TYPE_BOXED: raise EVariantError.Create('gValueToVariant: boxed types unsupported');
  G_TYPE_FLOAT: begin gValueGetValue(gvalue, vfloat); Result := vfloat; end;
  G_TYPE_DOUBLE: begin gValueGetValue(gvalue, vdouble); Result := vdouble; end;
  G_TYPE_ENUM: begin Result := gValueGetEnum(gvalue); end;
  G_TYPE_OBJECT:
    begin
      vi := WrapGObject(gValueGetObject(gvalue));
(*$IFDEF FPCOLD*)
      Result := Null; (* this is a rather bad fpc bug. submitted it and waiting for a fix. *)
(*$ELSE*)
      Result := vi;
(*$ENDIF FPCOLD*)
    end;
  (*g_strv_get_type(): begin gValueGetStrv(gvalue, ?); Result := VarArray(strvconveach); end;*)
  (*G_TYPE_VALUE*)
  (*G_TYPE_GSTRING*)
  (*G_TYPE_INTERFACE*)
  else
    begin
      raise EVariantError.Create('gValueToVariant: unknown gtype to stuff into variant');
    end;
  end;
end;

procedure gValueFromVariant(var gvalue: WGValue; value: Variant);
var
  vint: Integer;
  vuint: guint;
  vbool: Boolean;
  vstring: UTF8String;
  vstring1: AnsiString;
(*  vlong: Longint;*)
  vchar: gint8;
(*  vulong: gulong;*)
  vuchar: Byte;
  vfloat: Single;
  vdouble: Double;
  vint64: Int64;
begin
  case (VarType(value) and (4095 or varArray)) of
  varNull: gValueUnset(gvalue);
  varSmallint: begin vint := value; gValueSetValue(gvalue, vint); end;
  varInteger: begin vint := value; gValueSetValue(gvalue, vint); end;
  varSingle: begin vfloat := value; gValueSetValue(gvalue, vfloat); end;
  varDouble: begin vdouble := value; gValueSetValue(gvalue, vdouble);end;
  varCurrency: begin vdouble := value; gValueSetValue(gvalue, vdouble); end;
  varDate: EVariantError.Create('gValueFromVariant: unsupported date variant type for gvalue'); (*begin  := ; gValueSetValue(gvalue, ); end;*)
  varOleStr:
    begin
      vstring := UTF8Encode(value);
      gValueSetValue(gvalue, vstring);
    end;
  varBoolean: begin vbool := value; gValueSetValue(gvalue, vbool); end;
  varShortInt: begin vchar := value; gValueSetValue(gvalue, vchar); end;
  varByte: begin vuchar := value; gValueSetValue(gvalue, vuchar); end;
  varWord: begin vuint := value; gValueSetValue(gvalue, vuint); end;
  varLongWord: begin vint := value; gValueSetValue(gvalue, vint); end;
//  varInt64: raise EVariantError.Create('gValueFromVariant: Int64 unsupported');
  varInt64: begin vint64 := value; gValueSetValue(gvalue, vint64); end;
  varString: begin vstring1 := value; vstring := vstring1; gValueSetValue(gvalue, vstring); end;

  else begin
    raise EVariantError.Create('gValueFromVariant: unknown variant type for gvalue');
  (*  
  vt gValueSetValue(value, );
  varUnknown: gValueSetValue(value, );
  varEmpty: gValueSetValue(value, );
  varAny: gValueSetValue(value, );
  varDispatch: gValueSetValue(value, );
  varStrArg: gValueSetValue(value, );
  varVariant: gValueSetValue(value, );
  varError: gValueSetValue(value, );
  *)
    end;
  end;
end;


function gParamSpecGetName(var paramspec): UTF8String;
begin
  Result := PChar(g_param_spec_get_name(@paramspec));
end;



end.
