unit uwrapatknames;

(* unused yet *)

interface
uses ugtypes, uwrapgnames;

type
  TAtkStateType = Int64; (* should actually be unsigned *)
  
type
  PAtkStateSet = PGObject;

const
(*$IFDEF WIN32*)
  atklib = 'libatk-1.0-0.dll';
(*$ELSE*)
  atklib = 'libatk-1.0.so';
(*$ENDIF WIN32*)

procedure atkStateSetToNative(flags: TAtkStateSet; native: PAtkStateSet);
function atkStateSetFromNative(native: PAtkStateSet): TAtkStateSet;
        
implementation

{$ifdef gtk2q_standalone}
function atk_state_set_new(): PAtkStateSet; cdecl; external atklib;
function atk_state_set_is_empty(seta: PAtkStateSet): gboolean; cdecl; external atklib;
procedure atk_state_set_add_state(seta: PGtkStateSet; ty: TAtkStateType); cdecl; external atklib;
procedure atk_state_set_clear_states(seta: PGtkStateSet); cdecl; external atklib;
function atk_state_set_contains_state(seta: PGtkStateSet): gboolean; cdecl; external atklib;
procedure atk_state_set_remove_state(seta: PGtkStateSet; ty: TAtkStateType); cdecl; external atklib;
{$endif gtk2q_standalone}

procedure atkStateSetToNative(flags: TAtkStateSet; native: PAtkStateSet);
var
  flag: TAtkStateType;
begin
  atk_state_set_clear_states(native);
  for flag in flags do begin
    atk_state_set_add_state(native, TAtkStateType(flag));
  end;
end;

procedure atkStateSetFromNative(native: PAtkStateSet): TAtkStateSet;
var
  flag: TAtkStateType;
begin
  Result := [];
  if atk_state_set_is_empty(native) then Exit;
  
  for flag in TAtkStateType do
    if atk_state_set_contains_state(native, TAtkStateType(flag)) then
      Result := Result + [flag];
end;

end.
