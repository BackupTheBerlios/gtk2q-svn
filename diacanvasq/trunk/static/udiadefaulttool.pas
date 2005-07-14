unit udiadefaulttool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaDefaultTool = class(TDiaTool, IDiaDefaultTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
  protected
    procedure constructWrapped; override;
  published
    constructor Create;
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: GType; override; (* 0: not *)
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, utyperegistry;

(*$IFDEF gtk2q_standalone*)
function dia_default_tool_new(): Pointer; cdecl; external diacanvaslib;
function dia_default_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaDefaultTool }

procedure TDiaDefaultTool.constructWrapped;
begin
  setWrapped(PGObject(dia_default_tool_new));
end;

constructor TDiaDefaultTool.Create;
begin
  inherited Create;
end;

class procedure TDiaDefaultTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaDefaultTool', 'diacanvas', TDiaTool, dia_default_tool_get_type, IDiaTool);
end;

class function TDiaDefaultTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaDefaultTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaDefaultTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 