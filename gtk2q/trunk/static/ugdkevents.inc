// needs includer to static/clinksettings.inc

type
  TGdkEventType = (evDelete, evDestroy, evExpose, evMotionNotify,
    evButtonPress, ev2ButtonPress, ev3ButtonPress, evButtonRelease,
    evKeyPress, evKeyRelease, evEnterNotify, evLeaveNotify,
    evFocusChange, evConfigure, evMap, evUnmap, evPropertyNotify,
    evSelectionClear, evSelectionRequest, evSelectionNotify,
    evProximityIn, evProximityOut, evDragEnter, evDragLeave,
    evDragMotion, evDragStatus, evDropStart, evDropFinished,
    evClientEvent, evVisibilityNotify, evNoExpose, evScroll,
    evWindowState, evSetting); // etNothing = -1 .. well doesnt happen
 
  PTGdkEventAny = ^TGdkEventAny;
  TGdkEventAny = record
    type1: TGdkEventType;
    window: Pointer; // GdkWindow
    SendEvent: gint8;
  end;
  PTGdkEventExpose = ^TGdkEventExpose;
  TGdkEventExpose = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    area: TGdkRectangle;
    region: Pointer; // GdkRegion
    count: Integer; // if non-zero, how many more events follow
  end;
  PTGdkEventNoExpose = ^TGdkEventNoExpose;
  TGdkEventNoExpose = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
  end;
  PTGdkEventVisibility = ^TGdkEventVisibility;
  TGdkEventVisibility = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    State: TGdkVisibilityState;
  end;
  PTGdkEventMotion = ^TGdkEventMotion;
  TGdkEventMotion = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    time: guint32;
    x,y: Double;
    axes: Pointer; // pointer to doubles
    State: guint;
    is_hint: gint16;
    device: Pointer; // GdkDevice
    x_root, y_root: Double;
  end;
  PTGdkEventButton = ^TGdkEventButton;
  TGdkEventButton = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    time: guint32;
    x,y: Double;
    axes: Pointer; // pointer to doubles
    State: guint;
    button: GUInt;
    device: Pointer; // GdkDevice
    x_root, y_root: Double;
  end;
  PTGdkEventScroll = ^TGdkEventScroll;
  TGdkEventScroll = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    time: guint32;
    x,y: Double;
    State: GUInt;
    direction: TGdkScrollDirection;
    device: Pointer; // GdkDevice
    x_root, y_root: Double;
  end;
  PTGdkEventKey = ^TGdkEventKey;
  TGdkEventKey = record
    type1: TGdkEventType;
    window: Pointer;
    sendEvent: gint8;
    time: guint32;
    State: GUInt;
    keyval: GUInt;
    Length1: GInt;
    String1: PChar;
    HardwareKeycode: GUInt16;
    Group: GUint8;
  end;
  PTGdkEventCrossing = ^TGdkEventCrossing;
  TGdkEventCrossing = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    subwindow: Pointer; // GdkWindow
    time: GUInt32;
    x,y,x_root,y_root: Double;
    mode: TGdkCrossingMode;
    detail: TGdkNotifyType;
    focus: gboolean;
    State: GUint;
  end;
  PTGdkEventFocus = ^TGdkEventFocus;
  TGdkEventFocus = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    In1: GInt16;
  end;
  PTGdkEventConfigure = ^TGdkEventConfigure;
  TGdkEventConfigure = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    x,y,width,height: GInt;
  end;
  PTGdkEventProperty = ^TGdkEventProperty;
  TGdkEventProperty = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    atom: TGdkAtom;
    time: GUInt32;
    state: GUInt;
  end;
  PTGdkEventSelection = ^TGdkEventSelection;
  TGdkEventSelection = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    selection: TGdkAtom;
    target: TGdkAtom;
    propert: TGdkAtom;
    time: GUInt32;
    requestion: TGdkNativeWindow;
  end;
  PTGdkEventProximity = ^TGdkEventProximity;
  TGdkEventProximity = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    time: GUInt32;
    device: Pointer; // GdkDevice
  end;
  PTGdkEventClient = ^TGdkEventClient;
  TGdkEventClient = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    MessageType: TGdkAtom;
    DataFormat: GUInt16; // 'GUshort'
    //char b[20]; short s[10]; long l[5]; here!
    Data: array[0..9] of char; // NOT! FIXME
  end;
  PTGdkEventSetting = ^TGdkEventSetting;
  TGdkEventSetting = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    Action: TGdkSettingAction;
    Name: PChar;
  end;
  PTGdkEventWindowState = ^TGdkEventWindowState;
  TGdkEventWindowState = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    ChangedMask: TGdkWindowState;
    NewWindowState: TGdkWindowState;
  end;
  PTGdkEventDND = ^TGdkEventDND;
  TGdkEventDND = record
    type1: TGdkEventType;
    window: Pointer;
    SendEvent: gint8;
    context: Pointer; //GdkDragContext
    time: GUInt32;
    x_root, y_root: GShort;
  end;
  PTGdkEvent = ^TGdkEvent;
  TGdkEvent = record
    case longint of
      0: (Type1: TGdkEventType;);
      1: (Any: TGdkEventAny;);
      2: (Expose: TGdkEventExpose;);
      3: (NoExpose: TGdkEventNoExpose;);
      4: (Visibility: TGdkEventVisibility;);
      5: (Motion: TGdkEventMotion;);
      6: (Button: TGdkEventButton;);
      7: (Scroll: TGdkEventScroll;);
      8: (Key: TGdkEventKey;);
      9: (Focus: TGdkEventFocus;);
      10:(Crossing: TGdkEventCrossing;);
      11:(Configure: TGdkEventConfigure;);
      12:(Property1: TGdkEventProperty;);
      13:(Selection: TGdkEventSelection;);
      14:(Proximity: TGdkEventProximity;);
      15:(Client: TGdkEventClient;);
      16:(DND: TGdkEventDND;);
      17:(Setting: TGdkEventSetting;);
    end;


