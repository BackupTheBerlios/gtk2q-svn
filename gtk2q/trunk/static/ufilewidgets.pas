unit ufilewidgets;
(* this is probably not required at all. I skip it for now. *)

interface
uses ugtkfilechooserwidget, iufilewidgets;

type
  (* note that these remove some interfaces that arent needed to be exposed *)
  TGtkFileChooserSaveWidget = class(TGtkFileChooserWidget, IGtkFileChooserWidget, IGtkWidget, IGtkObject, IGObject, IInterface)
  public
    class procedure TypeRegister;
  protected  
    procedure constructWrapped; override;
  end;

  TGtkFileChooserOpenWidget = class(TGtkFileChooserWidget, IGtkFileChooserWidget, IGtkWidget, IGtkObject, IGObject, IInterface)
  public
    class procedure TypeRegister;
  protected  
    procedure constructWrapped; override;
  end;
  
  TGtkFileChooserSelectFolderWidget = class(TGtkFileChooserWidget, IGtkFileChooserWidget, IGtkWidget, IGtkObject, IGObject, IInterface)
  public
    class procedure TypeRegister;
  protected  
    procedure constructWrapped; override;
  end;
  
  TGtkFileChooserCreateFolderWidget = class(TGtkFileChooserWidget, IGtkFileChooserWidget, IGtkWidget, IGtkObject, IGObject, IInterface)
  public
    class procedure TypeRegister;
  protected  
    procedure constructWrapped; override;
  end;

(* TGtkFileChooserWidgetCreateWrapped that chooses the correct one according to the action *)
function TGtkFileChooserWidgetCreateWrapped(ptr: PGObject): IGtkFileChooserWidget;

implementation
uses ugtypes, uwrapgnames, uwrapgtknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
function gtk_file_chooser_get_action(chooser: PGtkFileChooser); cdecl; external gtklib;
function gtk_file_chooser_get_type(): GType; cdecl; external gtklib;
{$endif gtk2q_standalone}

(* XXTGtkFileChooserOpenWidget *)

procedure TGtkFileChooserOpenWidget.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_widget_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserOpenWidget.TypeRegister;
begin
  TGtkFileChooserWidget.TypeRegister;
  DTypeRegister('TGtkFileChooserOpenWidget', 'gtk', TGtkFileChooserOpenWidget, gtk_file_chooser_widget_get_type());
end;

(* TGtkFileChooserSaveWidget *)

procedure TGtkFileChooserSaveWidget.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_widget_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserSaveWidget.TypeRegister;
begin
  TGtkFileChooserWidget.TypeRegister;
  DTypeRegister('TGtkFileChooserSaveWidget', 'gtk', TGtkFileChooserSaveWidget, gtk_file_chooser_widget_get_type());
end;

(* TGtkFileChooserSelectFolderWidget *)

procedure TGtkFileChooserSelectFolderWidget.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_widget_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserSelectFolderWidget.TypeRegister;
begin
  TGtkFileChooserWidget.TypeRegister;
  DTypeRegister('TGtkFileChooserSelectFolderWidget', 'gtk', TGtkFileChooserSelectFolderWidget, gtk_file_chooser_widget_get_type());
end;

(* TGtkFileChooserCreateFolderWidget *)

procedure TGtkFileChooserCreateFolderWidget.constructWrapped;
begin
  setWrapped(PGObject(gtk_file_chooser_dialog_new(GTK_FILE_CHOOSER_ACTION_OPEN)));
end;
    
class procedure TGtkFileChooserCreateFolderWidget.TypeRegister;
begin
  TGtkFileChooserWidget.TypeRegister;
  DTypeRegister('TGtkFileChooserCreateFolderWidget', 'gtk', TGtkFileChooserCreateFolderWidget, gtk_file_chooser_widget_get_type());
end;


function TGtkFileChooserWidgetCreateWrapped(ptr: PGObject): IGtkFileChooserWidget;
begin
  if not Assigned(ptr) then begin
    Result := nil;
    Exit;
  end;
  
  case gtk_file_chooser_get_action(PGtkFileChooser(ptr)) of
  GTK_FILE_CHOOSER_ACTION_OPEN: Result := TGtkFileChooserOpenWidget.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_SAVE: Result := TGtkFileChooserSaveWidget.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER: Result := TGtkFileChooserSelectFolderWidget.CreateWrapped(ptr);
  GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER: Result := TGtkFileChooserCreateFolderWidget.CreateWrapped(ptr);
  else Result := TGtkFileChooserWidget.CreateWrapped(ptr);
  end;
end;

end.

