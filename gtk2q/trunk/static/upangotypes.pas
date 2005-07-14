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

implementation

end.
 