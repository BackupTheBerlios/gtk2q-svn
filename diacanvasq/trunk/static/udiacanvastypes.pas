unit udiacanvastypes;

interface
uses ugtypes, uarttypes, ugnomecanvastypes, ugdkrgb;

(*$INCLUDE static/clinksettings.inc*)

const
  // TDiaEventMask
  deShift = 1 shl 0;
  deLock = 1 shl 1;
  deCtrl = 1 shl 2;
  deMod1 = 1 shl 3;
  deAlt = deMod1;
  deMod2 = 1 shl 4;
  deMod3 = 1 shl 5;
  deMod4 = 1 shl 6;
  deMod5 = 1 shl 7;
  deButton1 = 1 shl 8;
  deButton2 = 1 shl 9;
  deButton3 = 1 shl 10;
  deButton4 = 1 shl 11;
  deButton5 = 1 shl 12;

type
  TDiaPoint = DArtPoint;
  PTDiaRectangle = ^TDiaRectangle;
  TDiaRectangle = record (* C *)
    left, top, right, bottom: gdouble;
  end;

  TDiaCanvasIter = record (* C *)
    data1: Pointer;
    data2: Pointer;
    data3: Pointer;
    destroyFunc: DGDestroyNotify;
    stamp: gint;
  end;

  TDiaColor = DGdkRgbColor;

  TDiaStrength = (dsVeryWeak, dsWeak, dsMedium, dsStrong, dsVeryStrong, dsRequired);

  TDiaJoinStyle = (djMiter, djRound, djBevel);
  TDiaCapStyle = (dcButt, dcRound, dcSquare);
  
  TDiaCanvasItemAffine = TAffineTransform;

(*$INCLUDE static/diacanvascallback.inc*)

  (* events *)
  TDiaEventType = (deButtonPress, de2ButtonPress, de3ButtonPress,
    deButtonRelease, deMotion, deKeyPress, deKeyRelease);

  TDiaEventMask = gint; 

  TDiaEventButton = record (* C *)
    typ: TDiaEventType;
    x,y: gdouble;
    modifier: TDiaEventMask;
  end;
  TDiaEventMotion = record (* C *)
    typ: TDiaEventType;
    x,y: gdouble;
    modifier: TDiaEventMask;
    dx,dy: gdouble; (* item relative *)
  end;
  TDiaEventKey = record (* C *)
    typ: TDiaEventType;
    keyval: guint; (* gdk/gdkkeysyms.h *)
    len: gint;
    str: PChar; (* actually PGChar *)
    modifier: TDiaEventMask;
  end;

  TDiaEvent = record case Integer of
  0: (typ: TDiaEventType;);
  1: (button: TDiaEventButton;);
  2: (motion: TDiaEventMotion;);
  3: (key: TDiaEventKey;);
  end;

  TDiaShapeType = (dsNone, dsPath, dsBezier, dsEllipse, dsText, dsImage, dsWidget, dsClip);
  TDiaFillStyle = (dfNone, dfSolid);
  TDiaWrapMode = (dwNone, dwChar, dwWord);
  (* TDiaShapeVisibility DEPRECATED *)

  TDiaCanvasElementHandle = (deNorth, deNorthwest, deNortheast, deSouth, deWest, deEeast,
    deSouthwest, deSoutheast);

implementation

end.
