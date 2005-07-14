unit ugtktextchildanchor;

interface
uses ugobject, iugobject, iugtk; //textchildanchor;

type
  TGtkTextChildAnchor = class(TGObject, IGtkTextChildAnchor, IGObject, IInvokable, IInterface)
  public
  function GetWidgets: TIGtkWidgetArray;
  function GetDeleted: Boolean;
  end;

implementation
uses uwrapgnames, utyperegistry, uwrapgtknames, ugtypes;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PGtkWidget = Pointer;
  PGtkTextChildAnchor = Pointer;

function gtk_text_child_anchor_get_widgets(anchor: PGtkTextChildAnchor): PWGList; cdecl; external gtklib;
function gtk_text_child_anchor_get_deleted(anchor: PGtkTextChildAnchor): gboolean; cdecl; external gtklib;

{$endif gtk2q_standalone}

function TGtkTextChildAnchor.GetWidgets: TIGtkWidgetArray;
var
  aglist: PWGList;
  caglist: PWGList;
  itemraw: PGtkWidget;
  i: Integer;
begin
  aglist := gtk_text_child_anchor_get_widgets(GetUnderlying);
  SetLength(Result, 0);
  if not Assigned(aglist) then Exit;

  SetLength(Result, g_list_length(aglist));  
  caglist := aglist;
  i := 0;
  while Assigned(caglist) do begin
    itemraw := PGtkWidget(caglist^.data);
    
    g_object_ref(itemraw); // FIXME test
    Result[i] := WrapGObject(itemraw) as IGtkWidget;
    
    caglist := g_list_next(caglist);
    Inc(i);
  end;
  g_list_free(aglist);
end;

function TGtkTextChildAnchor.GetDeleted: Boolean;
begin
  Result := gtk_text_child_anchor_get_deleted(GetUnderlying);
end;


end.
