unit ugdktypes;

interface
uses ugtypes;

{$INCLUDE clinksettings.inc}

type
  TGdkAtom = GULong;
  TGdkAtomArray = array of TGdkAtom;
  TGdkNativeWindow = GUInt32; // or pointer, bleh
  // FIXME proper alignment
  TGdkColor = record
    pixel: GUInt32;
    red: GUInt16;
    green: GUInt16;
    blue: GUInt16;
  end;

  TGdkSegment = record
    x1,y1,x2,y2: Integer; // gint
  end;

  TGdkPoint = record
    x,y: Integer;  // gint
  end;

  TGdkPointArray = array of TGdkPoint;
  
  TGdkRectangle = record
    x: Integer; // gint
    y: Integer; // gint
    width: Integer;  // gint
    height: Integer; // gint
  end;

  TGdkSpan = record
    x: Integer; // gint
    y: Integer;  // gint
    width: Integer;  // gint
  end;
  TGdkSpanArray = array of TGdkSpan;

  TGdkWMDecoration = set of (
    wdAll = 0, wdBorder = 1, wdResizeHorizontally = 2, wdTitle = 3,
    wdMenu = 4, wdMinimize = 5, wdMaximize = 6
  );
  (*wdResizeh = wdResizeHorizontally*)
  TGdkWindowState = set of (
    wsWithdrawn = 0,
    wsIconified = 1,
    wsMaximized = 2,
    wsSticky = 3,
    wsFullscreen = 4,
    wsAbove = 5,
    wsBelow = 6
  );

  //TGdkFilterReturn = (frContinue, frTranslate, frRemove);
  // FIXME -> generated

  //TGdkFillRule = (frEvenOdd, frWinding); -> generated
  TGdkInputMode = (imDisabled, imScreen, imWindow);
  TGdkInputSource = (isMouse, isPen, isEraser, isCursor);
  TGdkAxisUse = (auIgnore, auX, auY, auPressure, auXTilt, auYTilt, auWheel, auLast);

  TGdkAccelKey = guint; (* made that up *)
  TGdkOverlapType = (ovRectIn, ovRectOut, ovRectPart);
  TGdkFill = (fiSolid, fiTiled, fiStippled, fiOpaqueStippled);
  TGdkLineStyle = (lsSolid, lsOnOffDash, lsDoubleDash);
  TGdkJoinStyle = (jsMiter, jsRound, jsBevel);
  TGdkWindowType = (wtRoot, wtToplevel, wtChild, wtDialog, wtTemp, wtForeign);
  TGdkFunction = (fnCopy, fnInvert, fnXor, fnClear, fnAnd,
    fnAndReverse, fnAndInvert, fnNoop, fnOr, fnEquiv,
    fnOrReverse, fnCopyInvert, fnOrInvert, fnNand,
    fnNor, fnSet
  );

  TGdkWindowTypeHint = (thNormal, thDialog, thMenu, thToolbar, thSplashscreen, thUtility, thDock, thDesktop);

  TGdkWMFunction = set of (
    wfAll = 0,
    wfResize = 1,
    wfMove = 2,
    wfMinimize = 3,
    wfMaximize = 4,
    wfClose = 5
  );

  TGdkEventMask = set of (
    emExposureMask = 1,
    emPointerMotionMask= 2,
    emPointerMotionHintMask = 3,
    emButtonMotionMask = 4,
    emButton1MotionMask = 5,
    emButton2MotionMask = 6,
    emButton3MotionMask = 7,
    emButtonPressMask = 8,
    emButtonReleaseMask = 9,
    emKeyPressMask = 10,
    emKeyReleaseMask = 11,
    emEnterNotifyMask = 12,
    emLeaveNotifyMask = 13,
    emFocusChangeMask = 14,
    emStructureMask = 15,
    emPropertyChangeMask = 16,
    emVisibilityNotifyMask = 17,
    emProximityInMask = 18,
    emProximityOutMask = 19,
    emSubstructureMask = 20,
    emScrollMask = 21
  );
  
  TGdkKeyval = guint; // this is a type I made up :->

  TGdkModifierType = set of (
  	mtShift = 0, mtLock = 1, mtControl = 2, mtMod1 = 3, mtMod2 = 4, mtMod3 = 5,
  	mtMod4 = 6, mtMod5 = 7, mtButton1 = 8, mtButton2 = 9, mtButton3 = 10,
  	mtButton4 = 11, mtButton5 = 12, 
  	(** The next few modifiers are used by XKB, so we skip to the end. *)
        (* Bits 16 - 28 are currently unused, but will eventually
         * be used for "virtual modifiers". Bit 29 is used internally.
         *)
        mtRelease = 30
  );
{$INCLUDE ../output/gdk/gdkenums.inc}
  TGdkFilterFunc = function(gdkxevent: Pointer; gdkevent: Pointer; data: Pointer): TGdkFilterReturn; stdcall;
  TGdkSpanFunc = procedure(span: Pointer; userdata: Pointer);
  TGdkSubwindowMode = (smClip, smInferiors);
  TGdkWindowEdge = (weNorthWest, weNorth, weNorthEast, weWest, weEast, weSouthWest, weSouth, weSouthEast);

  TGdkColorArray = array of TGdkColor;

  TGdkVisibilityState = (vsUnobscured, vsPartial, vsFullyObscured);
  TGdkScrollDirection = (sdUp, sdDown, sdLeft, sdRight);
  TGdkCrossingMode = (cmNormal, cmGrab, cmUngrab);
  TGdkNotifyType = (noAncestor, noVirtual, noInferior, noNonlinear, noNonlinearVirtual);
  TGdkSettingAction = (saNew, saChanged, saDeleted);

  TGdkGravity = (grNorthWest, grNorth, grNorthEast,
   grWest, grCenter, grEast, grSouthWest, grSouth,
   grSouthEast, grStatic);

  TGdkDragAction = set of (
    daDefault = 0,
    daCopy = 1,
    daMove = 2,
    daLink = 3,
    daPrivate = 4,
    daAsk = 5
  );

  TGdkDragProtocol = (dpMotif, dpXdnd, dpRootwin, dpNone, dpWin32Dropfiles, dpOle2, dpLocal);

  TGdkGrabStatus = (gsSuccess, gsAlreadyGrabbed, gsInvalidTime, gsNotViewable, gsFrozen);
  
const
  // GdkModifierType
  mtMask = (1 shl 30) (*=GDK_RELEASE_MASK*) or $1fff;

  // TGdkEventMask
  emMask = $3FFFFE;

{$INCLUDE ugdkevents.inc}


implementation

end.
