unit uglade;

interface
uses iuglade, ugtypes, iugobject, ugobject, uutf8stringgobjectclasshash,
uutf8stringigtkwidgethash, iugtk;

type
  TWidgetNameToClassHash = TUTF8StringGObjectClassHash;
  TWidgetNameToInterfaceHash = TUTF8StringIGtkWidgetHash;
  
  TGladeWidgets = class(TGObject, IGladeWidgets, IGObject, IInterface)
  private
    FwidgetnameToClassHash: TWidgetNameToClassHash;
    FwidgetnameToInterfaceHash: TWidgetNameToInterfaceHash;
  //protected
  //  procedure constructWrapped; override;
  public
    class function CreateFromFile(filename: string): IGladeWidgets;
    //class function CreateFromBuffer(others: ba): IGlade;
    //CreateFromStream FIXME

    procedure RegisterClass(widgetName: string; myclass: TGObjectClass);

    function GetWidget(widgetName: string): IGtkWidget;

    function GetWidgetNames: TUTF8StringArray;

  public
    property Names: TUTF8StringArray read GetWidgetNames;

    // autoconnect ?
    // my extensions for any objects ?
  end;

implementation
uses uwrapgladenames, uwrapgnames, uwrapgtknames, utyperegistry;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
type
  TGladeXMLCustomWidgetHandler = function(xml:PWGladeXML; funcname: PGChar; name: PGChar; string1,string2: PGChar; int1,int2: gint; userdata: Pointer): PWGtkWidget; cdecl;


function glade_xml_get_type: TGType; cdecl; external gladelib;
function glade_xml_construct(xml: PWGladeXML; const fname, root, domain: PChar): gboolean; cdecl; external gladelib;
//glade_xml_signal_connect
//glade_xml_signal_connect_data
procedure glade_xml_signal_autoconnect(xml: PWGladeXML); cdecl; external gladelib;
(*procedure glade_xml_signal_autoconnect_full(xml: PWGladeXML; cb; userdata: gpointer); cdecl; external gladelib;*)
//signal_connect_full ?
function glade_xml_get_widget(xml: PWGladeXML; const name: PGChar): PWGtkWidget; cdecl; external gladelib;
function glade_xml_get_widget_prefix(xml: PWGladeXML; const prefix: PGChar): PWGList; cdecl; external gladelib;
function glade_xml_relative_file(xml: PWGladeXML; filename: PGChar): PGChar; cdecl; external gladelib;
function glade_get_widget_name(widget: PWGtkWidget): PGChar; cdecl; external gladelib; // const

procedure glade_set_custom_handler(handler: TGladeXMLCustomWidgetHandler; userdata: gpointer); cdecl; external gladelib;
//glade_get_widget_tree
//glade_set_custom_handler !!

function glade_xml_new(const fname, root, domain: PChar): PWGladeXML; cdecl; external gladelib;
function glade_xml_new_from_buffer(buffer: Pointer; size: Integer; const root: PChar; const domain: PChar): PWGladeXML; cdecl; external gladelib;

//typedef GtkWidget *(* GladeXMLCustomWidgetHandler) (GladeXML *xml, gchar *func_name, gchar *name, gchar *string1, gchar *string2, gint int1, gint int2, gpointer user_data);

{$endif gtk2q_standalone}

(* TGladeWidgets *)

class function TGladeWidgets.CreateFromFile(filename: string): IGladeWidgets;
begin
  Result := CreateWrapped(glade_xml_new(PChar(filename), PChar('')(*root*), PChar('')(*root*))) as IGladeWidgets;
end;

function TGladeWidgets.GetWidget(widgetName: string): IGtkWidget;
var
  widget: PWGtkWidget;
  someclass: TGObjectClass;
begin
  if FwidgetnameToInterfaceHash.Exists(widgetName) then begin
    Result := FwidgetnameToInterfaceHash.Retrieve(widgetName);
    Exit;
  end;
  
  // not cached yet. load and cache.

  widget := glade_xml_get_widget(Fobject, PGChar(PChar(widgetName)));
  g_object_ref(PWGObject(widget));
  someclass := FwidgetnameToClassHash[widgetName];
  
  if not Assigned(someclass) then
    Result := WrapGObject(widget) as IGtkWidget
  else
    Result := someclass.CreateWrapped(widget) as IGtkWidget;
    
  FwidgetnameToInterfaceHash[widgetName] := Result;
end;

function TGladeWidgets.GetWidgetNames: TUTF8StringArray;
var
  aglist: PWGList;
  xaglist: PWGList;
  name: PGChar;
  i: Integer;
begin
  SetLength(Result, 0);
  aglist := glade_xml_get_widget_prefix(Fobject, PGChar(PChar('')));
  if not Assigned(aglist) then Exit;
  SetLength(Result, g_list_length(aglist));
  
  xaglist := aglist;
  i := 0;
  while Assigned(xaglist) do begin
    name := glade_get_widget_name(PWGtkWidget(xaglist^.data));
    
    Result[i] := PChar(PGChar(name));
    
    // dont not free name since const
    Inc(i);
    xaglist := g_list_next(xaglist);
  end;
  g_list_free(aglist);
end;

procedure TGladeWidgets.RegisterClass(widgetName: string;
  myclass: TGObjectClass);
begin
  if (FwidgetnameToClassHash.Exists(widgetName)) and (FwidgetnameToInterfaceHash.Exists(widgetName)) then
    raise EGladeFraud.Create('You cannot change the class type after you instantiated it');

  FwidgetnameToClassHash[widgetName] := myclass;    
end;

end.
