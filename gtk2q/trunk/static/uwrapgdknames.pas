unit uwrapgdknames;

// contains lowlevel stuff only
// (some weird types it needs for importing and I dont)

interface
uses ugdktypes, ugtypes, uwrapgnames;

{$INCLUDE clinksettings.inc}

const
(*$IFDEF WIN32*)
  gdklib = 'libgdk-win32-2.0-0.dll'; (* non-windows: without .dll *)
(*$ELSE*)
  gdklib = 'libgdk-x11-2.0.so';
(*$ENDIF WIN32*)

type
  PWGdkColor = ^WGdkColor;
  WGdkColor = TGdkColor;
  PWGdkScreen = PWGObject;
  PWGdkColormap = PWGObject;
  PWGdkDevice = PWGObject;
  PWGdkDrawable = PWGObject;
  PWGdkWindow = PWGObject;
  
  PWGdkXEvent = PWGObject;
  PWGdkPixmap = PWGObject;
  PWGdkBitmap = PWGdkPixmap; (* hmm *)
  PWGdkVisual = PWGObject;
  PWGdkDisplay = PWGObject;
  PWGdkImage = PWGObject;
  PWGdkDragContext = PWGObject;
  PWGdkRegion = gpointer; // ?

  PWGdkPixbuf = PWGObject;

  PWGdkFont = Pointer;
  PWGdkCursor = Pointer;
  
  PWGdkDisplayManager = PWGObject;
  PWGdkGc = PWGObject;
  WGdkPointArray = TGdkPointArray;
  
  WGdkNativeWindow = gpointer; (* or guint32 with GDK_NATIVE_WINDOW_POINTER = FALSE *)

type
  PWGdkRectangle = ^WGdkRectangle;
  WGdkRectangle = record
    x,y, width, height: gint;
  end;

type
  WGdkAtom = gpointer; (*ulong;*) (* ??? *)
    
type
  (* enum pointers *)
  PWGdkWMDecoration = ^WGdkWMDecoration;
  PWGdkModifierType = ^WGdkModifierType;
  PWGdkDragProtocol = ^WGdkDragProtocol;

  (* enums *)
  WGdkCrossingMode = gint;
  WGdkNotifyType = gint;
  WGdkSettingAction = gint;
  
  WGdkAxisUse = gint;
  WGdkCapStyle = gint;
  WGdkCursorType = gint;
  WGdkDragAction = gint;
  (* WGdkDragProtocol unused *)
  WGdkEventMask = gint;
  WGdkExtensionMode = gint;
  WGdkFill = gint;
  WGdkFillRule = gint;
  WGdkFunction = gint;
  WGdkGravity = gint;
  WGdkImageType = gint;
  WGdkInputMode = gint;
  WGdkInputSource = gint;
  WGdkJoinStyle = gint;
  WGdkLineStyle = gint;
  WGdkModifierType = gint;
  WGdkOverlapType = gint;
  WGdkVisualType = gint;
  WGdkWindowEdge = gint;
  WGdkWindowState = gint;
  WGdkWindowType = gint;
  WGdkWindowTypeHint = gint;
  WGdkWMDecoration = gint;
  WGdkWMFunction = gint;
  WGdkRgbDither = gint;
  WGdkDragProtocol = gint;
  WGdkVisibilityState = gint;
  WGdkScrollDirection = gint;
  (* end enums *)

type
  WGdkEventType = gint;
  PWGdkEvent = gpointer;
  PWGdkEventAny = ^WGdkEventAny;
  WGdkEventAny = record
    typ: WGdkEventType;
    window: PWGdkWindow;
    sendEvent: gint8;
  end;
  (* Setting, State, DND *)

type
  PWGdkEventExpose = ^WGdkEventExpose;
  WGdkEventExpose = record
    any: WGdkEventAny;
    area: WGdkRectangle;
    region: PWGdkRegion;
    count: gint; (* if non-zero, how many more events follow *)
  end;

type
  PWGdkEventNoExpose = ^WGdkEventNoExpose;
  WGdkEventNoExpose = record
    any: WGdkEventAny;
  end;
  
type
  PWGdkEventVisibility = ^WGdkEventVisibility;
  WGdkEventVisibility = record
    any: WGdkEventAny;
    state: WGdkVisibilityState;
  end;
  
type
  PWGdkEventButton = ^WGdkEventButton;
  WGdkEventButton = record
    any: WGdkEventAny;
    time: guint32;
    x,y: gdouble;
    axes: PWGDouble; (* ugh *)
    state: guint;
    button: guint;
    device: PWGdkDevice;
    xRoot,yRoot: gdouble;
  end;

