unit ugdkbitmap;

(* untested *)

interface
uses sysutils,ugtypes,uvarrectools,iugsignal,ugsignal,sgdkpixmap
,iugdk,iugobject,ugdkdrawable,ugobject, ugdktypes, ugdkpixmap
;

(*$M+*) (* delphi RTTI *)


(* TODO IGdkBitmap ?? *)

type
  TGdkBitmap = class(TGdkPixmap,IGdkPixmap,IGdkDrawable,IGObject,IInvokable,IInterface)
  public
    class procedure TypeRegister; override;
    class function OverrideGType: TGType; override; (* 0: not *)

    class function CreateFromData(drawable: IGdkDrawable;data: UTF8String;width: Integer;height: Integer): IGdkBitmap;

  protected
  public
  published
  public
    
    
  end;

implementation
uses utyperegistry,uwrapgnames,uwrapgdknames;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
(* some here were "const" *)
function gdk_pixmap_new(drawable: Pointer;width: Integer;height: Integer;depth: Integer): Pointer; cdecl; external gdklib;
function gdk_pixmap_create_from_data(drawable: Pointer; data: PGChar;width: Integer;height: Integer;depth: Integer; fg: PWGdkColor; bg: PWGdkColor): Pointer; cdecl; external gdklib;
function gdk_bitmap_create_from_data(drawable: Pointer; data: PGChar;width: Integer;height: Integer): Pointer; cdecl; external gdklib;
function gdk_pixmap_get_type(): TGType; cdecl; external gdklib;
{$endif gtk2q_standalone}

class function TGdkBitmap.CreateFromData(drawable: IGdkDrawable;data: UTF8String;width: Integer;height: Integer): IGdkBitmap;
begin (* withoutgerror *)
  Result := IGdkBitmap(gdk_bitmap_create_from_data(drawable.GetUnderlying,PGChar(PChar(data)),Integer(width),Integer(height)));
end;

class function TGdkBitmap.OverrideGType: TGType; (* 0: not *)
var
  gtypeinfo: PWGTypeInfo;
  xclassname: UTF8String;
begin
  Result := 0;

  xclassname := ClassName;
  if (xclassname <> 'TGdkBitmap') and (xclassname <> 'TGdkPixmap') then begin (* derived *)
    if sizeof(Integer) = sizeof(Integer) then
      raise EAbstractError.Create('Class TGdkBitmap cannot be derived from!');

    gtypeinfo := DNewTypeInfo(sizeof(Integer));

    Result := g_type_register_static(gdk_pixmap_get_type, PGChar(PChar(xclassname)), gtypeinfo, 0); (* TODO abstract? *)
    assert(False); (* TODO *)
  end;
end;

class procedure TGdkBitmap.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('TGdkBitmap', 'gdk', TGdkBitmap, gdk_pixmap_get_type(), IGdkBitmap);
end;


initialization
  DGlobalTypeRegisterLock;
  TGdkBitmap.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.

