unit ugtksourceviewtypes;

interface
uses iugtk, ugtksourcemarker;

type
  TGtkSourceMarker = TGtkTextMark;
  IGtkSourceMarker = IGtkTextMark;

  TGtkSourceTagStyleMask = set of (stmUseBackground = 0, stmUseForeground = 1);
                  
implementation

end.
