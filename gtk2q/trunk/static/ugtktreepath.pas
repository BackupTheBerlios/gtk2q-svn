unit ugtktreepath;

interface
uses iupointermediator, upointermediator, iugtktreepath, iug, ugtypes;

(* TODO cache those for some time since they seem to be quite tree independent (?) *)
(* (DInterfaceCache) *)
(* TODO copy on write first *)

type
  TGtkTreePath = class(TPointerMediator, IGtkTreePath, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    (* TODO that class functions too ? *)
    class function CreateFromIndices(ints: array of Integer): IGtkTreePath;
    class function CreateFromString(s: UTF8String): IGtkTreePath;
    function IsDescendant(ancestor: IGtkTreePath): Boolean;
    function IsAncestor(descendant: IGtkTreePath): Boolean;
    function PrependIndex(index: Integer): IGtkTreePath;
    function AppendIndex(index: Integer): IGtkTreePath;
    function GetDepth: Integer;
    function Compare(b: IGtkTreePath): Integer;
    function Clone: ICloneable;
    function ToString: UTF8String;
    function GetIndices: TIntegerArray;
    function Up: IGtkTreePath; (* returns another or nil *)
    function Prev: IGtkTreePath; (* returns another or nil *)
    function Down: IGtkTreePath; (* returns another *)
    function Next: IGtkTreePath; (* returns another *)
  end;

implementation
uses uwrapgnames, uwrapgtknames, sysutils, uvarrectools;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
type
  PGtkTreePath = Pointer;
  
function gtk_tree_path_new:PGtkTreePath; cdecl; external gtklib;
function gtk_tree_path_new_from_string(path:Pgchar):PGtkTreePath; cdecl; external gtklib;
function gtk_tree_path_new_from_indices(firstindex: gint; others: array of const): PGtkTreePath; cdecl; external gtklib;
function gtk_tree_path_to_string(path:PGtkTreePath):Pgchar; cdecl; external gtklib;

function gtk_tree_path_new_first:PGtkTreePath; cdecl; external gtklib;
procedure gtk_tree_path_append_index(path:PGtkTreePath; index:gint); cdecl; external gtklib;
procedure gtk_tree_path_prepend_index(path:PGtkTreePath; index:gint); cdecl; external gtklib;
function gtk_tree_path_get_depth(path:PGtkTreePath):gint; cdecl; external gtklib;
function gtk_tree_path_get_indices(path:PGtkTreePath):PWgint; cdecl; external gtklib;
procedure gtk_tree_path_free(path:PGtkTreePath); cdecl; external gtklib;
function gtk_tree_path_copy(path:PGtkTreePath):PGtkTreePath; cdecl; external gtklib;
function gtk_tree_path_get_type:TGType; cdecl; external gtklib;
function gtk_tree_path_compare(a:PGtkTreePath; b:PGtkTreePath):gint; cdecl; external gtklib;
procedure gtk_tree_path_next(path:PGtkTreePath); cdecl; external gtklib;
function gtk_tree_path_prev(path:PGtkTreePath):gboolean; cdecl; external gtklib;
function gtk_tree_path_up(path:PGtkTreePath):gboolean; cdecl; external gtklib;
procedure gtk_tree_path_down(path:PGtkTreePath); cdecl; external gtklib;
function gtk_tree_path_is_ancestor(path:PGtkTreePath; descendant:PGtkTreePath):gboolean; cdecl; external gtklib;
function gtk_tree_path_is_descendant(path:PGtkTreePath; ancestor:PGtkTreePath):gboolean; cdecl; external gtklib;
{$endif gtk2q_standalone}


{ TGtkIconInfo }

function FindOrCreateTreePath(ints: array of Integer): IGtkTreePath;
var
  (*xints: array of Integer;*)
  vra: TVarrecArray;
  (*i: Integer;*)
begin
  assert(Length(ints) > 0);
  FillVarrecArrayFromIntArray(ints, vra, 1);
  SetLength(vra,Length(vra)+1);
  vra[High(vra)].VType := vtInteger;
  vra[High(vra)].VInteger := -1;

  try
    Result := TGtkTreePath.CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [-1])) as IGtkTreePath;
  finally
    ClearVarrecArray(vra);
  end;
  (*
  case Length(ints) of
  1: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [-1])) as IGtkTreePath;
  2: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], -1])) as IGtkTreePath;
  3: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], -1])) as IGtkTreePath;
  4: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3], -1])) as IGtkTreePath;
  5: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], -1])) as IGtkTreePath;
  6: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], ints[5], -1])) as IGtkTreePath;
  7: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], ints[5], ints[6], -1])) as IGtkTreePath;
  8: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], ints[5], ints[6], ints[7], -1])) as IGtkTreePath;
  9: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], ints[5], ints[6], ints[7], ints[8], -1])) as IGtkTreePath;
  10: Result := CreateWrapped(gtk_tree_path_new_from_indices(ints[0], [ints[1], ints[2], ints[3],
    ints[4], ints[5], ints[6], ints[7], ints[8], ints[9], -1])) as IGtkTreePath;
  else raise Exception.Create('more than 11 levels not implemented yet'); FIXME
  end;
  *)
