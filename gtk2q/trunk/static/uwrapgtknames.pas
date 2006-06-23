unit uwrapgtknames;

// contains lowlevel stuff only
// (some weird types it needs for importing and I dont)

interface
uses uwrapgnames, ugtktypes, uwrapgdknames, ugtypes;

{$INCLUDE clinksettings.inc}

const
(*$IFDEF WIN32*)
  gtklib = 'libgtk-win32-2.0-0.dll';
(*$ELSE*)
  gtklib = 'libgtk-x11-2.0.so';
(*$ENDIF*)

const
  // WGtkRcFlags, internal enough :)
  rcFg = 1 shl 0;
  rcBg = 1 shl 1;
  rcText = 1 shl 2;
  rcBase = 1 shl 3;

type
  PWGtkAccelGroupEntry = ^WGtkAccelGroupEntry;
  WGtkAccelGroupEntry = TGtkAccelGroupEntry;
  PWGtkAccelKey = Pointer;

  WGtkAccelKeyEntry = record
    accelkey: guint;
    accelmods: WGdkModifierType;
    accelflags: guint16; (* :16 *)
  end;

  PWGtkObject = ^WGtkObject;
  WGtkObject = record // C
    gobject: WGObject;
    // 32 bits of flags. note that gtkobject only uses
    // 4 of these bits. GtkWidget uses the rest.
    flags: guint32;
  end;
  
  PWGtkCurve = PWGObject;
  PWGtkEditable = PWGObject;
  PWGtkEntryCompletion = PWGObject; // ?
  PWGtkWidget = PWGObject;
  PWGtkWindow = PWGObject;
  PWGtkItem = PWGObject;
  PWGtkDialog = PWGObject;
  PWGtkDrawingArea = PWGObject;
  PWGtkMessageDialog = PWGObject;
  PWGtkMisc = PWGObject;
  PWGtkLabel = PWGObject;
  PWGtkAccelLabel = PWGObject;
  PWGtkAccessible = PWGObject;
  PWGtkSpinButton = PWGObject;
  PWGtkSocket = PWGObject;
  PWGtkPlug = PWGObject;
  PWGtkSeparator = PWGObject;
  PWGtkAction = PWGObject;
  PWGtkActionGroup = PWGObject;
  PWGtkButton = PWGObject;
  PWGtkMenuItem = PWGObject;
  PWGtkCheckMenuItem = PWGObject;
  PWGtkComboBox = PWGObject;
  PWGtkFixed = PWGObject;
  PWGtkFontSelectionDialog = PWGObject;
  PWGtkGammaCurve = PWGObject;  // :)
  PWGtkPaned = PWGObject;
  PWGtkIconFactory = PWGObject;
  PWGtkAboutDialog = PWGObject;
  PWGtkIconSet = gpointer; (* weird *)

  PGInterface = gpointer;

  PWGtkTreeDragDest = PGInterface;
  PWGtkTreeDragSource = PGInterface;

  PWGtkClipboard = PWGObject;

  PWGtkImage = PWGObject;
  PWGtkBox = PWGObject;
  PWGtkEntry = PWGObject;
  PWGtkAdjustment = PWGObject;
  PWGtkContainer = PWGObject;
  PWGtkAccelGroup = PWGObject;
  PWGtkBin = PWGObject;
  PWGtkAlignment = PWGObject;
  PWGtkArrow = PWGObject;
  PWGtkFrame = PWGObject;
  PWGtkAspectFrame = PWGObject;
  PWGtkButtonBox = PWGObject;
  PWGtkCalendar = PWGObject;
  PWGtkCellEditable = PWGObject;
  PWGtkCellLayout = PWGObject;
  PWGtkCellRenderer = PWGObject;
  PWGtkCellRendererText = PWGObject;
  PWGtkCellRendererPixbuf = PWGObject;
  PWGtkCellRendererToggle = PWGObject;
  PWGtkTreeView = PWGObject;
  PWGtkTreeModel = PWGObject;
  PWGtkTreeStore = PWGObject;
  PWGtkListModel = PWGObject;
  PWGtkListStore = PWGObject;
  PWGtkTreeViewColumn = PWGObject;
  PWGtkTextView = PWGObject;
  PWGtkTextBuffer = PWGObject;
  PWGtkToggleButton = PWGObject;
  PWGtkCheckButton = PWGObject;
  PWGtkTable = PWGObject;
  PWGtkRuler = PWGObject;
  PWGtkScale = PWGObject;
  PWGtkExpander = PWGObject;
  PWGtkFileChooser = PWGObject;
  PWGtkFileChooserDialog = PWGObject;
  PWGtkFileChooserButton = PWGObject;
  PWGtkColorSelection = PWGObject;
  PWGtkRange = PWGObject;
  PWGtkFileFilter = PWGObject;
  PWGtkScrollbar = PWGObject;
  PWGtkIconTheme = PWGObject;
  PWGtkIMContext = PWGObject;
  PWGtkIMMulticontext = PWGObject;
  PWGtkLayout = PWGObject;
  PWGtkMenuShell = PWGObject;
  PWGtkMenu = PWGObject;
  PWGtkNotebook = PWGObject;
  PWGtkProgressBar = PWGObject;
  PWGtkToggleAction = PWGObject;
  PWGtkRadioAction = PWGObject;
  PWGtkToolItem = PWGObject;
  PWGtkToggleToolButton = PWGObject;
  PWGtkScrolledWindow = PWGObject;
  PWGtkSettings = PWGObject;
  PWGtkSizeGroup = PWGObject;

  PWGtkStatusbar = PWGObject;

  PWGtkTooltips = PWGObject;

  PWGtkStyle = PWGObject;

  PWGtkTreeModelFilter = PWGObject;
  PWGtkIconView = PWGObject;
  PWGtkMenuToolButton = PWGObject;
  PWGtkToolButton = PWGObject;

  PWGtkTextMark = PWGObject;
  PWGtkTextTag = PWGObject;
  PWGtkTextTagTable = PWGObject;
  PWGtkToolbar = PWGObject;
  PWGtkTreeModelSort = PWGObject;
  PWGtkTreeSelection = PWGObject;
  PWGtkTreeSortable = PGInterface;
  PWGtkUIManager = PWGObject;
  PWGtkViewport = PWGObject;
  PWGtkWindowGroup = PWGObject;
  PWGtkAccelMap = PWGObject;

  PWGtkIconInfo = Pointer; // uhh

  PWGtkFileFilterInfo = Pointer; 
  
  WGtkEntryCompletionMatchFunc = TGtkEntryCompletionMatchFunc;
  WGtkIconViewForeachFunc = TGtkIconViewForeachFunc;
  WGtkAboutDialogActivateLinkFunc = TGtkAboutDialogActivateLinkFunc;

  PWGtkTextIter = Pointer;


  PWGtkArg = Pointer; (* ?? *)
  
