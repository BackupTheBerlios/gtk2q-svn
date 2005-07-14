unit udialogs;

interface

procedure ShowMessage(const s: UTF8String);

implementation
uses iug, iuatk, iugtk, ugtkmessagedialog, uwrapgtknames, iugobject, uwrapgnames, ugtypes, ugtktypes;

type
  TGtkShowMessageDialog = class(TGtkMessageDialog,IGtkMessageDialog,IGtkDialog,IGtkWindow,IGtkBin,IGtkContainer,IGtkWidget,IGtkObject,IGObject,IDisposable,IGUserData,IInvokable,IInterface,IAtkImplementorIface)
  published
    constructor Create(const message: UTF8String); reintroduce;

  end;

(*
function gtk_message_dialog_new_with_markup(parent: Pointer;flags: WGtkDialogFlags;type1: WGtkMessageType;buttons: WGtkButtonsType;const message_format: PGChar;additional: array of const): Pointer; cdecl; external gtklib;
procedure gtk_message_dialog_set_markup(message_dialog: Pointer;const str: PGChar); cdecl; external gtklib;
*)
{$IFDEF gtk2q_standalone}
function gtk_message_dialog_new(parent: Pointer;flags: WGtkDialogFlags;type1: WGtkMessageType;buttons: WGtkButtonsType;const message_format: PGChar;additional: array of const): Pointer; cdecl; external gtklib;
{$ENDIF gtk2q_standalone}

procedure ShowMessage(const s: UTF8String);
var
  dlg: IGtkMessageDialog;
begin
  dlg := TGtkShowMessageDialog.Create(s);
  dlg.Run;
  (dlg as IDisposable).Dispose;
end;

{ TGtkShowMessageDialog }

{ TGtkShowMessageDialog }

constructor TGtkShowMessageDialog.Create(const message: UTF8String);
begin
  CreateWrapped(PWGObject(gtk_message_dialog_new(nil{parent}, WCastSetType([dfModal, dfDestroyWithParent]),
  WGtkMessageType(gmInfo), WGtkButtonsType(buClose),
  PGChar(PChar('test %s')), [PGChar(PChar(message))])));
end;

end.
