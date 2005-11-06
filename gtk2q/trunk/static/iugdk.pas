unit iugdk;

interface
uses ugdktypes, iugobject, iupango, ugdkpixbuftypes, ugtypes, iupointermediator, upointermediator,
iugsignal, ugsignal, ugobject, sgdkscreen, sgdkdisplay, sgdkdisplaymanager, sgdkpixbufloader,
sgdkpixbufanimation, sgdkpixbuf, iugdkpixbufformat, iug;

const
  GDK_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE iugdkcursor.inc}
{$INCLUDE ../output/gdk/iugdkgc.inc}
{$INCLUDE ../output/gdk/iugdkdrawable.inc}
{$INCLUDE ../output/gdk/iugdkdragcontext.inc}
{$INCLUDE ../output/gdk/iugdkpixmap.inc}
{$INCLUDE ../output/gdk/iugdkwindow.inc}
{$INCLUDE ../output/gdk/iugdkscreen.inc}
{$INCLUDE ../output/gdk/iugdkcolormap.inc}
{$INCLUDE ../output/gdk/iugdkdevice.inc}
{$INCLUDE ../output/gdk/iugdkdisplay.inc}
{$INCLUDE ../output/gdk/iugdkdisplaymanager.inc}
{$INCLUDE ../output/gdk/iugdkimage.inc}
{$INCLUDE ../output/gdk/iugdkvisual.inc}

{$INCLUDE ../output/gdk-pixbuf/iugdkpixbuf.inc}
{$INCLUDE iugdkpixbufanimationiter.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufanimation.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufloader.inc}
{$UNDEF define_consts}

type
  EGdkPixbufError = class(EGError)
  end;

type
{$DEFINE define_types}
{$IFDEF GTK_VERSIONED}
  IGdkGC26 = interface;
  IGdkScreen26 = interface;
  IGdkColormap26 = interface;
  IGdkPixmap26 = interface;
  IGdkBitmap26 = interface;
  IGdkRegion26 = interface;
  IGdkDisplay26 = interface;
  IGdkImage26 = interface;
  IGdkVisual26 = interface;
  IGdkPixbuf26 = interface;
  IGdkWindow26 = interface;
  IGdkDevice26 = interface;
  TIGdkPixbuf26Array = array of IGdkPixbuf;
  TIGdkVisual26Array = array of IGdkVisual;
  TIGdkWindow26Array = array of IGdkWindow;
  TIGdkDevice26Array = array of IGdkDevice;
  TIGdkDisplay26Array = array of IGdkDisplay;
  IGdkPixbufAnimation26 = interface;
{$ELSE}
  IGdkGC = interface;
  IGdkScreen = interface;
  IGdkColormap = interface;
  IGdkPixmap = interface;
  IGdkBitmap = interface;
  IGdkRegion = interface;
  IGdkDisplay = interface;
  IGdkImage = interface;
  IGdkVisual = interface;
  IGdkPixbuf = interface;
  IGdkWindow = interface;
  IGdkDevice = interface;
  TIGdkPixbufArray = array of IGdkPixbuf;
  TIGdkVisualArray = array of IGdkVisual;
  TIGdkWindowArray = array of IGdkWindow;
  TIGdkDeviceArray = array of IGdkDevice;
  TIGdkDisplayArray = array of IGdkDisplay;
  IGdkPixbufAnimation = interface;
{$ENDIF GTK_VERSIONED}

{$INCLUDE iugdkcursor.inc}
{$INCLUDE ../output/gdk/iugdkgc.inc}
{$INCLUDE ../output/gdk/iugdkdrawable.inc}
{$INCLUDE ../output/gdk/iugdkdragcontext.inc}
{$INCLUDE ../output/gdk/iugdkpixmap.inc}
{$INCLUDE ../output/gdk/iugdkwindow.inc}
{$INCLUDE ../output/gdk/iugdkscreen.inc}
{$INCLUDE ../output/gdk/iugdkcolormap.inc}
{$INCLUDE ../output/gdk/iugdkdevice.inc}
{$INCLUDE ../output/gdk/iugdkdisplay.inc}
{$INCLUDE ../output/gdk/iugdkdisplaymanager.inc}
{$INCLUDE iugdkregion.inc}
{$INCLUDE ../output/gdk/iugdkimage.inc}
{$INCLUDE ../output/gdk/iugdkvisual.inc}
{$IFDEF GTK_VERSIONED}
  IGdkBitmap26 = interface(IGdkPixmap26)
    ['{C99DC179-59CA-4B2F-8A59-2BA31E9D3198}']
  end;
{$ELSE}
  IGdkBitmap = interface(IGdkPixmap)
    ['{C99DC179-59CA-4B2F-8A59-2BA31E9D3198}']
  end;
{$ENDIF GTK_VERSIONED}

{$INCLUDE ../output/gdk-pixbuf/iugdkpixbuf.inc}
{$INCLUDE iugdkpixbufanimationiter.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufanimation.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufloader.inc}

{$UNDEF define_types}

implementation

{$DEFINE define_implementation}
{$INCLUDE iugdkcursor.inc}
{$INCLUDE ../output/gdk/iugdkgc.inc}
{$INCLUDE ../output/gdk/iugdkdrawable.inc}
{$INCLUDE ../output/gdk/iugdkdragcontext.inc}
{$INCLUDE ../output/gdk/iugdkpixmap.inc}
{$INCLUDE ../output/gdk/iugdkwindow.inc}
{$INCLUDE ../output/gdk/iugdkscreen.inc}
{$INCLUDE ../output/gdk/iugdkcolormap.inc}
{$INCLUDE ../output/gdk/iugdkdevice.inc}
{$INCLUDE ../output/gdk/iugdkdisplay.inc}
{$INCLUDE ../output/gdk/iugdkdisplaymanager.inc}
{$INCLUDE iugdkregion.inc}
{$INCLUDE ../output/gdk/iugdkimage.inc}
{$INCLUDE ../output/gdk/iugdkvisual.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbuf.inc}
{$INCLUDE iugdkpixbufanimationiter.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufanimation.inc}
{$INCLUDE ../output/gdk-pixbuf/iugdkpixbufloader.inc}

{$UNDEF define_implementation}

end.