type
  WGtkTreeViewColumnDropFunc = TGtkTreeViewColumnDropFunc;
  WGtkTreeViewSearchEqualFunc = TGtkTreeViewSearchEqualFunc;
  WGtkTreeViewMappingFunc = TGtkTreeViewMappingFunc;
  WGtkTreeCellDataFunc = TGtkTreeCellDataFunc;
  WGtkAccelMapForeach = TGtkAccelMapForeach;

  WGtkTargetEntryArray = TGtkTargetEntryArray;

  WGtkTreeModelFilterModifyFunc = TGtkTreeModelFilterModifyFunc;
  WGtkTreeModelFilterVisibleFunc = TGtkTreeModelFilterVisibleFunc;

  PWGtkTreeRowReference = Pointer;

  WGtkTreeModelForeachFunc = TGtkTreeModelForeachFunc;

type
  (* enums *)
  PWGtkIconSize = ^WGtkIconSize;
  PWGtkPolicyType = ^WGtkPolicyType;
  PWGtkSortType = ^WGtkSortType;
  PWGtkPackType = ^WGtkPackType;
  PWGtkTreeViewDropPosition = ^WGtkTreeViewDropPosition;
  PWGtkIconViewDropPosition = ^WGtkIconViewDropPosition;

  WGtkAccelFlags = gint;
  WGtkArrowType = gint;
  WGtkAttachOptions = gint;
  WGtkButtonBoxStyle = gint;
  WGtkButtonsType = gint;
  WGtkCalendarDisplayOptions = gint;
  WGtkCellRendererMode = gint;
  WGtkCellRendererState = gint;
  WGtkCornerType = gint;
  WGtkCTreeLineStyle = gint;
  WGtkCurveType = gint;
  WGtkDeleteType = gint;
  WGtkDialogFlags = gint;
  WGtkDirectionType = gint;
  WGtkExpanderStyle = gint;
  WGtkFileChooserAction = gint;
  WGtkFileFilterFlags = gint;
  WGtkIconLookupFlags = gint;
  WGtkIconSize = gint;
  WGtkImageType = gint;
  WGtkJustification = gint;
  WGtkMenuDirectionType = gint;
  WGtkMessageType = gint;
  WGtkMetricType = gint;
  WGtkMovementStep = gint;
  WGtkNotebookTab = gint;
  WGtkOrientation = gint;
  WGtkPackType = gint;
  WGtkPolicyType = gint;
  WGtkPositionType = gint;
  WGtkProgressBarOrientation = gint;
  WGtkProgressBarStyle = gint;
  WGtkReliefStyle = gint;
  WGtkResizeMode = gint;
  WGtkScrollStep = gint;
  WGtkScrollType = gint;
  WGtkSelectionMode = gint;
  WGtkShadowType = gint;
  WGtkSizeGroupMode = gint;
  WGtkSortType = gint;
  WGtkSpinButtonUpdatePolicy = gint;
  WGtkSpinType = gint;
  WGtkStateType = gint;
  WGtkTextDirection = gint;
  WGtkTextWindowType = gint;
  WGtkTreeViewDropPosition = gint;
  WGtkIconViewDropPosition = gint;
  WGtkToolbarSpaceStyle = gint;
  WGtkToolbarStyle = gint;
  WGtkTreeViewColumnSizing = gint;
  WGtkTreeModelFlags = gint;
  WGtkUIManagerItemType = gint;
  WGtkUpdateType = gint;
  WGtkWidgetHelpType = gint;
  WGtkWindowPosition = gint;
  WGtkWindowType = gint;
  WGtkWrapMode = gint;
  (* end enums *)

