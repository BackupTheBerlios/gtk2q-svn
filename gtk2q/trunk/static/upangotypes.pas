unit upangotypes;

interface
uses ugtypes;

const
  // TPangoWeight, not really an enumeration but that are some usual values
  pwUltralight = 200;
  pwLight = 300;
  pwNormal = 400;
  pwBold = 700;
  pwUltrabold = 800;
  pwHeavy = 900;

type
  TPangoStyle = (psNormal, psOblique, psItalic);
  TPangoVariant = (pvNormal, pvSmallCaps);
  TPangoWeight = Integer;
  TPangoUnderline = (puNone, puSingle, puDouble, puLow, puError);
  TPangoStretch = (stUltraCondensed, stExtraCondensed,
  stCondensed, stSemiCondensed, stNormal, stSemiExpanded,
  stExpanded, stExtraExpanded, stUltraExpanded
  );
{  TPangoFontDescription = record
    FamilyName: PChar;
    Style: TPangoStyle;
    Variant: TPangoVariant;
    Weight: TPangoWeight;
    Stretch: TPangoStretch;
    mask: GUint16;
    StaticFamily: GUint; // FIXME guint:1;
    Size: Integer;
  end;}
  TPangoAlignment = (paLeft, paCenter, paRight);
  TPangoEllipsizeMode = (elNone, elStart, elMiddle, elEnd);
  
  TPangoMatrix = record (* C *)
    xx, xy, yx, yy, x0, y0: Double;
  end;
  
  TPangoLanguage = type Pointer; // kind of a handle
  
  TPangoDirection = (
    pdLeftToRight,
    pdRightToLeft,
    pdTTBLeftToRight, (* ?? *)
    pdTTBRightToLeft,
    pdWeakLeftToRight,
    pdWeakRightToLeft,
    pdNE (* ? *)
  );

  TPangoCoverageLevel = (
    clNone,
    clFallback,
    clApproximate,
    clExact
  );
  
  TPangoGlyph = guint32; // handle

  TPangoRectangle = record
    x,y,width,height: gint;
  end;

  TPangoFontSizeArray = array of Integer;
  TPangoRangeArray = array of Integer;
  
  TPangoWrapMode = (wmWord, wmChar, wmWordChar);
  TPangoTabAlign = (taLeft
   (* , taRight, taCenter, taNumeric *)
  );
  
implementation

end.
 