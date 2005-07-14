unit ugtktreerowreference;

interface
uses upointermediator, iupointermediator, iugtktreerowreference, iugtktreepath, iug;

type
  TGtkTreeRowReference = class(DPointerMediator, IGtkTreeRowReference, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    function GetPath: IGtkTreePath;
    function Clone: ICloneable;
    function Valid: Boolean;
  end;

implementation
uses uwrapgnames, utyperegistry, ugtktreepath, uwrapgtknames, ugtypes;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PGtkTreeModel = Pointer;
  PGtkTreePath = Pointer;
  PGtkTreeRowReference = Pointer;
  PGtkTreeIter = Pointer;

function gtk_tree_row_reference_new(model:PGtkTreeModel; path:PGtkTreePath):PGtkTreeRowReference; cdecl; external gtklib;
function gtk_tree_row_reference_new_proxy(proxy:PWGObject; model:PGtkTreeModel; path:PGtkTreePath):PGtkTreeRowReference; cdecl; external gtklib;
function gtk_tree_row_reference_get_path(reference:PGtkTreeRowReference):PGtkTreePath; cdecl; external gtklib;
function gtk_tree_row_reference_copy(reference:PGtkTreeRowReference): PGtkTreeRowReference; cdecl; external gtklib; // 2.2
function gtk_tree_row_reference_valid(reference:PGtkTreeRowReference):gboolean; cdecl; external gtklib;
procedure gtk_tree_row_reference_free(reference:PGtkTreeRowReference); cdecl; external gtklib;
{ These two functions are only needed if you created the row reference with a
   proxy anObject  }
procedure gtk_tree_row_reference_inserted(proxy:PWGObject; path:PGtkTreePath); cdecl; external gtklib;
procedure gtk_tree_row_reference_deleted(proxy:PWGObject; path:PGtkTreePath); cdecl; external gtklib;
procedure gtk_tree_row_reference_reordered(proxy:PWGObject; path:PGtkTreePath; iter:PGtkTreeIter; new_order:PWgint); cdecl; external gtklib;

{$endif gtk2q_standalone}


{ TGtkTreeRowReference }

function TGtkTreeRowReference.Clone: ICloneable;
begin
  Result := (*$IFDEF FPC*)TGtkTreeRowReference.(*$ENDIF FPC*)CreateWrapped(gtk_tree_row_reference_copy(GetUnderlying));
end;

constructor TGtkTreeRowReference.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_tree_row_reference_free);
end;

function TGtkTreeRowReference.GetPath: IGtkTreePath;
var
  native: Pointer;
begin
  native := gtk_tree_row_reference_get_path(GetUnderlying);
  //ResultTGtkTreePath.CreateWrapper(native);
  Result := TGtkTreePath.CreateWrapped(native) as IGtkTreePath;
end;

function TGtkTreeRowReference.Valid: Boolean;
begin
  Result := gtk_tree_row_reference_valid(GetUnderlying);
end;

end.