type
  PWGdkEventMotion = ^WGdkEventMotion;
  WGdkEventMotion = record
    any: WGdkEventAny;
    time: guint32;
    x,y: gdouble;
    axes: PWgdouble; (* ugh *)
    state: guint;
    isHint: gint16;
    device: PWGdkDevice;
    xRoot, yRoot: gdouble;
  end;
  
type
  PWGdkEventScroll = ^WGdkEventScroll;
  WGdkEventScroll = record
    any: WGdkEventAny;
    time: guint32;
    x,y: gdouble;
    state: guint;
    direction: WGdkScrollDirection;
    device: PWGdkDevice;
    xRoot, yRoot: gdouble;
  end;

type 
  PWGdkEventKey = ^WGdkEventKey;
  WGdkEventKey = record
    any: WGdkEventAny;
    time: guint32;
    state: guint;
    keyval: guint;
    length1: gint;
    string1: PGChar;
    hardwareKeycode: guint16;
    group: guint8;
  end;

type
  PWGdkEventCrossing = ^WGdkEventCrossing;
  WGdkEventCrossing = record
    any: WGdkEventAny;
    subwindow: PWGdkWindow;
    time: guint32;
    x,y,xRoot,yRoot: gdouble;
    mode: WGdkCrossingMode;
    detail: WGdkNotifyType;
    focus: gboolean;
    state: guint;
  end;
  
type
  PWGdkEventFocus = ^WGdkEventFocus;
  WGdkEventFocus = record
    any: WGdkEventAny;
    in1: gint16;
  end;

type
  PWGdkEventConfigure = ^WGdkEventConfigure;
  WGdkEventConfigure = record
    any: WGdkEventAny;
    x,y: gint;
    width, height: gint;
  end;

type
  PWGdkEventProperty = ^WGdkEventProperty;
  WGdkEventProperty = record
    any: WGdkEventAny;
    atom: WGdkAtom;
    time: guint32;
    state: guint;
  end;    

type
  PWGdkEventSelection = ^WGdkEventSelection;
  WGdkEventSelection = record
    any: WGdkEventAny;
    selection, target, property1: WGdkAtom;
    time: guint32;
    requestor: WGdkNativeWindow;
  end;

type
  PWGdkEventProximity = ^WGdkEventProximity;
  WGdkEventProximity = record
    any: WGdkEventAny;
    time: guint32;
    device: PWGdkDevice;
  end;

type
  PWGdkEventClient = ^WGdkEventClient;
  WGdkEventClient = record
    any: WGdkEventAny;
    messageType: WGdkAtom;
    dataFormat: gushort;
    (* 20 byte data *)
    d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20: Byte;
  end;
  
type
  PWGdkEventSetting = ^WGdkEventSetting;
  WGdkEventSetting = record
    any: WGdkEventAny;
    action: WGdkSettingAction;
    name: PChar;
  end;

type
  PWGdkEventWindowState = ^WGdkEventWindowState;
  WGdkEventWindowState = record
    any: WGdkEventAny;
    changedMask: WGdkWindowState;
    newWindowState: WGdkWindowState;
  end;
  
type
  PWGdkEventDnd = ^WGdkEventDnd;
  WGdkEventDnd = record
    any: WGdkEventAny;
    context: PWGdkDragContext;
    time: guint32;
    xRoot, yRoot: gshort;
  end;
  
type
  PWGdkPoint = ^TGdkPoint;
  PWGdkSegment = ^TGdkSegment;

  WGdkColorArray = TGdkColorArray;

  WGdkSpanArray = TGdkSpanArray;

type
  WGdkSpanFunc = TGdkSpanFunc;
  WGdkFilterFunc = TGdkFilterFunc; //function(xevent: PWGdkXEvent; event: PGdkEvent; data: gpointer): TGdkFilterReturn; cdecl;


