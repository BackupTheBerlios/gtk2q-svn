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
  (* end enums *)

  PWPangoFontDescription = Pointer;

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
  
implementation

end.