type
  WGtkMenuDetachFunc = TGtkMenuDetachFunc;
  WGtkMenuPositionFunc = TGtkMenuPositionFunc;
  WGtkTextTagTableForeach = TGtkTextTagTableForeach;

  WGtkCallback = TGtkCallback;

  WGtkAccelGroupFindFunc = TGtkAccelGroupFindFunc;

type
  PWGtkSelectionData = Pointer;

type
  WGtkTreeIterCompareFunc = TGtkTreeIterCompareFunc;
  WGtkTreeSelectionForeachFunc = TGtkTreeSelectionForeachFunc;
  WGtkTreeSelectionFunc = TGtkTreeSelectionFunc;

type
  PWGtkAllocation = ^WGtkAllocation;
  WGtkAllocation = TGtkAllocation;

  PWGtkRequisition = ^WGtkRequisition;
  WGtkRequisition = TGtkRequisition;

  PWGtkTreeIter = ^WGtkTreeIter;
  WGtkTreeIter = record
    stamp: gint;
    userdata, userdata2, userdata3: gpointer;
  end;
  PWGtkTreePath = Pointer;


//  PWGdkEventKey = ^WGdkEventKey;
//  WGdkEventKey = TGdkEventKey;

  // actiongroup
  WGtkTranslateFunc = TGtkTranslateFunc;
  WGtkDestroyNotify = DGDestroyNotify;

  WGtkCellLayoutDataFunc = TGtkCellLayoutDataFunc;

  WGtkFileFilterFunc = TGtkFileFilterFunc;

  WGtkClipboardGetFunc = TGtkClipboardGetFunc;
  WGtkClipboardClearFunc = TGtkClipboardClearFunc;
  WGtkClipboardTargetsReceivedFunc = TGtkClipboardTargetsReceivedFunc;
  WGtkClipboardReceivedFunc = TGtkClipboardReceivedFunc;
  WGtkClipboardTextReceivedFunc = TGtkClipboardTextReceivedFunc;

  WGtkColorSelectionChangePaletteWithScreenFunc = TGtkColorSelectionChangePaletteWithScreenFunc;

  WGtkRcFlags = gint; // internal
  WGtkWidgetState = TGtkWidgetState; (* internal? *)

  PWGtkRcStyle = ^WGtkRcStyle;
  WGtkRcStyle = record // C
    parent_instance: WGObject;
    name: PGChar;
    BgPixmapName: array[WGtkWidgetState] of PGChar;
    FontDesc: Pointer; // PangoFontDescription *
    ColorFlags: array[WGtkWidgetState] of WGtkRcFlags;
    Fg: array[WGtkWidgetState] of WGdkColor;
    Bg: array[WGtkWidgetState] of WGdkColor;
    Text: array[WGtkWidgetState] of WGdkColor;
    Base: array[WGtkWidgetState] of WGdkColor;
    xthickness, ythickness: gint;

    rcProperties: Pointer; // GArray *
    rcStyleLists: Pointer; // GSList *; list of rc_style_lists
    iconFactories: Pointer; // GSList *
    engineSpecified: guint; // :1 The Rc file specified the engine
  end; // PWGObject; // ?


  // signal handler args weirdness (marshaller needs them)
  // add ONLY record or hell breaks loose

