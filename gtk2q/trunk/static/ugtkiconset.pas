unit ugtkiconset;

interface
uses drefcounter, iugtk, ugtktypes, iugdk;

// UGH! whatever... half gobject half managed heap object (has gtk_icon_set_free too O_o)

type
  TGtkIconSet = class(TCustomDInterfacedObject, IGtkIconSet, IInvokable, IInterface)
  protected
    procedure UnrefUnderlyingObject; override;
    procedure RefUnderlyingObject; override;
  public
    (*function GetUnderlying: Pointer;*)
    // FObject PGIconSet
  public
    constructor CreateWrapped(ptr: Pointer); (*override;*)
  public
    function RenderIcon(style: IGtkStyle; direction: TGtkTextDirection;
            state: TGtkStateType; iconsize: TGtkIconSize = TGtkIconSize(-1); 
            widget: IGtkWidget = nil;
            detail: string = ''): IGdkPixbuf;
  end;

implementation
uses uwrapgnames, uwrapgtknames, uwrapgdkpixbufnames, ugdkpixbuf;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PWGtkIconSet = Pointer;

function gtk_icon_set_ref(iconset: Pointer): Pointer; cdecl; external gtklib;
procedure gtk_icon_set_unref(iconset: Pointer); cdecl; external gtklib;
function gtk_icon_set_render_icon(icon_set:PWGtkIconSet; style:PWGtkStyle; direction:WGtkTextDirection; state:WGtkStateType; size:WGtkIconSize;
           widget:PWGtkWidget; detail:Pgchar):PWGdkPixbuf; cdecl; external gtklib; // pchar?

{$endif gtk2q_standalone}


{ TGtkIconSet }

procedure TGtkIconSet.UnrefUnderlyingObject;
begin
  gtk_icon_set_ref(PWGtkIconSet(Fobject));
end;

procedure TGtkIconSet.RefUnderlyingObject;
begin
  gtk_icon_set_unref(PWGtkIconSet(Fobject));
end;

constructor TGtkIconSet.CreateWrapped(ptr: Pointer);
begin
  inherited Create;
  Fobject := ptr;
end;

(*function TGtkIconSet.GetUnderlying: Pointer;
begin
  Result := FObject;
end;*)

function TGtkIconSet.RenderIcon(style: IGtkStyle; direction: TGtkTextDirection;
            state: TGtkStateType; iconsize: TGtkIconSize = TGtkIconSize(-1); widget: IGtkWidget = nil;
                    detail: string = ''): IGdkPixbuf;
var
  detailp: PGChar;
  widgetp: PWGtkWidget;
  stylep: PWGtkStyle;
  pbp: PWGdkPixbuf;
begin
  detailp := nil;
  if detail <> '' then detailp := PGChar(PChar(detail));
  
  if Assigned(style) then
    stylep := style.GetUnderlying
  else
    stylep := nil;
    
  // iconsize (GtkIconSize)-1
  
  // widget to get screen from or nil

  if Assigned(widget) then
    widgetp := widget.GetUnderlying
  else
    widgetp := nil;
    

  // never returns NULL according to help    
  pbp := gtk_icon_set_render_icon(PWGtkIconSet(GetUnderlying),
  	stylep, WGtkTextDirection(direction), WGtkStateType(state),
    WGtkIconSize(iconsize), widgetp, detailp
  );

  // initial ref
  
  Result := TGdkPixbuf.CreateWrapped(pbp) as IGdkPixbuf;
end;
                    
end.