type (* gdkgc *)
   (* only needed to simulate property readers *)
   PWGdkSubwindowMode = ^WGdkSubwindowMode;
   WGdkSubwindowMode = gint; // see below for possible values

   PWGdkGCValuesMask = ^WGdkGCValuesMask;
   WGdkGCValuesMask = longint; // see below for possible values

   (*(
     GDK_SOLID,
     GDK_TILED,
     GDK_STIPPLED,
     GDK_OPAQUE_STIPPLED
   );*)
   (*
     GDK_LINE_SOLID,
     GDK_LINE_ON_OFF_DASH,
     GDK_LINE_DOUBLE_DASH
     *)
   (*
     GDK_JOIN_MITER,
     GDK_JOIN_ROUND,
     GDK_JOIN_BEVEL
     *)
   (*
     GDK_CAP_NOT_LAST,
     GDK_CAP_BUTT,
     GDK_CAP_ROUND,
     GDK_CAP_PROJECTING
   *)
   (*
     GDK_COPY, GDK_INVERT, GDK_XOR, GDK_CLEAR,
     GDK_AND, GDK_AND_REVERSE, GDK_AND_INVERT,
     GDK_NOOP, GDK_OR, GDK_EQUIV, GDK_OR_REVERSE,
     GDK_COPY_INVERT, GDK_OR_INVERT, GDK_NAND,
     GDK_NOR, GDK_SET
   *)

   PWGdkGCValues = ^WGdkGCValues;
   WGdkGCValues = record
        foreground : WGdkColor;
        background : WGdkColor;
        font : PWGdkFont;
        _function : WGdkFunction;
        fill : WGdkFill;
        tile : PWGdkPixmap;
        stipple : PWGdkPixmap;
        clip_mask : PWGdkPixmap;
        subwindow_mode : WGdkSubwindowMode;
        ts_x_origin : gint;
        ts_y_origin : gint;
        clip_x_origin : gint;
        clip_y_origin : gint;
        graphics_exposures : gint;
        line_width : gint;
        line_style : WGdkLineStyle;
        cap_style : WGdkCapStyle;
        join_style : WGdkJoinStyle;
     end;

   // signal marshallers need that:
  // signal handler args weirdness (marshaller needs them)
  // add ONLY record or hell breaks loose
  
type
  PTGdkEventSelection = ^TGdkEventSelection;
  PTGdkEventFocus = ^TGdkEventFocus;
  PTGdkEvent = ^TGdkEvent;
  PTGdkEventMotion = ^TGdkEventMotion;
  PTGdkEventKey = ^TGdkEventKey;
  PTGdkEventCrossing = ^TGdkEventCrossing;
  PTGdkEventNoExpose = ^TGdkEventNoExpose;
  PTGdkEventProximity = ^TGdkEventProximity;
  PTGdkEventProperty = ^TGdkEventProperty;
  PTGdkEventButton = ^TGdkEventButton;
  PTGdkEventClient = ^TGdkEventClient;
  PTGdkEventConfigure = ^TGdkEventConfigure;
  PTGdkEventExpose = ^TGdkEventExpose;

function gdk_colormap_get_type: TGType; cdecl; // hack
function gdk_device_get_type: TGType; cdecl; // hack
function gdk_window_get_type: TGType; cdecl; // hack
function gdk_display_get_core_pointer(display: PWGdkDisplay): PWGdkDevice; cdecl;

function GdkNextRectangle(rectangle: PWGdkRectangle): PWGdkRectangle; (* no bounds check *)

function gdk_pointer_grab(window: PWGdkWindow; ownerevents: gboolean; eventmask: WGdkEventMask;
  confineTo: PWGdkWindow; cursor: Pointer{PWGdkCursor}; time: guint32): TGdkGrabStatus; cdecl;
procedure gdk_pointer_ungrab(time: guint32); cdecl;
function gdk_pointer_is_grabbed: gboolean; cdecl;

function gdk_keyboard_grab(window: PWGdkWindow; ownerevents: gboolean; time: guint32): TGdkGrabStatus; cdecl;
procedure gdk_keyboard_ungrab(time: guint32); cdecl;

implementation

{$INCLUDE clinksettings.inc}

function gdk_colormap_get_type: TGType; cdecl; // hack
begin
  Result := 0;
end;

function gdk_device_get_type: TGType; cdecl; // hack
begin
  Result := 0;
end;

function gdk_pointer_grab(window: PWGdkWindow; ownerevents: gboolean; eventmask: WGdkEventMask;
  confineTo: PWGdkWindow; cursor: PWGdkCursor; time: guint32): TGdkGrabStatus; cdecl; external gdklib;
procedure gdk_pointer_ungrab(time: guint32); cdecl; external gdklib;
function gdk_pointer_is_grabbed: gboolean; cdecl; external gdklib;

function gdk_keyboard_grab(window: PWGdkWindow; ownerevents: gboolean; time: guint32): TGdkGrabStatus; cdecl; external gdklib;
procedure gdk_keyboard_ungrab(time: guint32); cdecl; external gdklib;

// error_trap_push/error_trap_pop/set_double_click_time/gdk_beep/gdk_flush  ?

function gdk_window_get_type: TGType; cdecl; external gdklib name 'gdk_drawable_get_type';

function gdk_display_get_core_pointer(display: PWGdkDisplay): PWGdkDevice; cdecl; external gdklib;

(*$IFDEF FPC*)
function GdkNextRectangle(rectangle: PWGdkRectangle): PWGdkRectangle; (* no bounds check *)
begin
  Result := rectangle;
  Inc(Result);
end;
(*$ELSE*)
function GdkNextRectangle(rectangle: PWGdkRectangle): PWGdkRectangle; (* no bounds check *)
asm
  mov edx, rectangle
  add edx, dword ptr sizeof(WGdkRectangle)
  mov Result, edx
end;
(*$ENDIF*)

end.