type
  PTGtkTreeIter = ^TGtkTreeIter;
  PTGtkRequisition = ^TGtkRequisition;
  PTGtkAllocation = ^TGtkAllocation;
  PTGtkTextIter = ^TGtkTextIter;

function gtk_tree_model_iter_n_children(model: PWGtkTreeModel; parent: PWGtkTreeIter): gint; cdecl; external gtklib;
procedure gtk_tree_path_free(path: PWGtkTreePath); cdecl; external gtklib;

const (* GtkWidgetFlags *)
  GTK_TOPLEVEL = 1 shl 4;
  GTK_NO_WINDOW = 1 shl 5;
  GTK_REALIZED = 1 shl 6;
  GTK_MAPPED = 1 shl 7;
  GTK_VISIBLE = 1 shl 8;
  (* DRAWABLE = VISIBLE & MAPPED *)
  GTK_SENSITIVE = 1 shl 9;
  GTK_PARENT_SENSITIVE = 1 shl 10;
  (* IS_SENSITIVE = SENSITIVE & PARENT_SENSITIVE *)
  GTK_CAN_FOCUS = 1 shl 11;
  GTK_HAS_FOCUS = 1 shl 12;
  GTK_CAN_DEFAULT = 1 shl 13;
  GTK_HAS_DEFAULT = 1 shl 14;
  GTK_HAS_GRAB = 1 shl 15;
  GTK_RC_STYLE = 1 shl 16;
  GTK_COMPOSITE_CHILD = 1 shl 17;
  GTK_NO_REPARENT = 1 shl 18; (* ?? *)
  GTK_APP_PAINTABLE = 1 shl 19;
  GTK_RECEIVES_DEFAULT = 1 shl 20;
  GTK_DOUBLE_BUFFERED = 1 shl 21;
  GTK_NO_SHOW_ALL = 1 shl 22; (* ?? *)

procedure GTK_WIDGET_SET_FLAGS(widget: PWGtkWidget; flags: gint);
function GTK_WIDGET_GET_FLAGS(widget: PWGtkWidget): gint;

function gtkWidgetFlagsToNative(flags: TGtkWidgetFlags): gint;
function gtkWidgetFlagsFromNative(nflags: gint): TGtkWidgetFlags;
function gtkAccelGroupEntryFromPointer(const group: PWGtkAccelGroupEntry): TGtkAccelGroupEntry;

(*$IFDEF USE_GTK26*)
procedure boo_gtk_about_dialog_set_authors(about: PWGtkAboutDialog;const authors: TUTF8StringArray); overload;
function boo_gtk_about_dialog_get_artists(about: PWGtkAboutDialog): TUTF8StringArray; overload;
procedure boo_gtk_about_dialog_set_documenters(about: PWGtkAboutDialog; const documenters: TUTF8StringArray); overload;
procedure boo_gtk_about_dialog_set_artists(about: PWGtkAboutDialog;const artists: TUTF8StringArray); overload;
function boo_gtk_about_dialog_get_authors(about: PWGtkAboutDialog): TUTF8StringArray; overload;
function boo_gtk_about_dialog_get_documenters(about: PWGtkAboutDialog): TUTF8StringArray; overload;
(*$ENDIF USE_GTK26*)

implementation
uses uimporttools;

procedure GTK_WIDGET_SET_FLAGS(widget: PWGtkWidget; flags: gint);
begin
  PWGtkObject(widget)^.flags := (PWGtkObject(widget)^.flags and 15) or flags;
