unit ugdkcursor;

interface
uses iugdk;

{$INCLUDE clinksettings.inc}

(* TODO use drefcounter *)

type
  TGdkCursor = class(TObject, IGdkCursor, IInvokable, IInterface)
  private
    Flow: Pointer;
  public
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out obj): HRESULT; stdcall;

    constructor Create(display: IGdkDisplay; cursortype: TGdkCursorType); overload;
    //class function Create(pixmap: TGdkPixmap): IGdkCursor;
    constructor Create(display: IGdkDisplay; pixbuf: IGdkPixbuf; x, y: Integer); overload;
    destructor Destroy; override;
    function GetUnderlying: Pointer;
  protected
    function GetCursorType: TGdkCursorType;
    function GetDisplay: IGdkDisplay;
  published
    property CursorType: TGdkCursorType read getCursorType;
  end;
  
implementation
uses uwrapgnames, utyperegistry, ugtypes, ugobject, uwrapgdknames;

type
  PWGdkScreen = Pointer;
  PWGdkDisplay = Pointer;
  PWGdkPixmap = Pointer;
  PWGdkColor = Pointer;
  PWGdkPixbuf = Pointer;
  
  PWGdkCursor = ^WGdkCursor;
  WGdkCursor = record // fixme C alignment
    _type: WGdkCursorType; // integer; // fixme enum
    ref_count: guint;
  end;

function gdk_cursor_new_for_screen(screen:PWGdkScreen; cursor_type:WGdkCursorType):PWGdkCursor; cdecl; external gdklib;

function gdk_cursor_new_for_display(display:PWGdkDisplay; cursor_type: WGdkCursorType):PWGdkCursor; cdecl; external gdklib;

function gdk_cursor_new_from_pixmap(source:PWGdkPixmap; mask:PWGdkPixmap; fg:PWGdkColor; bg:PWGdkColor; x:gint;
           y:gint):PWGdkCursor; cdecl; external gdklib;

function gdk_cursor_new_from_pixbuf(display: PWGdkDisplay; source:PWGdkPixbuf; x,y: gint): PWGdkCursor; cdecl; external gdklib;

function gdk_cursor_get_screen(cursor:PWGdkCursor):PWGdkScreen; cdecl; external gdklib;
function gdk_cursor_ref(cursor:PWGdkCursor):PWGdkCursor; cdecl; external gdklib;
procedure gdk_cursor_unref(cursor:PWGdkCursor); cdecl; external gdklib;
function gdk_cursor_get_display(cursor:PWGdkCursor): PWGdkDisplay; cdecl; external gdklib; // 2.2

function TGdkCursor.GetCursorType: TGdkCursorType;
begin
  Result := TGdkCursorType(PWGdkCursor(Flow)^._type);
end;

constructor TGdkCursor.Create(display: IGdkDisplay; cursortype: TGdkCursorType);
begin
  inherited Create;
  Flow := gdk_cursor_new_for_display(PWGdkDisplay(display.GetUnderlying), WGdkCursorType(cursortype));
end;

constructor TGdkCursor.Create(display: IGdkDisplay; pixbuf: IGdkPixbuf; x, y: Integer);
begin
  inherited Create;
  Flow := gdk_cursor_new_from_pixbuf(PWGdkDisplay(display.GetUnderlying),
  	PWGdkPixbuf(pixbuf.GetUnderlying), x, y);
end;

function TGdkCursor._AddRef: Integer;
begin
  gdk_cursor_ref(Flow);
  Result := PWGdkCursor(Flow)^.ref_count;
end;

function TGdkCursor._Release: Integer;
begin
  gdk_cursor_unref(Flow);
  Result := PWGdkCursor(Flow)^.ref_count;
end;

destructor TGdkCursor.Destroy;
begin
  if Assigned(Flow) then
    gdk_cursor_unref(Flow);
  inherited;
end;

{$IFDEF FPC}
const E_NOINTERFACE: HRESULT = HRESULT($80004002);
{$ENDIF FPC}

function TGdkCursor.QueryInterface(const IID: TGUID; out obj): HRESULT;
begin
  if GetInterface(IID, obj) then
    Result := 0
  else
    Result := E_NoInterface;
end;

function TGdkCursor.GetUnderlying: Pointer;
begin
  Result := Flow;
end;

function TGdkCursor.GetDisplay: IGdkDisplay;
var
  native: PWGdkDisplay;
begin
  native := gdk_cursor_get_display(GetUnderlying);
  g_object_ref(PWGObject(native));
  Result := WrapGObject(native) as IGdkDisplay;
end;

end.
