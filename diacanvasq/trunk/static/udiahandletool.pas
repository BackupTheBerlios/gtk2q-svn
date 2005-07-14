unit udiahandletool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaHandleTool = class(TDiaTool, IDiaHandleTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
  protected
    procedure constructWrapped; override;
  published
    constructor Create; override;
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: GType; override; (* 0: not *)
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, utyperegistry;

(*$IFDEF gtk2q_standalone*)
function dia_handle_tool_new(): Pointer; cdecl; external diacanvaslib;
function dia_handle_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaHandleTool }

procedure TDiaHandleTool.constructWrapped;
begin
  setWrapped(PGObject(dia_handle_tool_new));
end;

constructor TDiaHandleTool.Create;
begin
  inherited Create;
end;

class procedure TDiaHandleTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaHandleTool', 'diacanvas', TDiaTool, dia_handle_tool_get_type, IDiaTool);
end;

class function TDiaHandleTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaHandleTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaHandleTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 