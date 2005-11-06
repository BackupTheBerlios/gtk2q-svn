unit ugparamspec;
(* TODO *)
interface
uses ugtypes, iugparamspec;

// still unused

// interesting: #define G_PARAM_SPEC_TYPE_NAME(pspec)	(g_type_name (G_PARAM_SPEC_TYPE (pspec))
type
  DGParamSpec = class(TCustomGInterfacedObject, IGParamSpec, IInterface)
  protected
    procedure UnrefUnderlyingObject; override;
    procedure RefUnderlyingObject; override;
    procedure SinkUnderlyingObject; override;
  public
    function GetUnderlying: Pointer;

  protected
    constructor CreateWrapped(p: Pointer);
    function GetName: UTF8String;
    function GetNick: UTF8String;
    function GetBlurb: UTF8String;
    function GetRedirectTarget: IGParamSpec;
    function GetFlags: DParamFlags;
    function FlagsToNative(flags: DParamFlags): Integer;
  published
    property Name: UTF8String read GetName;
    property Nick: UTF8String read GetNick;
    property Blurb: UTF8String read GetBlurb;
    property Flags: DGParamFlags;
    // (set of (readable,writable,construct,constructonly,laxvalidation,private))
    property RedirectTarget: IGParamSpec read GetRedirectTarget; // if any
  
    ValueType: GType ?

    //not exposed: OwnerType // class or interface using this property
  end;
  DGParamSpecClass = class of DGParamSpec;
  
  DGParamSpecStringCSet = set of char;
  DGParamSpecString = class(DGParamSpec, IGParamSpecString, IGParamSpec, IInterface)
  public
    // TODO: write??
    function GetDefaultValue: UTF8String;
    function CSetFirst: DGParamSpecStringCSet;
    function CSetNth: DGParamSpecStringCSet;
    function Substitutor: char;
    function NullFoldIfEmpty: Boolean;
    function EnsureNonNull: Boolean;
    
    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: xxx; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;
    
  published
    property DefaultValue: UTF8String read GetDefaultValue;
    property CSetFirst: DGParamSpecStringCSet read GetCSetFirst;
    property CSetNth: DGParamSpecStringCSet read GetCSetNth;
    property Substitutor: char read GetSubstitutor;
    property NullFoldIfEmpty: Boolean read GetNullFoldIfEmpty;
    property EnsureNonNull: Boolean read GetEnsureNonNull;
  end;

  DGParamSpecByte = class(DGParamSpec, IGParamSpecByte, IGParamSpec, IInterface)
  public
    function GetMinimum: Byte;
    function GetMaximum: Byte;
    function GetDefaultValue: Byte;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: xxx; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;

  published
    property Minimum: Byte read GetMinimum;
    property Maximum: Byte read GetMaximum;
    property DefaultValue: Byte read GetDefaultValue;
  end;

  DGParamSpecInt = class(DGParamSpec, IGParamSpecInt, IGParamSpec, IInterface)
  public
    function GetMinimum: Integer;
    function GetMaximum: Integer;
    function GetDefaultValue: Integer;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Integer = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecInt;

  published
    property Minimum: Integer read GetMinimum;
    property Maximum: Integer read GetMaximum;
    property DefaultValue: Integer read GetDefaultValue;
  end;

  DGParamSpecUInt = class(DGParamSpec, IGParamSpecUInt, IGParamSpec, IInterface)
  public
    function GetMinimum: guint;
    function GetMaximum: guint;
    function GetDefaultValue: guint;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: guint = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecUInt;

  published
    property Minimum: guint read GetMinimum;
    property Maximum: guint read GetMaximum;
    property DefaultValue: guint read GetDefaultValue;
  end;

  DGParamSpecInt64 = class(DGParamSpec, IGParamSpecInt64, IGParamSpec, IInterface)
  public
    function GetMinimum: Int64;
    function GetMaximum: Int64;
    function GetDefaultValue: Int64;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Int64; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;

  published
    property Minimum: Int64 read GetMinimum;
    property Maximum: Int64 read GetMaximum;
    property DefaultValue: Int64 read GetDefaultValue;
  end;
  
  DGParamSpecUInt64 = class(DGParamSpec, IGParamSpecUInt64, IGParamSpec, IInterface)
  public
    function GetMinimum: guInt64;
    function GetMaximum: guInt64;
    function GetDefaultValue: guInt64;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: guInt64; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;

  published
    property Minimum: guInt64 read GetMinimum;
    property Maximum: guInt64 read GetMaximum;
    property DefaultValue: guInt64 read GetDefaultValue;
  end;


  DGParamSpecLong = class(DGParamSpec, IGParamSpecLong, IGParamSpec, IInterface)
  public
    function GetMinimum: Longint;
    function GetMaximum: Longint;
    function GetDefaultValue: Longint;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Longint = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecLong;

  published
    property Minimum: Longint read GetMinimum;
    property Maximum: Longint read GetMaximum;
    property DefaultValue: Longint read GetDefaultValue;
  end;

  DGParamSpecULong = class(DGParamSpec, IGParamSpecULong, IGParamSpec, IInterface)
  public
    function GetMinimum: gulong;
    function GetMaximum: gulong;
    function GetDefaultValue: gulong;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: gulong = 0;
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecULong;

  published
    property Minimum: gulong read GetMinimum;
    property Maximum: gulong read GetMaximum;
    property DefaultValue: gulong read GetDefaultValue;
  end;

  DGParamSpecSingle = class(DGParamSpec, IGParamSpecSingle, IGParamSpec, IInterface) // --> float
  public
    function GetMinimum: Single;
    function GetMaximum: Single;
    function GetDefaultValue: Single;
    function GetEpsilon: Single;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Single = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecSingle;

  published
    property Minimum: Single read GetMinimum;
    property Maximum: Single read GetMaximum;
    property DefaultValue: Single read GetDefaultValue;
    property Epsilon: Single read GetEpsilon;
  end;

  DGParamSpecDouble = class(DGParamSpec, IGParamSpecDouble, IGParamSpec, IInterface)
  public
    function GetMinimum: Double;
    function GetMaximum: Double;
    function GetDefaultValue: Double;
    function GetEpsilon: Double;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Double = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecInt;

  published
    property Minimum: Doubler read GetMinimum;
    property Maximum: Double read GetMaximum;
    property DefaultValue: Double read GetDefaultValue;
    property Epsilon: Double read GetEpsilon;
  end;

  DGParamSpecInt8 = class(DGParamSpec, IGParamSpecInt8, IGParamSpec, IInterface)
  public
    function GetMinimum: gint8;
    function GetMaximum: gint8;
    function GetDefaultValue: gint8;

    class function Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: xxx; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;
  published
    property Minimum: gint8 read GetMinimum;
    property Maximum: gint8 read GetMaximum;
    property DefaultValue: gint8 read GetDefaultValue;
  end;

  DGParamSpecBoxed = class(DGParamSpec, IGParamSpecBoxed, IGParamSpec, IInterface)
  public
    class function Create(name, nick, blurb: UTF8String;
      boxedType: GType;
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecBoxed;
  end;

  DGParamSpecBoolean = class(DGParamSpec, IGParamSpecBoolean, IGParamSpec, IInterface)
  public
    function GetDefaultValue: Boolean;
    
    class function Create(name, nick, blurb: UTF8String; 
      defaultValue: Boolean = False; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecBoolean;

  published
    property DefaultValue: Boolean read GetDefaultValue;    
  end;

  DGParamSpecObject = class(DGParamSpec, IGParamSpecBoxed, IGParamSpecObject, IGParamSpec, IInterface) -> special handling
  public
    class function Create(name, nick, blurb: UTF8String;
      objectType: GType; flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecObject;
  end;

  DGParamSpecEnum = class(DGParamSpec, IGParamSpecEnum, IGParamSpec, IInterface) -> special handling
  public
    function GetDefaultValue: Integer; (* not quite *)

    class function Create(name, nick, blurb: UTF8String; 
      enumType: GType; (* FIXME do that properly *)
      defaultValue: Boolean = False; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecEnum;

  published    
    property DefaultValue: Integer read GetDefaultValue;
  end;

  // DGParamSpecOverride = class
  // end;

// g_param_spec_override 
// g_param_spec_param ??
// g_param_spec_pointer ??
// g_param_spec_pool_*
// g_param_spec_set_qdata




  DGParamSpecUnichar = class(DGParamSpec, IGParamSpecUnichar, IGParamSpec, IInterface)
  public
    function GetDefaultValue: GUniChar;
    
    class function Create(name, nick, blurb: UTF8String; 
      defaultValue: GUniChar(*fixme default *); 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecUnichar;
    
  published
    property DefaultValue: GUniChar read GetDefaultValue;
  end;

/*DGParamSpecValueArray O_O*/

function ParamSpecCreateWrapped(pspec: PGParamSpec): IGParamSpec; // tries to choose the right one

implementation
uses uwrapgnames;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}

procedure g_param_spec_unref(spec: PGParamSpec); cdecl; external glib;
function g_param_spec_ref(spec: PGParamSpec): PGParamSpec; cdecl; external glib;
procedure g_param_spec_sink(spec: PGParamSpec); cdecl; external glib;
function g_param_spec_get_name(spec: PGParamSpec); cdecl; external glib; // const
function g_param_spec_get_blurb(spec: PGParamSpec); cdecl; external glib; // const
function g_param_spec_get_nick(spec: PGParamSpec); cdecl; external glib; // const

function g_param_spec_string(const name, nick, blurb: PGChar; 
  defaultValue: PGChar; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_uchar(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: guint8; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_char(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: gint8; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_int(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: gint; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_int64(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: Int64; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_uint(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: Int64; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_uint64(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: guint64; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_float(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: gfloat; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_double(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: gdouble; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_boolean(const name, nick, blurb: PGChar; 
  defaultValue: gboolean; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_long(const name, nick, blurb: PGChar; 
  minimum, maximum, defaultValue: glong; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
function g_param_spec_enum(const name, nick, blurb: PGChar; 
  defaultValue: gint; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
// g_param_spec_get_redirect_target
function g_param_spec_unichar(const name, nick, blurb: PGChar; 
  defaultValue: gunichar; flags: TGParamFlags): PGParamSpec; cdecl; external glib;
{$endif gtk2q_standalone}

constructor DGParamSpec.CreateWrapped(p: Pointer);
begin
  inherited Create;
  Fobject := p;
end;

procedure DGParamSpec.UnrefUnderlyingObject;
begin
  g_param_spec_unref(Fobject);
end;

procedure DGParamSpec.RefUnderlyingObject;
begin
  g_param_spec_ref(Fobject);
end;

procedure DGParamSpec.SinkUnderlyingObject;
begin
  if Assigned(Fobject) then
    g_param_spec_sink(Fobject);
end;

(* DGParamSpec *)

function DGParamSpec.GetNick: UTF8String;
begin
  Result := PChar(g_param_spec_get_nick(GetUnderlying));
end;

function DGParamSpec.GetBlurb: UTF8String;
begin
  Result := PChar(g_param_spec_get_blurb(GetUnderlying));
end;

function DGParamSpec.GetRedirectTarget: IGParamSpec;
var
  pspec: PGParamSpec;
begin
  pspec := g_param_spec_get_redirect_target(GetUnderlying);
  if not Assigned(pspec) then begin
    Result := nil;
    Exit;
  end;
  
  Result := ParamSpecCreateWrapped(pspec) as IGParamSpec;
end;

function DGParamSpec.GetName: UTF8String;
begin
  Result := PChar(g_param_spec_get_name(GetUnderlying)); // utf
end;

function DGParamSpec.GetFlags: DParamFlags;
var
  uflags: Integer;
  flags: DParamFlags;
begin
  uflags := PGParamSpec(GetUnderlying)^.Flags;
  
  if (uflags and G_PARAM_READABLE) <> 0 then flags := flags + [pReadable];
  if (uflags and G_PARAM_WRITABLE) <> 0 then flags := flags + [pWritable];
  if (uflags and G_PARAM_CONSTRUCT) <> 0 then flags := flags + [pConstruct];
  if (uflags and G_PARAM_CONSTRUCT_ONLY) <> 0 then flags := flags + [pConstructOnly];
  if (uflags and G_PARAM_LAX_VALIDATION) <> 0 then flags := flags + [pLaxValidation];
  if (uflags and G_PARAM_PRIVATE) <> 0 then flags := flags + [pPrivate];
  Result := flags;
end;

function DGParamSpec.FlagsToNative(flags: DParamFlags): Integer;
begin
  Result := 0;
  if pReadable in flags then Result := Result or G_PARAM_READABLE;
  if pWritable in flags then Result := Result or G_PARAM_WRITABLE;
  if pConstruct in flags then Result := Result or G_PARAM_CONSTRUCT;
  if pConstructOnly in flags then Result := Result or G_PARAM_CONSTRUCT_ONLY;
  if pLaxValidation in flags then Result := Result or G_PARAM_LAX_VALIDATION;
  if pPrivate in flags then Result := Result or G_PARAM_PRIVATE;
end;

(* DGParamSpecString *)

class function DGParamSpecString.Create(name, nick, blurb, defaultValue: UTF8String; flags: DGParamFlags): IGParamSpecString;
begin
  Result := CreateWrapped(g_param_spec_string(
  PChar(name), PChar(nick), PChar(blurb), PChar(defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecString.GetDefaultValue: UTF8String;
var
  d: PGChar;
begin
  d := PGParamSpecString(GetUnderlying)^.DefaultValue;
  if not Assigned(d) then begin
    Result := '';
    Exit;
  end;
  
  Result := PChar(d);
end;

function GParamSpecCSetOfString(s: PGChar): DGParamSpecStringCSet;
var
  st: string;
begin
  Result := [];
  if not Assigned(s) then Exit;
  
  st := PChar(s);
  for i := 1 to Length(st) do begin
    Result := Result + [st[i]];
  end;  
end;

function DGParamSpecString.GetCSetFirst: DGParamSpecStringCSet;
begin
  Result := GParamSpecCSetOfString(PGParamSpecString(Fobject)^.csetfirst);
end;

function DGParamSpecString.GetCSetNth: DGParamSpecStringCSet;
begin
  Result := GParamSpecCSetOfString(PGParamSpecString(Fobject)^.csetnth);
end;

function DGParamSpecString.GetSubstitutor: char;
begin
  Result := PGParamSpecString(Fobject)^.substitutor;
end;

function DGParamSpecString.GetNullFoldIfEmpty: Boolean;
begin
  Result := PGParamSpecString(Fobject)^.nullfoldifempty;
end;

function DGParamSpecString.GetEnsureNonNull: Boolean;
begin
  Result := PGParamSpecString(Fobject)^.ensurenonnull;
end;

(* DGParamSpecByte *)

class function DGParamSpecString.Create(name, nick, blurb, defaultValue: UTF8String; flags: DGParamFlags): IGParamSpecString;
begin
  Result := CreateWrapped(g_param_spec_string(
  PChar(name), PChar(nick), PChar(blurb), PChar(defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecByte.GetMinimum: Byte;
begin
  Result := PGParamSpecByte(Fobject)^.minimum;
end;

function DGParamSpecByte.GetMaximum: Byte;
begin
  Result := PGParamSpecByte(Fobject)^.maximum;
end;

function DGParamSpecByte.GetDefaultValue: Byte;
begin
  Result := PGParamSpecByte(Fobject)^.defaultValue;
end;

(* DGParamSpecInt *)

class function DGParamSpecInt.Create(name, nick, blurb, defaultValue: Integer = 0; flags: DGParamFlags): IGParamSpecInt;
begin
  Result := CreateWrapped(g_param_spec_int(
  PChar(name), PChar(nick), PChar(blurb), (defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecInt.GetMinimum: Integer;
begin
  Result := PGParamSpecInt(Fobject)^.minimum;
end;

function DGParamSpecInt.GetMaximum: Integer;
begin
  Result := PGParamSpecInt(Fobject)^.maximum;
end;

function DGParamSpecInt.GetDefaultValue: Integer;
begin
  Result := PGParamSpecInt(Fobject)^.defaultvalue;
end;

(* DGParamSpecInt64 *)
class function DGParamSpecString.Create(name, nick, blurb: UTF8String;
   minimum, maximum, defaultValue: Int64; flags: DGParamFlags): IGParamSpecInt64;
begin
  Result := CreateWrapped(g_param_spec_int64(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum, (defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecInt64.GetMinimum: Int64;
begin
  Result := PGParamSpecInt64(Fobject)^.minimum;
end;

function DGParamSpecInt64.GetMaximum: Int64;
begin
  Result := PGParamSpecInt64(Fobject)^.maximum;
end;

function DGParamSpecInt64.GetDefaultValue: Int64;
begin
  Result := PGParamSpecInt64(Fobject)^.defaultvalue;
end;


(* DGParamSpecInt8 *)

class function DGParamSpecString.Create(name, nick, blurb, defaultValue: UTF8String; flags: DGParamFlags): IGParamSpecString;
begin
  Result := CreateWrapped(g_param_spec_string(
  PChar(name), PChar(nick), PChar(blurb), PChar(defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecInt8.GetMinimum: gint8;
begin
  Result := PGParamSpecInt8(Fobject)^.minimum;
end;

function DGParamSpecInt8.GetMaximum: gint8;
begin
  Result := PGParamSpecInt8(Fobject)^.maximum;
end;

function DGParamSpecInt8.GetDefaultValue: gint8;
begin
  Result := PGParamSpecInt8(Fobject)^.defaultValue;
end;

(* DGParamSpecBoolean *)

class function DGParamSpecBoolean.Create(name, nick, blurb: UTF8String; 
      defaultValue: Boolean = False; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecBoolean;
begin
  Result := CreateWrapped(g_param_spec_boolean(
  PChar(name), PChar(nick), PChar(blurb), (defaultValue), FlagsToNative(flags)
  )) as IGParamSpecBoolean;
end;

function DGParamSpecBoolean.GetDefaultValue: Boolean;
begin
  Result := PGParamSpecBoolean(Fobject)^.defaultValue;
end;

(* DGParamSpecSingle *)

class function DGParamSpecSingle.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Single = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecSingle;
begin
  Result := CreateWrapped(g_param_spec_float(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum, (defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecSingle.GetMinimum: Single;
begin
  Result := PGParamSpecFloat(Fobject)^.minimum;
end;

function DGParamSpecSingle.GetMaximum: Single;
begin
  Result := PGParamSpecFloat(Fobject)^.maximum;
end;

function DGParamSpecSingle.GetEpsilon: Single;
begin
  Result := PGParamSpecFloat(Fobject)^.epsilon;
end;

function DGParamSpecSingle.GetDefaultValue: Single;
begin
  Result := PGParamSpecFloat(Fobject)^.defaultValue;
end;

(* DGParamSpecDouble *)

class function DGParamSpecDouble.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Double = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecDouble;
begin
  Result := CreateWrapped(g_param_spec_double(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum, (defaultValue), FlagsToNative(flags)
  ));
end;

function DGParamSpecDouble.GetMinimum: Double;
begin
  Result := PGParamSpecDouble(Fobject)^.minimum;
end;

function DGParamSpecDouble.GetMaximum: Double;
begin
  Result := PGParamSpecDouble(Fobject)^.maximum;
end;

function DGParamSpecDouble.GetEpsilon: Double;
begin
  Result := PGParamSpecDouble(Fobject)^.epsilon;
end;

function DGParamSpecDouble.GetDefaultValue: Double;
begin
  Result := PGParamSpecDouble(Fobject)^.defaultValue;
end;

(* DGParamSpecLong *)

class function DGParamSpecLong.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: Longint; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;
begin
  Result := CreateWrapped(g_param_spec_long(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum, (defaultValue), FlagsToNative(flags)
  )) as IGParamSpecString;
end;

function DGParamSpecLong.GetMinimum: Longint;
begin
  Result := PGParamSpecLong(Fobject)^.minimum;
end;

function DGParamSpecLong.GetMaximum: Longint;
begin
  Result := PGParamSpecLong(Fobject)^.maximum;
end;

function DGParamSpecLong.GetDefaultValue: Longint;
begin
  Result := PGParamSpecLong(Fobject)^.defaultValue;
end;

(* DGParamSpecEnum *)

class function DGParamSpecEnum.Create(name, nick, blurb: UTF8String; 
      enumtype: GType;
      defaultValue: Boolean = False; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecEnum;
begin
  Result := CreateWrapped(g_param_spec_enum(
  PChar(name), PChar(nick), PChar(blurb), enumtype, (defaultValue), FlagsToNative(flags)
  )) as IGParamSpecEnum;
end;

function DGParamSpecEnum.GetDefaultValue: Integer; (* not quite *)
begin
  Result := PGParamSpecEnum(Fobject)^.defaultValue;
end;

(* DGParamSpecBoxed *)

class function DGParamSpecBoxed.Create(name, nick, blurb: UTF8String;
      boxedType: GType;
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecBoxed;
begin
  Result := CreateWrapped(g_param_spec_boxed(
  PChar(name), PChar(nick), PChar(blurb), boxedType, FlagsToNative(flags)
  )) as IGParamSpecBoxed;
end;

(* DGParamSpecObject *)

class function DGParamSpecObject.Create(name, nick, blurb: UTF8String;
      objectType: GType; flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecObject;
begin
  Result := CreateWrapped(g_param_spec_object(
  PChar(name), PChar(nick), PChar(blurb), objectType, FlagsToNative(flags)
  )) as IGParamSpecObject;
end;

(* DGParamSpecUnichar *)

class function DGParamSpecUnichar.Create(name, nick, blurb: UTF8String; 
      defaultValue: GUniChar(*fixme default *); 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecUnichar;
begin
  Result := CreateWrapped(g_param_spec_unichar(
  PChar(name), PChar(nick), PChar(blurb), defaultValue, FlagsToNative(flags)
  )) as IGParamSpecUnichar;
end;

function DGParamSpecUnichar.GetDefaultValue: GUniChar;
begin
  Result := PGParamSpecUnichar(Fobject)^.defaultValue;
end;

(* DGParamSpecUInt *)

class function DGParamSpecUInt.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: guint = 0; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecUInt;
begin
  Result := CreateWrapped(g_param_spec_unichar(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum,
  defaultValue, FlagsToNative(flags)
  )) as IGParamSpecUInt;
end;

function DGParamSpecUInt.GetMinimum: guint;
begin
  Result := PGParamSpecUInt(Fobject)^.minimum;
end;

function DGParamSpecUInt.GetMaximum: guint;
begin
  Result := PGParamSpecUInt(Fobject)^.maximum;
end;

function DGParamSpecUInt.GetDefaultValue: guint;
begin
  Result := PGParamSpecUInt(Fobject)^.defaultValue;
end;

(* DGParamSpecUInt64 *)

class function DGParamSpecUInt64.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: guInt64; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecString;
begin
  Result := CreateWrapped(g_param_spec_uint64(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum,
  defaultValue, FlagsToNative(flags)
  )) as IGParamSpecUInt64;
end;

function DGParamSpecUInt64.GetMinimum: guInt64;
begin
  Result := PGParamSpecUInt64(Fobject)^.minimum;
end;

function DGParamSpecUInt64.GetMaximum: guInt64;
begin
  Result := PGParamSpecUInt64(Fobject)^.maximum;
end;

function DGParamSpecUInt64.GetDefaultValue: guInt64;
begin
  Result := PGParamSpecUInt64(Fobject)^.defaultValue;
end;

(* DGParamSpecULong *)
class function DGParamSpecULong.Create(name, nick, blurb: UTF8String; 
      minimum, maximum, defaultValue: gulong = 0;
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecULong;
begin
  Result := CreateWrapped(g_param_spec_ulong(
  PChar(name), PChar(nick), PChar(blurb), minimum, maximum,
  defaultValue, FlagsToNative(flags)
  )) as IGParamSpecULong;
end;

function DGParamSpecULong.GetMinimum: gulong;
begin
  Result := PGParamSpecULong(Fobject)^.minimum;
end;

function DGParamSpecULong.GetMaximum: gulong;
begin
  Result := PGParamSpecULong(Fobject)^.maximum;
end;

function DGParamSpecULong.GetDefaultValue: gulong;
begin
  Result := PGParamSpecULong(Fobject)^.defaultValue;
end;

(* generic *)

function ParamSpecCreateWrapped(pspec: PGParamSpec): IGParamSpec; // tries to choose the right one
var
  klass: DGParamSpecClass;
  vtype: GType;
begin
  if not Assigned(pspec) then begin 
    Result := nil;
  end;
  
  klass := DGParamSpec;

  vtype := psec^.valueType;
  
  Result := nil;
      
  case vtype of
  G_TYPE_STRING: Result := DGParamSpecString;
  G_TYPE_INT: Result := DGParamSpecInt;
  G_TYPE_UINT: Result := DGParamSpecUInt;
  G_TYPE_LONG: Result := DGParamSpecLong;
  G_TYPE_ULONG: Result := DGParamSpecULong;
  G_TYPE_INT64: Result := DGParamSpecInt64;
  G_TYPE_UINT64: Result := DGParamSpecUInt64;
  G_TYPE_CHAR: Result := DGParamSpecInt8;
  G_TYPE_UCHAR: Result := DGParamSpecByte;
  G_TYPE_SINGLE: Result := DGParamSpecSingle;
  G_TYPE_DOUBLE: Result := DGParamSpecDouble;
  G_TYPE_BOOLEAN: Result := DGParamSpecBoolean;
  G_TYPE_IS_ENUM: Result := DGParamSpecEnum;
  G_TYPE_BOXED: 
    begin
      if G_TYPE_IS_OBJECT(vtype) then 
        Result := DGParamSpecObject
      else
        Result := DGParamSpecBoxed;
    end;
  end;
  
  if not Assigned(Result) then
    Result := DGParamSpec.CreateWrapped(pspec);
end;
  
//  ValueType: GType ?

end.
