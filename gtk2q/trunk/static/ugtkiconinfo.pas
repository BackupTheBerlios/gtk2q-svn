unit ugtkiconinfo;

{$M+}

interface
uses iupointermediator, upointermediator, iugtkiconinfo, iugdk, ugdktypes, iug;

type
  TGtkIconInfo = class(TPointerMediator, IGtkIconInfo, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  published
    function LoadIcon: IGdkPixbuf;
    function Clone: ICloneable;
  protected
    function GetDisplayName: string;
    //procedure GtkIconInfoFree;
    function GetBuiltinPixbuf: IGdkPixbuf;
    function GetFilename: String;
    function GetEmbeddedRectangle(): TGdkRectangle;
    function GetBaseSize: Integer;

  published
    property BaseSize: Integer read GetBaseSize;
    property Filename: string read GetFilename;
    property DisplayName: string read GetDisplayName;
    property EmbeddedRectangle: TGdkRectangle read GetEmbeddedRectangle;
  public
    property BuiltinPixbuf: IGdkPixbuf read GetBuiltinPixbuf;
  end;

implementation
uses uwrapgnames, utyperegistry, ugtypes, ugobject, uwrapgtknames;

{$INCLUDE clinksettings.inc}

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

function TGtkIconInfo.GetEmbeddedRectangle(): TGdkRectangle;
var
  rc : WGdkRectangle;
begin
  if gtk_icon_info_get_embedded_rect(GetUnderlying, @rc) then begin
    Result := TGdkRectangle(rc);
  end else begin
    Result.x := 0;
    Result.y := 0;
    Result.width := 0;
    Result.height := 0;
  end;
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

end.
