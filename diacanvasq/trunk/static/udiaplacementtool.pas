unit udiaplacementtool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaPlacementTool = class(TDiaTool, IDiaPlacementTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
  protected
{    procedure constructWrapped; override;
  published
    constructor Create; override;
}
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: GType; override; (* 0: not *)
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, utyperegistry;

(*$IFDEF gtk2q_standalone*)
function dia_placement_tool_new(typ: GType; firstProp: pgchar): Pointer; cdecl; external diacanvaslib; overload;
function dia_placement_tool_new(typ: GType; firstProp: pgchar; props: array of const): Pointer; cdecl; external diacanvaslib; overload;
function dia_placement_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaPlacementTool }

{procedure TDiaPlacementTool.constructWrapped;
begin
//TODO  setWrapped(PGObject(dia_placement_tool_new));
end;

constructor TDiaPlacementTool.Create;
begin
  inherited Create;
end;
}

class procedure TDiaPlacementTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaPlacementTool', 'diacanvas', TDiaTool, dia_placement_tool_get_type, IDiaTool);
end;

class function TDiaPlacementTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaPlacementTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaPlacementTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 