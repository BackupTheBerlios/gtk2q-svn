unit udiastacktool;

interface
uses iudiacanvas, udiatool, iugtk, iug, iugobject, ugtypes;

(* TODO derivable *)

(*$M+*) (* RTTI *)

type
  TDiaStackTool = class(TDiaTool, IDiaStackTool, IDiaTool, IGObject,IGUserData,IInvokable,IInterface)
  protected
    procedure constructWrapped; override;
  published
    constructor Create; override;
    procedure Push(tool: IDiaTool);
    procedure Pop;
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: GType; override; (* 0: not *)
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, utyperegistry;

(*$IFDEF gtk2q_standalone*)
procedure dia_stack_tool_pop(stack_tool: Pointer); cdecl; external diacanvaslib;
procedure dia_stack_tool_push(stack_tool: Pointer;tool: Pointer); cdecl; external diacanvaslib;
function dia_stack_tool_new(): Pointer; cdecl; external diacanvaslib;
function dia_stack_tool_get_type: GType; cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaStackTool }

procedure TDiaStackTool.constructWrapped;
begin
  setWrapped(PGObject(dia_stack_tool_new));
end;

constructor TDiaStackTool.Create;
begin
  inherited Create;
end;

procedure TDiaStackTool.Pop;
begin
  dia_stack_tool_pop(PWDiaStackTool(Fobject));
end;

procedure TDiaStackTool.Push(tool: IDiaTool);
begin
  assert(Assigned(tool));
  dia_stack_tool_push(PWDiaStackTool(Fobject), PWDiaStackTool(tool.GetUnderlying));
end;

class procedure TDiaStackTool.TypeRegister;
begin
  inherited;
  DTypeRegister('TDiaStackTool', 'diacanvas', TDiaTool, dia_stack_tool_get_type, IDiaTool);
end;

class function TDiaStackTool.OverrideGType: GType; (* 0: not *)
var
  gtypeinfo: PGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if xclassname <> 'TDiaStackTool' then begin (* derived *)
    raise EClassFinalError.Create('Class TDiaStackTool cannot be derived from!');
    assert(False); (* TODO *)
  end;
end;

end.
 