end;

function GTK_WIDGET_GET_FLAGS(widget: PWGtkWidget): gint;
begin
  Result := PWGtkObject(widget)^.flags and 15;
end;

procedure widgetflagcheck2(var nflags: gint; flags: TGtkWidgetFlags; neg: Boolean; flag: TGtkWidgetFlag; nflag: gint);
begin
  if not neg then begin
    if flag in flags then
      nflags := nflags or nflag
    else
      nflags := nflags and not nflag;
  end else begin
    if not (flag in flags) then
      nflags := nflags or nflag
    else
      nflags := nflags and not nflag;
  end;
end;

procedure widgetflagcheck1(nflags: gint; var flags: TGtkWidgetFlags; neg: Boolean; flag: TGtkWidgetFlag; nflag: gint);
begin
  if not neg then begin
    if (nflags and nflag) <> 0 then
      Include(flags, flag)
    else
      Exclude(flags, flag);
  end else begin
    if (nflags and nflag) = 0 then
      Include(flags, flag)
    else
      Exclude(flags, flag);
  end;
end;

function gtkWidgetFlagsToNative(flags: TGtkWidgetFlags): gint;
var
  nflags: gint;
begin
  nflags := 0;

  widgetflagcheck1(nflags, flags, False, wfToplevel, GTK_TOPLEVEL);
  widgetflagcheck1(nflags, flags, True, wfWindow, GTK_NO_WINDOW);
  widgetflagcheck1(nflags, flags, False, wfRealized, GTK_REALIZED);
  widgetflagcheck1(nflags, flags, False, wfMapped, GTK_MAPPED);
  widgetflagcheck1(nflags, flags, False, wfVisible, GTK_VISIBLE);
  (* DRAWABLE = VISIBLE & MAPPED *)
  widgetflagcheck1(nflags, flags, False, wfSensitive, GTK_SENSITIVE);
  widgetflagcheck1(nflags, flags, False, wfParentSensitive, GTK_PARENT_SENSITIVE);
  (* IS_SENSITIVE = SENSITIVE & PARENT_SENSITIVE *)
  widgetflagcheck1(nflags, flags, False, wfCanFocus, GTK_CAN_FOCUS);
  widgetflagcheck1(nflags, flags, False, wfHasFocus, GTK_HAS_FOCUS);
  widgetflagcheck1(nflags, flags, False, wfCanDefault, GTK_CAN_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfHasDefault, GTK_HAS_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfHasGrab, GTK_HAS_GRAB);
  widgetflagcheck1(nflags, flags, False, wfRcStyle, GTK_RC_STYLE);
  widgetflagcheck1(nflags, flags, False, wfCompositeChild, GTK_COMPOSITE_CHILD);
  widgetflagcheck1(nflags, flags, True, wfReparent, GTK_NO_REPARENT);
  widgetflagcheck1(nflags, flags, False, wfAppPaintable, GTK_APP_PAINTABLE);
  widgetflagcheck1(nflags, flags, False, wfReceivesDefault, GTK_RECEIVES_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfDoubleBuffered, GTK_DOUBLE_BUFFERED);
  widgetflagcheck1(nflags, flags, True, wfInShowAllList, GTK_NO_SHOW_ALL);

  Result := nflags;
end;


function gtkWidgetFlagsFromNative(nflags: gint): TGtkWidgetFlags;
var
  flags: TGtkWidgetFlags;
