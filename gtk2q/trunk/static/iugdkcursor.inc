(*$IFDEF define_consts*)
  cuXCursor = 0;
  cuArrow = 2;
  cuBasedArrowDown = 4;
  cuBasedArrowUp = 6;
  cuBoat = 8;
  cuBogosity = 10;
  cuBottomLeftCorner = 12;
  cuBottomRightCorner = 14;
  cuBottomSide = 16;
  cuBottomTee = 18;
  cuBoxSpiral = 20;
  cuCenterPtr = 22;
  cuCircle = 24;
  cuClock = 26;
  cuCoffeeMug = 28;
  cuCross = 30;
  cuCrossReverse = 32;
  cuCrosshair = 34;
  cuDiamondCross = 36;
  cuDot = 38;
  cuDotBox = 40;
  cuDoubleArrow = 42;
  cuDraftLarge = 44;
  cuDraftSmall = 46;
  cuDrapedBox = 48;
  cuExchange = 50;
  cuFleur = 52;
  cuGobbler = 54;
  cuGumby = 56;
  cuHand1 = 58;
  cuHand2 = 60;
  cuHeart = 62;
  cuIcon = 64;
  cuIronCross = 66;
  cuLeftPtr = 68;
  cuLeftSide = 70;
  cuLeftTee = 72;
  cuLeftButton = 74;
  cuLlAngle = 76;
  cuLrAngle = 78;
  cuMan = 80;
  cuMiddleButton = 82;
  cuMouse = 84;
  cuPencil = 86;
  cuPirate = 88;
  cuPlus = 90;
  cuQuestionArrow = 92;
  cuRightPtr = 94;
  cuRightSide = 96;
  cuRightTee = 98;
  cuRightButton = 100;
  cuRtlLogo = 102;
  cuSailboat = 104;
  cuSbDownArrow = 106;
  cuSbHDoubleArrow = 108;
  cuSbLeftArrow = 110;
  cuSbRightArrow = 112;
  cuSbUpArrow = 114;
  cuSbVDoubleArrow = 116;
  cuShuttle = 118;
  cuSizing = 120;
  cuSpider = 122;
  cuSpraycan = 124;
  cuStar = 126;
  cuTarget = 128;
  cuTCross = 130;
  cuTopLeftArrow = 132;
  cuTopLeftCorner = 134;
  cuTopRightCorner = 136;
  cuTopSide = 138;
  cuTopTee = 140;
  cuTrek = 142;
  cuUlAngle = 144;
  cuUmbrella = 146;
  cuUrAngle = 148;
  cuWatch = 150;
  cuXTerm = 152;
  cuLastCursor = 153;
  cuCursorIsPixmap = -1;

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  TGdkCursorType = Integer; // I'd call that shape but ... thinking compability
  IGdkCursor = interface
    function GetUnderlying: Pointer; // eek...
    function getCursorType: TGdkCursorType;
    function getDisplay: IGdkDisplay;
    property CursorType: TGdkCursorType read getCursorType;
    property Display: IGdkDisplay read getDisplay;
  end;
(*$ENDIF define_types*)

