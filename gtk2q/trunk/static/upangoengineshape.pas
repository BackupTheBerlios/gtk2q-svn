unit upangoengineshape;

interface
uses ugobject, iugobject, ugtypes, iupango;

type
  TPangoEngineShape = class(TGObject, IPangoEngineShape, IGObject, IInvokable, IInterface)
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)

  end;
  
implementation
uses uwrappangonames, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_engine_shape_get_type: TGType; cdecl; external pangolib;
{$endif gtk2q_standalone}

class procedure TPangoEngineShape.TypeRegister; (* flat *)
begin
  inherited TypeRegister;
  DTypeRegister('TPangoEngineShape', 'pango', TPangoEngineShape, pango_engine_shape_get_type, IPangoEngineShape);
end;

class function TPangoEngineShape.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoEngineShape.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