begin
  flags := [];

  widgetflagcheck1(nflags, flags, False, wfToplevel, GTK_TOPLEVEL);
  widgetflagcheck1(nflags, flags, True, wfWindow, GTK_NO_WINDOW);
  widgetflagcheck1(nflags, flags, False, wfRealized, GTK_REALIZED);
  widgetflagcheck1(nflags, flags, False, wfMapped, GTK_MAPPED);
  widgetflagcheck1(nflags, flags, False, wfVisible, GTK_VISIBLE);
  (* DRAWABLE = VISIBLE & MAPPED *)
  widgetflagcheck1(nflags, flags, False, wfSensitive, GTK_SENSITIVE);
  widgetflagcheck1(nflags, flags, False, wfParentSensitive, GTK_PARENT_SENSITIVE);
  (* IS_SENSITIVE = SENSITIVE & PARENT_SENSITIVE *)
  widgetflagcheck1(nflags, flags, False, wfCanFocus, GTK_CAN_FOCUS);
  widgetflagcheck1(nflags, flags, False, wfHasFocus, GTK_HAS_FOCUS);
  widgetflagcheck1(nflags, flags, False, wfCanDefault, GTK_CAN_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfHasDefault, GTK_HAS_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfHasGrab, GTK_HAS_GRAB);
  widgetflagcheck1(nflags, flags, False, wfRcStyle, GTK_RC_STYLE);
  widgetflagcheck1(nflags, flags, False, wfCompositeChild, GTK_COMPOSITE_CHILD);
  widgetflagcheck1(nflags, flags, True, wfReparent, GTK_NO_REPARENT);
  widgetflagcheck1(nflags, flags, False, wfAppPaintable, GTK_APP_PAINTABLE);
  widgetflagcheck1(nflags, flags, False, wfReceivesDefault, GTK_RECEIVES_DEFAULT);
  widgetflagcheck1(nflags, flags, False, wfDoubleBuffered, GTK_DOUBLE_BUFFERED);
  widgetflagcheck1(nflags, flags, True, wfInShowAllList, GTK_NO_SHOW_ALL);
  Result := flags;
end;

(*$IFDEF USE_GTK26*)
(*$IFDEF gtk2q_standalone*)
procedure gtk_about_dialog_set_authors(about: PWGtkAboutDialog; {const} authors: PPgchar); cdecl; overload; external gtklib;
function gtk_about_dialog_get_artists(about: PWGtkAboutDialog): PPgchar; cdecl; overload; external gtklib;
procedure gtk_about_dialog_set_documenters(about: PWGtkAboutDialog; {const} documenters: PPgchar); cdecl; overload; external gtklib;
procedure gtk_about_dialog_set_artists(about: PWGtkAboutDialog; {const} artists: PPgchar); cdecl; overload; external gtklib;
function gtk_about_dialog_get_authors(about: PWGtkAboutDialog): PPgchar; cdecl; overload; external gtklib;
function gtk_about_dialog_get_documenters(about: PWGtkAboutDialog): PPgchar; cdecl; overload; external gtklib;
(*$ENDIF gtk2q_standalone*)

procedure boo_gtk_about_dialog_set_authors(about: PWGtkAboutDialog; const authors: TUTF8StringArray); overload;
var
  aglist: PPChar;
begin
  aglist := ArrayUTF8StringToPPchar(authors);
  gtk_about_dialog_set_authors(about, aglist);
  FreeMem(aglist);
end;

function boo_gtk_about_dialog_get_artists(about: PWGtkAboutDialog): TUTF8StringArray; overload;
var
  aglist: PPChar; (* const *)
begin
  aglist := gtk_about_dialog_get_artists(about);
  Result := PPcharToUTF8StringArray(aglist);
end;

procedure boo_gtk_about_dialog_set_documenters(about: PWGtkAboutDialog; const documenters: TUTF8StringArray); overload;
var
  aglist: PPChar;
begin
  aglist := ArrayUTF8StringToPPchar(documenters);
  gtk_about_dialog_set_documenters(about, aglist);
  FreeMem(aglist);
end;

procedure boo_gtk_about_dialog_set_artists(about: PWGtkAboutDialog;const artists: TUTF8StringArray); overload;
var
  aglist: PPChar;
begin
  aglist := ArrayUTF8StringToPPchar(artists);
  gtk_about_dialog_set_artists(about, aglist); FreeMem(aglist);
end;

function boo_gtk_about_dialog_get_authors(about: PWGtkAboutDialog): TUTF8StringArray; overload;
var
  aglist: PPChar; (* const *)
begin
  aglist := gtk_about_dialog_get_authors(about);
  Result := PPcharToUTF8StringArray(aglist);
end;

function boo_gtk_about_dialog_get_documenters(about: PWGtkAboutDialog): TUTF8StringArray; overload;
var
  aglist: PPChar; (* const *)
begin
  aglist := gtk_about_dialog_get_documenters(about);
  Result := PPcharToUTF8StringArray(aglist);
end;

(*$ENDIF USE_GTK26*)

function gtkAccelGroupEntryFromPointer(const group: PWGtkAccelGroupEntry): TGtkAccelGroupEntry;
begin
  Result := TGtkAccelGroupEntry(group^);
end;


end.
