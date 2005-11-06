unit ugtktypes;

interface
uses ugtypes, ugdktypes, sysutils;

{$INCLUDE clinksettings.inc}

const
  // GtkAccelFlags:
  afMask = $7;

  // TGtkResponseType
  reNone = -1;
  reReject = -2;
  reAccept = -3;
  reDeleteEvent = -4;
  reOk = -5;
  reCancel = -6;
  reYes = -8;
  reNo = -9;
  reApply = -10;
  reHelp = -11;

type
{$INCLUDE gtkcallback.inc}
  TGtkResizeMode = (rmParent, rmQueue, rmImmediate);
  TGtkPackType = (paStart, paEnd);
  TGtkButtonBoxStyle = (bsDefault, bsSpread, bsEdge, bsStart, bsEnd);
  TGtkBorder = record
    left, right, top, bottom: gint;
  end;

  TGtkResponseType = Integer; (* for now *)
  TGtkCalendarDisplayOptions = set of (
    cdShowHeading = 0,
    cdShowDayNames = 1,
    cdNoMonthChange = 2,
    cdShowWeekNumbers = 3,
    cdWeekStartMonday = 4
  );

  TGtkReliefStyle = (rsNormal, rsHalf, rsNone);
  TGtkIconSize = (isInvalid, isMenu, isSmallToolbar, isLargeToolbar, isButton, isDnd, isDialog);
  TGtkDirectionType = (diTabForward, diTabBackward, diUp, diDown, diLeft, diRight);
  TGtkTextDirection = (tdNone, tdLtr, tdRtl);
  TGtkStateType = (stNormal, stActive, stPrelight, stSelected, stInsensitive);
  TGtkArrowType = (arUp, arDown, arLeft, arRight);
  TGtkShadowType = (shNone, shIn, shOut, shEtchedIn, shEtchedOut);
  TGtkAccelFlags = set of (
    afVisible = 0,
    afLocked = 1
  );
  TGtkAllocation = record
    x,y,width,height: GInt;
  end;

  PGtkNotebookPage = Pointer; // ugh
 
  TGtkRequisition = record
    width,height: GInt;
  end;
  TGtkCellRendererState = set of (
    crSelected = 0,
    crPrelit = 1,
    crInsensitive = 2,
    crSorted = 3,
    crFocused = 4
  );
  TGtkCellRendererMode = (cmInert, cmActivatable, cmEditable);

  TGtkTargetEntry = record
    target: PChar; // PGChar
    flags: GUint;
    info: GUint;
  end;
  TGtkTargetEntryArray = array of TGtkTargetEntry;

  TGtkTreeIter = record
    stamp : gint;
    user_data : pointer; // gpointer
    user_data2 : pointer; // gpointer
    user_data3 : pointer; // gpointer
  end;
  TGtkTextIter = record
    dummy1, dummy2: pointer; // gpointer
    dummy3, dummy4, dummy5, dummy6, dummy7, dummy8: gint;
    dummy9, dummy10: pointer; // gpointer
    dummy11, dummy12, dummy13: gint;
    dummy14: pointer; // gpointer
  end;

  TGtkTreeIterArray = array of TGtkTreeIter;
  
  TGtkWindowPosition = (wpNone, wpCenter, wpMouse, wpCenterAlways, wpCenterOnParent);
  TGtkWindowType = (wiToplevel, wiPopup);
  TGtkCurveType = (cuLinear, cuSpline, cuFree);
  TGtkPositionType = (poLeft, poRight, poTop, poBottom);

  TGtkFileFilterFlags = set of (
    ffFilename = 0,
    ffURI = 1,
    ffDisplayname = 2,
    ffMimetype = 3
  );
  TGtkDialogFlags = set of (
    dfModal = 0,
    dfDestroyWithParent = 1,
    dfNoSeparator = 2
  );

  //TGtkFileChooserAction = (fcOpen, fcSave, fcSelectFolder, fcCreateFolder);
  TGtkFileFilterInfo = record
    contains: TGtkFileFilterFlags;
    filename, uri, displayname, mimetype: PChar;
  end;

  TGtkWidgetState = (wsNormal, wsActive, wsPrelight, wsSelected, wsInsensitive);


  // icontheme:
  TGtkIconLookupFlags = set of (
    ilNoSvg = 0,
    ilForceSvg = 1,
    ilUseBuiltIn = 2
  );
  TGtkOrientation = (orHorizontal, orVertical);
  TGtkSelectionMode = (smNone, smSingle, smBrowse, smMultiple); // smExtended = deprecated
  //TGtkImageType = (imEmpty, imPixmap, imImage, imPixbuf, imStock, imIconSet, imAnimation, imIconName);
  TGtkJustification = (juLeft, juRight, juCenter, juFill);
  //TGtkMessageType = (meInfo, meWarning, meQuestion, meError);
  TGtkButtonsType = (buNone, buOk, buClose, buCancel, buYesNo, buOkCancel);
  TGtkProgressBarOrientation = (pbLeftToRight, pbRightToLeft, pbBottomToTop, pbTopToBottom);
  TGtkProgressBarStyle = (pbContinuous, pbDiscrete);
  TGtkUpdateType = (upContinuous, upDiscontinuous, upDelayed);
  TGtkMetricType = (mtPixels, mtInches, mtCentimeters);
  TGtkCornerType = (coTopLeft, coBottomLeft, coTopRight, coBottomRight);
  TGtkPolicyType = (poAlways, poAutomatic, poNever);
  TGtkToolbarStyle = (tsIcons, tsText, tsBoth, tsBothHorizontal);
  //TGtkSizeGroupMode = (sgNone, sgHorizontal, sgVertical, sgBoth);
  TGtkSpinType = (spStepForward, spStepBackward, spPageForward, spPageBackware, spHome, spEnd, spUserDefined);
  //TGtkSpinButtonUpdatePolicy = (upAlways, upIfValid);
  TGtkExpanderStyle = (esCollapsed, esSemiCollapsed, esSemiExpanded, esExpanded);
  TGtkAttachOptions = set of (
    aoExpand = 0,
    aoShrink = 1,
    aoFill = 2
  );
  TGtkWrapMode = (wrNone, wrChar, wrWord, wrWordChar);
  //TGtkTextWindowType = (twPrivate, twWidget, twText, twLeft, twRight, twTop, twBottom);
  TGtkToolbarSpaceStyle = (tsEmpty, tsLine);
  TGtkTreeModelFlags = set of (
    tmItersPersist = 0,
    tmListOnly = 1
  );
  TGtkSortType = (soAscending, soDescending);
  //TGtkTreeViewColumnSizing = (tcGrowOnly, tcAutosize, tcFixed);
  //TGtkTreeViewDropPosition = (dpDropBefore, dpDropAfter, dpDropIntoOrBefore, dpDropIntoOrAfter);
  TGtkUiManagerItemType = set of (
    umMenubar = 0,
    umMenu = 1,
    umToolbar = 2,
    umPlaceholder = 3,
    umPopup = 4,
    umMenuitem = 5,
    umToolitem = 6,
    umSeparator = 7,
    umAccelerator = 8
  );

  PTGtkAccelKey = ^TGtkAccelKey;
  TGtkAccelKey = record
    accelKey: GUint;
    accelMods: TGdkModifierType;
    accelFlags: GUint; // :16
  end;

  PTGtkAccelGroupEntry = ^TGtkAccelGroupEntry;
  TGtkAccelGroupEntry = record
    key: TGtkAccelKey;
    closure: Pointer;
    quark: TGQuark;
  end;
  TGtkAccelGroupEntryArray = array of TGtkAccelGroupEntry;

  TGtkWidgetHelpType = (whTooltip, whWhatsThis);

  TGtkDeleteType = (deChars, deWordEnds, deWords, deDisplayLines, deDisplayLineEnds, deParagraphEnds, deParagraphs, deWhitespace);

  TGtkMovementStep = (msLogicalPositions, msVisualPositions, msWords,
  msDisplayLines, msDisplayLineEnds, msParagraphs, msParagraphEnds,
  msPages, msBufferEnds, msHorizontalPages);

  TGtkMenuDirectionType = (mdParent, mdChild, mdNext, mdPrev);
  TGtkScrollType = (scNone, scJump, scStepBackward, scStepForward, scPageBackward, scPageForward,
  scStepUp, scStepDown, scPageUp, scPageDown, scStepLeft, scStepRight, scPageLeft, scPageRight,
  scStart, scEnd);

  TGtkScrollStep = (ssSteps, ssPages, ssEnds, ssHorizontalSteps, ssHorizontalPages,
  ssHorizontalEnds);

  TGtkRcFlags = set of (cfFg, cfBg, cfText, cfBase);

  (* DRAWABLE = VISIBLE + MAPPED *)
  (* IS_SENSITIVE = SENSITIVE + PARENT_SENSITIVE *)
  TGtkWidgetFlag = (wfToplevel, wfWindow,
  wfRealized, wfMapped, wfVisible, wfSensitive,
  wfParentSensitive, wfCanFocus, wfHasFocus,
  wfCanDefault, wfHasDefault,
  wfHasGrab, wfRcStyle, wfCompositeChild,
  wfReparent, wfAppPaintable,
  wfReceivesDefault, wfDoubleBuffered,
  wfInShowAllList);
  TGtkWidgetFlags = set of TGtkWidgetFlag;
  
  TGtkAnchorType = (anCenter, anNorth, anNorthWest, anNorthEast, 
  anSouth, anSouthWest, anSouthEast, anWest, anEast);

  ENotFoundError = class(Exception)
  end;
{$INCLUDE ../output/gtk/gtkenums.inc}

function TGtkAccelGroupEntryFromPointer(ptr: Pointer): TGtkAccelGroupEntry; // raise ENotFoundError
function TGtkAccelKeyFromPointer(ptr: Pointer): TGtkAccelKey; // raise ENotFoundError

const 
  umAuto: TGtkUIManagerItemType = []; // ->0: special

implementation

function TGtkAccelGroupEntryFromPointer(ptr: Pointer): TGtkAccelGroupEntry; // raise ENotFoundError
begin
  if not Assigned(ptr) then
    raise ENotFoundError.Create('no AccelGroup found');

  Result := PTGtkAccelGroupEntry(ptr)^;
end;

function TGtkAccelKeyFromPointer(ptr: Pointer): TGtkAccelKey; // raise ENotFoundError
begin
  if not Assigned(ptr) then
    raise ENotFoundError.Create('no AccelKey found');

  Result := PTGtkAccelKey(ptr)^;
end;

end.
