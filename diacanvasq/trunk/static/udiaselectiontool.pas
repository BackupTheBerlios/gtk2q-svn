unit udiaselectiontool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaSelectionTool = class(TDiaTool, IDiaSelectionTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
  protected
    procedure constructWrapped; override;
  published
    constructor Create;override;
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: GType; override; (* 0: not *)
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, utyperegistry;

(*$IFDEF gtk2q_standalone*)
function dia_selection_tool_new(): Pointer; cdecl; external diacanvaslib;
function dia_selection_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaSelectionTool }

procedure TDiaSelectionTool.constructWrapped;
begin
  setWrapped(PGObject(dia_selection_tool_new));
end;

constructor TDiaSelectionTool.Create;
begin
  inherited Create;
end;

class procedure TDiaSelectionTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaSelectionTool', 'diacanvas', TDiaTool, dia_selection_tool_get_type, IDiaTool);
end;

class function TDiaSelectionTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaSelectionTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaSelectionTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 