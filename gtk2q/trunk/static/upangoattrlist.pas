unit upangoattrlist;

interface
uses upointermediator, iupointermediator, iupango, iug;

{$M+}

type
  TPangoAttrList = class(TPointerMediator, IPangoAttrList, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  published
    function Clone: ICloneable;
    procedure Insert(attribute: IPangoAttribute);
    procedure InsertBefore(attribute: IPangoAttribute);
    procedure Change(attribute: IPangoAttribute);
    // TODO function Splice(
    // TODO Filter
    // TODO get iterator
  end;
  
implementation
uses uwrapgnames, uwrappangonames, ugtypes;

function pango_attr_list_copy(attrlist: PWPangoAttrList): PWPangoAttrList; cdecl; external pangolib;
function pango_attr_list_new: PWPangoAttrList; cdecl; external pangolib;
procedure pango_attr_list_unref(attrlist: PWPangoAttrList); cdecl; external pangolib;
procedure pango_attr_list_insert(attrlist: PWPangoAttrList; attr: PWPangoAttribute); cdecl; external pangolib;
procedure pango_attr_list_insert_before(attrlist: PWPangoAttrList; attr: PWPangoAttribute); cdecl; external pangolib;
procedure pango_attr_list_change(attrlist: PWPangoAttrList; attr: PWPangoAttribute); cdecl; external pangolib;
procedure pango_attr_list_splice(attrlist, other: PWPangoAttrList; pos: gint; len1: gint); cdecl; external pangolib;

constructor TPangoAttrList.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_attr_list_unref);
end;

function TPangoAttrList.Clone: ICloneable;
begin
  Result := TPangoAttrList.CreateWrapped(pango_attr_list_copy(GetUnderlying)) as ICloneable;
end;

procedure TPangoAttrList.Insert(attribute: IPangoAttribute);
begin
  assert(Assigned(attribute));
  pango_attr_list_insert(GetUnderlying, attribute.GetUnderlying);
end;
  
procedure TPangoAttrList.InsertBefore(attribute: IPangoAttribute);
begin
  assert(Assigned(attribute));
  pango_attr_list_insert_before(GetUnderlying, attribute.GetUnderlying);
end;

procedure TPangoAttrList.Change(attribute: IPangoAttribute);
begin
  assert(Assigned(attribute));
  pango_attr_list_change(GetUnderlying, attribute.GetUnderlying);
end;

end.
