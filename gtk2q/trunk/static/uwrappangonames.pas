unit uwrappangonames;

interface
uses uwrapgnames, upangotypes, ugobject, ugtypes;

const
(*$IFDEF WIN32*)
  pangolib = 'libpango-1.0-0.dll';
(*$ELSE*)
  pangolib = 'libpango-1.0.so';
(*$ENDIF WIN32*)

const
  fmFamily = 1 shl 0;
  fmStyle = 1 shl 1;
  fmVariant = 1 shl 2;
  fmWeight = 1 shl 3;
  fmStretch = 1 shl 4;
  fmSize = 1 shl 5;

type
  WPangoFontMask = gint;

  (* enums *)
  WPangoStyle = gint;
  WPangoVariant = gint;
  WPangoWeight = gint;
  WPangoUnderline = gint;
  WPangoStretch = gint;
  WPangoAlignment = gint;
  WPangoWrapMode = gint;
  WPangoDirection = gint;
  WPangoCoverageLevel = gint;
  (* end enums *)

  PWPangoFontDescription = Pointer;
  PWPangoLanguage = Pointer;

  PWPangoFontMetrics = ^WPangoFontMetrics;
  WPangoFontMetrics = record (* C *)
    RefCount: guint;
    
    Ascent: gint;
    Descent: gint;
    ApproximateCharWidth: gint;
    ApproximateDigitWidth: gint;
    UnderlinePosition: gint;
    UnderlineThickness: gint;
    StrikethroughPosition: gint;
    StrikethroughThickness: gint;
  end;

  PPWPangoFontFamily = ^PWPangoFontFamily;
  PPPWPangoFontFamily = ^PPWPangoFontFamily;
  PWPangoFontFamily = Pointer;
  
  PPPWPangoFontFace = ^PPWPangoFontFace;
  PPWPangoFontFace = ^PWPangoFontFace;
  PWPangoFontFace = Pointer;
  
  PWPangoFont = Pointer;
  PWPangoFontset = Pointer;
  
  PWPangoCoverage = Pointer;
  
  PWPangoContext = Pointer;
  PWPangoFontMap = Pointer;
  PWPangoMatrix = ^WPangoMatrix;
  WPangoMatrix = record (* C *)
    xx, xy, yx, yy, x0, y0: gdouble;
  end;
  
  WPangoGlyph = guint32;
  PWPangoRectangle = ^WPangoRectangle;
  WPangoRectangle = record (* C *)
    x,y, width, height: gint; (* actually int *)
  end;
  
  PWPangoEngineShape = Pointer;
  
implementation

end.
