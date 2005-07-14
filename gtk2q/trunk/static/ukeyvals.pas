unit ukeyvals;

// unused

interface
uses sysutils, ugtypes;

type
  EKeyInvalid = class(Exception)
  end;
  DKeyvals = class
  public
    function GetKeyval(name: UTF8String): guint; overload;
    function GetKeyname(keyval: guint): UTF8String;
   
    (*
    function GetLower(keyval: guint): guint;
    function GetUpper(keyval: guint): guint;
    *)
    
    function IsLower(keyval: guint): Boolean;
    function IsUpper(keyval: guint): Boolean;
    function GetUnichar(keyval: guint): gunichar;
    function GetKeyval(aunichar: gunichar): guint; overload;
  public
    property Items[name: UTF8String]: guint read GetKeyval; default;
    property Names[keyval: guint]: UTF8String read GetKeyname;
  end;

var
  Keyvals: DKeyvals = nil;

procedure InitKeyvals;
    
implementation
uses uwrapgnames, uwrapgdknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

const
  GDK_VoidSymbol = $FFFFFF;

// returns GDK_VoidSymbol if the key name is not a valid key
function gdk_keyval_from_name(keyvalname: PGChar): guint; cdecl; external gdklib; 

function gdk_keyval_name(keyval: guint): PGChar; cdecl; external gdklib; // const
procedure gdk_keyval_convert_case(symbol: guint; lower, upper: PWGuint); cdecl; external gdklib;
function gdk_keyval_to_upper(keyval: guint): guint; cdecl; external gdklib;
function gdk_keyval_to_lower(keyval: guint): guint; cdecl; external gdklib;
function gdk_keyval_is_upper(keyval: guint): gboolean; cdecl; external gdklib;
function gdk_keyval_is_lower(keyval: guint): gboolean; cdecl; external gdklib;

function gdk_keyval_to_unicode(keyval: guint): guint32; cdecl; external gdklib; // 0 if no char
function gdk_unicode_to_keyval(wc: guint32): guint; cdecl; external gdklib; // if no symbol: wc|0x01000000

{$endif gtk2q_standalone}

function DKeyvals.GetKeyval(name: UTF8String): guint;
begin
  Result := gdk_keyval_from_name(PChar(PGChar(name)));
  if Result = 0 then
    raise EKeyInvalid.Create(Format('%s is not a valid key', [name]));
end;

function DKeyvals.GetKeyname(keyval: guint): UTF8String;
var
  name: PGChar;
begin
  name := gdk_keyval_name(keyval);
  if not Assigned(name) then
    raise EKeyInvalid.Create(Format('%d is not a valid key', [keyval]));

  Result := PChar(name);
  (* no g_free *)
end;

(*
function DKeyvals.GetLower(keyval: guint): guint;
begin
  Result := gdk_keyval_lower(keyval);
end;

function DKeyvals.GetUpper(keyval: guint): guint;
begin
  Result := gdk_keyval_upper(keyval);
end;
*)

function DKeyvals.IsLower(keyval: guint): Boolean;
begin
  Result := gdk_keyval_is_lower(keyval);
end;

function DKeyvals.IsUpper(keyval: guint): Boolean;
begin
  Result := gdk_keyval_is_upper(keyval);
end;

function DKeyvals.GetUnichar(keyval: guint): gunichar;
begin
  Result := gdk_keyval_to_unicode (keyval);
  if Result = 0 then
    raise EKeyInvalid.Create(Format('%d is not a keyval that has an unicode character equivalent', [keyval]));
end;

function DKeyvals.GetKeyval(aunichar: gunichar): guint;
begin
  Result := gdk_unicode_to_keyval(aunichar);
  (* todo? check weird error condition *)
end;

procedure InitKeyvals;
begin
  (* TODO thread safety *)
  Keyvals := DKeyvals.Create;
end;

initialization

finalization
  if Assigned(Keyvals) then begin
    Keyvals.Free;
    Keyvals := nil;
  end;
  
end.
