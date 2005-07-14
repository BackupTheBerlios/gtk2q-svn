unit uxfceguitypes;

interface
uses ugtypes;

const
  // DNetkWindowState
  wsMinimized = 1 shl 0;
  wsMaximizedHorizontally = 1 shl 1;
  wsMaximizedVertically = 1 shl 2;
  wsShaded = 1 shl 3;
  wsSkipPager = 1 shl 4;
  wsSkipTasklist = 1 shl 5;
  wsSticky = 1 shl 6;
  wsHidden = 1 shl 7;
  wsFullScreen = 1 shl 8;
  wsUrgent = 1 shl 9;
  
  // DNetkWindowActions
  waMove = 1 shl 0;
  waResize = 1 shl 1;
  waShade = 1 shl 2;
  waStick = 1 shl 3;
  waMaximizeHorizontally = 1 shl 4;
  waMaximizeVertically = 1 shl 5;
  waChangeWorkspace = 1 shl 6; (* includes pin/unpin *)
  waClose = 1 shl 7;
  waUnmaximizeHorizontally = 1 shl 8;
  waUnmaximizeVertically = 1 shl 9;
  waUnshade = 1 shl 10;
  waUnstick = 1 shl 11;
  waMinimize = 1 shl 12;
  waUnminimize = 1 shl 13;
  waMaximize = 1 shl 14;
  waUnmaximize = 1 shl 15;

type
  DNetkWindowState = gint;
  DNetkWindowActions = gint;
  DNetkWindowType = (wtNormal, wtDesktop, wtDock, wtDialog, wtModalDialog,
    wtToolbar, wtMenu, wtUtility, wtSplashScreen);

implementation


end.
