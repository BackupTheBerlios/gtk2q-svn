unit udiaitemtool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaItemTool = class(TDiaTool, IDiaItemTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
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
function dia_item_tool_new(): Pointer; cdecl; external diacanvaslib;
function dia_item_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaItemTool }

procedure TDiaItemTool.constructWrapped;
begin
  setWrapped(PGObject(dia_item_tool_new));
end;

constructor TDiaItemTool.Create;
begin
  inherited Create;
end;

class procedure TDiaItemTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaItemTool', 'diacanvas', TDiaTool, dia_item_tool_get_type, IDiaTool);
end;

class function TDiaItemTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaItemTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaItemTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 