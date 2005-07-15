unit ugtkiconinfo;

interface
uses iupointermediator, upointermediator, iugtkiconinfo, iugdk, ugdktypes, iug;

type
  TGtkIconInfo = class(TPointerMediator, IGtkIconInfo, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    function GetDisplayName: string;
    procedure SetRawCoordinates(raw_coordinates: Boolean);
    //procedure GtkIconInfoFree;
    function GetBuiltinPixbuf: IGdkPixbuf;
    function LoadIcon: IGdkPixbuf;
    function GetFilename: String;
    function GetEmbeddedRect(out rectangle: TGdkRectangle): Boolean;
    function Clone: ICloneable;
    function GetBaseSize: Integer;

    property BaseSize: Integer read GetBaseSize;
    property Filename: string read GetFilename;
    property BuiltinPixbuf: IGdkPixbuf read GetBuiltinPixbuf;
  end;

implementation
uses uwrapgnames, utyperegistry, ugtypes, ugobject, uwrapgtknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PWGtkIconInfo = Pointer;
  PWGdkPixbuf = Pointer;
  WGdkRectangle = TGdkRectangle;
  PWGdkRectangle = ^WGdkRectangle;
  PWGdkPoint = Pointer;
  PWPGdkPoint = ^PWGdkPoint;


function gtk_icon_info_copy(icon_info:PWGtkIconInfo):PWGtkIconInfo;cdecl;external gtklib name 'gtk_icon_info_copy';
procedure gtk_icon_info_free(icon_info:PWGtkIconInfo);cdecl;external gtklib name 'gtk_icon_info_free';
function gtk_icon_info_get_base_size(icon_info:PWGtkIconInfo):gint;cdecl;external gtklib name 'gtk_icon_info_get_base_size';
function gtk_icon_info_get_filename(icon_info:PWGtkIconInfo):Pgchar;cdecl;external gtklib name 'gtk_icon_info_get_filename';
function gtk_icon_info_get_builtin_pixbuf(icon_info:PWGtkIconInfo):PWGdkPixbuf;cdecl;external gtklib name 'gtk_icon_info_get_builtin_pixbuf';
function gtk_icon_info_load_icon(icon_info:PWGtkIconInfo; error:PPWGError):PWGdkPixbuf;cdecl;external gtklib name 'gtk_icon_info_load_icon';
procedure gtk_icon_info_set_raw_coordinates(icon_info:PWGtkIconInfo; raw_coordinates:gboolean);cdecl;external gtklib name 'gtk_icon_info_set_raw_coordinates';
function gtk_icon_info_get_embedded_rect(icon_info:PWGtkIconInfo; rectangle:PWGdkRectangle):gboolean;cdecl;external gtklib name 'gtk_icon_info_get_embedded_rect';
function gtk_icon_info_get_attach_points(icon_info:PWGtkIconInfo; points:PWPGdkPoint; n_points:PWgint):gboolean;cdecl;external gtklib name 'gtk_icon_info_get_attach_points';
function gtk_icon_info_get_display_name(icon_info:PWGtkIconInfo):Pgchar;cdecl;external gtklib name 'gtk_icon_info_get_display_name';

{$endif gtk2q_standalone}

{ TGtkIconInfo }

function TGtkIconInfo.Clone: ICloneable;
begin
  Result := (*$IFDEF FPC*)TGtkIconInfo.(*$ENDIF FPC*)CreateWrapped(gtk_icon_info_copy(GetUnderlying));
end;

constructor TGtkIconInfo.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_icon_info_free);
end;

function TGtkIconInfo.GetBaseSize: Integer;
begin
  Result := gtk_icon_info_get_base_size(GetUnderlying);
end;

function TGtkIconInfo.GetBuiltinPixbuf: IGdkPixbuf;
var
  itemraw: PWGdkPixbuf;
begin
  // XXX
  itemraw := gtk_icon_info_get_builtin_pixbuf(GetUnderlying);
  g_object_ref(itemraw);
  Result := WrapGObject(itemraw) as IGdkPixbuf;
end;

function TGtkIconInfo.GetDisplayName: string;
var
  aglist: PGChar;
begin
  aglist := gtk_icon_info_get_display_name(GetUnderlying);
  Result := string(aglist); // TODO utf
  // no freeing!
end;

function TGtkIconInfo.GetEmbeddedRect(
  out rectangle: TGdkRectangle): Boolean;
var
  rc : WGdkRectangle;
begin
  Result := gtk_icon_info_get_embedded_rect(GetUnderlying, @rc);
  rectangle := TGdkRectangle(rc);
end;

function TGtkIconInfo.GetFilename: String;
var
  res: PGChar;
begin
  res := gtk_icon_info_get_filename(GetUnderlying);

  Result := PChar(res); // todo utf ?
  // no freeing
end;

function TGtkIconInfo.LoadIcon: IGdkPixbuf;
var
  itemraw: PWGdkPixbuf;
begin
  // XXX
  itemraw := gtk_icon_info_get_builtin_pixbuf(GetUnderlying);
  g_object_ref(itemraw);
  Result := WrapGObject(itemraw) as IGdkPixbuf;
end;

procedure TGtkIconInfo.SetRawCoordinates(raw_coordinates: Boolean);
begin
  gtk_icon_info_set_raw_coordinates(GetUnderlying, raw_coordinates);
end;

end.