end;

function TGtkTreePath.AppendIndex(index: Integer): IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath); (* todo cache *)
  gtk_tree_path_append_index((Result as IPointerMediator).GetUnderlying, index);
end;

function TGtkTreePath.Compare(b: IGtkTreePath): Integer;
begin
  Result := gtk_tree_path_compare(GetUnderlying, b.GetUnderlying);
end;

function TGtkTreePath.Clone: ICloneable;
var
  nptr: Pointer;
begin
  nptr := gtk_tree_path_copy(GetUnderlying);
  Result := (*$IFDEF FPC*)TGtkTreePath.(*$ENDIF FPC*)CreateWrapped(nptr) as ICloneable;
end;

class function TGtkTreePath.CreateFromIndices(ints: array of Integer): IGtkTreePath;
begin
  Result := FindOrCreateTreePath(ints);
end;

class function TGtkTreePath.CreateFromString(s: UTF8String): IGtkTreePath;
begin
  (* TODO scan caches? *)
  Result := CreateWrapped(gtk_tree_path_new_from_string(PGChar(PChar(s)))) as IGtkTreePath;
end;

constructor TGtkTreePath.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_tree_path_free);
end;

function TGtkTreePath.Down: IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath); (* TODO cache *)
  gtk_tree_path_down((Result as IPointerMediator).GetUnderlying);
end;

function TGtkTreePath.GetDepth: Integer;
begin
  Result := gtk_tree_path_get_depth(GetUnderlying);
end;

function TGtkTreePath.GetIndices: TIntegerArray;
var
  p: PWGint;
  i: Integer;
begin
  p := gtk_tree_path_get_indices(GetUnderlying);
  SetLength(Result, GetDepth);
  for i := 1 to Length(Result) do begin
    Result[High(Result)] := p^;
    Inc(p);
  end;
  // should not be freed
end;

function TGtkTreePath.IsAncestor(descendant: IGtkTreePath): Boolean;
begin
  Result := gtk_tree_path_is_ancestor(GetUnderlying, descendant.GetUnderlying);
end;

function TGtkTreePath.IsDescendant(ancestor: IGtkTreePath): Boolean;
begin
  Result := gtk_tree_path_is_descendant(GetUnderlying, ancestor.GetUnderlying);
end;

function TGtkTreePath.Next: IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath); (* todo cache *)
  gtk_tree_path_next((Result as IPointerMediator).GetUnderlying);
end;

function TGtkTreePath.PrependIndex(index: Integer): IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath);
  gtk_tree_path_prepend_index((Result as IPointerMediator).GetUnderlying, index);
end;

function TGtkTreePath.Prev: IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath); (* todo cache *)
  if not gtk_tree_path_prev((Result as IPointerMediator).GetUnderlying) then
    Result := nil;
end;

function TGtkTreePath.ToString: UTF8String;
var
  g: PGChar;
begin
  g := gtk_tree_path_to_string(GetUnderlying);
  Result := PChar(g); (* utf *)
  g_free(g);
end;

function TGtkTreePath.Up: IGtkTreePath;
begin
  Result := (Clone as IGtkTreePath); (* todo cache *)
  if not gtk_tree_path_up((Result as IPointerMediator).GetUnderlying) then
    Result := nil;
end;


end.
