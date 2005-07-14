unit ugdkpixbufanimationiter;

interface
uses iugdk, iugobject, ugobject, ugtypes;

type
  TGdkPixbufAnimationIter = class(TGObject, IGdkPixbufAnimationIter, IGObject, IInvokable, IInterface)
  public
    class procedure TypeRegister; override;
    function Advance(const current_time: DGTimeVal): Boolean;
    function GetDelayTime: Integer; // ms
    function IsOnCurrentlyLoadingFrame: Boolean;
    function GetPixbuf: IGdkPixbuf;
  end;

implementation
uses utyperegistry, uwrapgdkpixbufnames, uwrapgnames, ugdkpixbuf;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

{ TGdkPixbufAnimationIter }

function gdk_pixbuf_animation_iter_advance(iter: PWGdkPixbufAnimationIter; {const} starttime: PWGTimeVal): gboolean; cdecl; external gdkpixbuflib;
function gdk_pixbuf_animation_iter_get_delay_time(iter: PWGdkPixbufAnimationIter): gint; cdecl; external gdkpixbuflib;
function gdk_pixbuf_animation_iter_get_pixbuf(iter: PWGdkPixbufAnimationIter): PWGdkPixbuf; cdecl; external gdkpixbuflib;
function gdk_pixbuf_animation_iter_on_currently_loading_frame(iter: PWGdkPixbufAnimationIter): gboolean; cdecl; external gdkpixbuflib;
function gdk_pixbuf_animation_iter_get_type: TGType; cdecl; external gdkpixbuflib;

{$endif gtk2q_standalone}

{ TGdkPixbufAnimationIter }

function TGdkPixbufAnimationIter.Advance(
  const current_time: DGTimeVal): Boolean;
begin
  Result := gdk_pixbuf_animation_iter_advance(Fobject, @current_time);
end;

function TGdkPixbufAnimationIter.GetDelayTime: Integer;
begin
  Result := gdk_pixbuf_animation_iter_get_delay_time(FObject);
end;

function TGdkPixbufAnimationIter.GetPixbuf: IGdkPixbuf;
var
  itemraw: PWGdkPixbuf;
begin
  Result := nil;
  itemraw := gdk_pixbuf_animation_iter_get_pixbuf(FObject);
  if not Assigned(itemraw) then Exit;
  //g_object_ref
  Result := WrapGObject(itemraw, TGdkPixbuf) as IGdkPixbuf;
end;

function TGdkPixbufAnimationIter.IsOnCurrentlyLoadingFrame: Boolean;
begin
  Result := gdk_pixbuf_animation_iter_on_currently_loading_frame(FObject);
end;

class procedure TGdkPixbufAnimationIter.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('PixbufAnimationIter', 'gdk', TGdkPixbufAnimationIter, gdk_pixbuf_animation_iter_get_type(), IGdkPixbufAnimationIter);
end;

end.
