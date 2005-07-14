unit ufiledialogs;

(* this is probably not required at all. I skip it for now. *)

interface
uses ugtkfilechooserdialog, iufiledialogs, iugtk, iugobject;

type
  TGtkFileChooserSaveDialog = class(TGtkFileChooserDialog, IGtkFileChooserSaveDialog, IGtkFileChooserDialog, IGtkDialog, 
    IGtkWindow, IGtkWidget, IGtkObject, IGObject, IInterface
  )
  public
    class function Create: IGtkFileChooserSaveDialog;
    class procedure TypeRegister;
  protected
    procedure constructWrapped; override;
  end;

  TGtkFileChooserOpenDialog = class(TGtkFileChooserDialog, IGtkFileChooserOpenDialog, IGtkFileChooserDialog, IGtkDialog, 
    IGtkWindow, IGtkWidget, IGtkObject, IGObject, IInterface
  )
  public
    class function Create: IGtkFileChooserOpenDialog;
    class procedure TypeRegister;
  protected
    procedure constructWrapped; override;
  end;
  
  TGtkFileChooserSelectFolderDialog = class(TGtkFileChooserDialog, IGtkFileChooserSelectFolderDialog, 
    IGtkFileChooserDialog, IGtkDialog, IGtkWindow, 
    IGtkWidget, IGtkObject, IGObject, IInterface
  )
  public
    class function Create: IGtkFileChooserSelectFolderDialog;
    class procedure TypeRegister;
  protected
    procedure constructWrapped; override;
  end;
  
  TGtkFileChooserCreateFolderDialog = class(TGtkFileChooserDialog, IGtkFileChooserCreateFolderDialog,
    IGtkFileChooserDialog, IGtkDialog, IGtkWindow, 
    IGtkWidget, IGtkObject, IGObject, IInterface
  )
  public
    class function Create: IGtkFileChooserCreateFolderDialog;
    class procedure TypeRegister;
  protected
    procedure constructWrapped; override;
  end;

(* TGtkFileChooserDialogCreateWrapped that chooses the correct one according to the action *)
function TGtkFileChooserDialogCreateWrapped(ptr: PGObject): IGtkFileChooserDialog;

implementation
uses ugtypes, uwrapgnames, uwrapgtknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
function gtk_file_chooser_get_action(chooser: PGtkFileChooser); cdecl; external gtklib;
function gtk_file_chooser_dialog_get_type(): GType; cdecl; external gtklib;
{$endif gtk2q_standalone}

(* TGtkFileChooserOpenDialog *)

procedure TGtkFileChooserOpenDialog.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_dialog_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserOpenDialog.TypeRegister;
begin
  TGtkFileChooserDialog.TypeRegister;
  DTypeRegister('TGtkFileChooserOpenDialog', 'gtk', TGtkFileChooserOpenDialog, gtk_file_chooser_dialog_get_type());
end;

(* TGtkFileChooserSaveDialog *)

procedure TGtkFileChooserSaveDialog.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_dialog_new(GTK_FILE_CHOOSER_ACTION_SAVE)));
end;
    
class procedure TGtkFileChooserSaveDialog.TypeRegister;
begin
  TGtkFileChooserDialog.TypeRegister;
  DTypeRegister('TGtkFileChooserSaveDialog', 'gtk', TGtkFileChooserSaveDialog, gtk_file_chooser_dialog_get_type());
end;

(* TGtkFileChooserSelectFolderDialog *)

procedure TGtkFileChooserSelectFolderDialog.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_dialog_new(GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER)));
end;
    
class procedure TGtkFileChooserSelectFolderDialog.TypeRegister;
begin
  TGtkFileChooserDialog.TypeRegister;
  DTypeRegister('TGtkFileChooserSelectFolderDialog', 'gtk', TGtkFileChooserSelectFolderDialog, gtk_file_chooser_dialog_get_type());
end;


(* TGtkFileChooserCreateFolderDialog *)

procedure TGtkFileChooserCreateFolderDialog.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_dialog_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserCreateFolderDialog.TypeRegister;
begin
  TGtkFileChooserDialog.TypeRegister;
  DTypeRegister('TGtkFileChooserCreateFolderDialog', 'gtk', TGtkFileChooserCreateFolderDialog, gtk_file_chooser_dialog_get_type());
end;


function TGtkFileChooserDialogCreateWrapped(ptr: PGObject): IGtkFileChooserDialog;
begin
  if not Assigned(ptr) then begin
    Result := nil;
    Exit;
  end;
  
  case gtk_file_chooser_get_action(PGtkFileChooser(ptr)) of
  GTK_FILE_CHOOSER_ACTION_OPEN: Result := TGtkFileChooserOpenDialog.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_SAVE: Result := TGtkFileChooserSaveDialog.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER: Result := TGtkFileChooserSelectFolderDialog.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER: Result := TGtkFileChooserCreateFolderDialog.CreateWrapped(ptr);
  else Result := TGtkFileChooserDialog.CreateWrapped(ptr);
  end;
end;

end.

