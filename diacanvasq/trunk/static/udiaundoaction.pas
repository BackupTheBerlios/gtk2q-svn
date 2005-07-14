unit udiaundoaction;

(* TODO callbacks? *)

interface
uses iudiacanvas, iupointermediator, upointermediator, iudiaundoaction;

type
  TDiaUndoAction = class(DPointerMediator, IDiaUndoAction, IPointerMediator, IInvokable, IInterface)
  published
    constructor CreateWrapped(ptr: Pointer);
    procedure Undo;
    procedure Redo;
  end;

implementation
uses uwrapdiacanvasnames;

(*$IFDEF gtk2q_standalone*)
procedure dia_undo_action_undo(ptr: Pointer{PWDiaUndoAction}); cdecl; external diacanvaslib;
procedure dia_undo_action_redo(ptr: Pointer{PWDiaUndoAction}); cdecl; external diacanvaslib;
procedure dia_undo_action_destroy(ptr: Pointer{PWDiaUndoAction}); cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaUndoAction }

constructor TDiaUndoAction.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @dia_undo_action_destroy);
end;

procedure TDiaUndoAction.Redo;
begin
  dia_undo_action_redo(PWDiaUndoAction(fPtr));
end;

procedure TDiaUndoAction.Undo;
begin
  dia_undo_action_undo(PWDiaUndoAction(fPtr));
end;

end.
 