unit ugdkpixbuftypes;

interface
uses ugtypes, uwrapgnames;

{$INCLUDE static/clinksettings.inc}

type
  TGdkPixbufModulePattern = record
    prefix: PChar;
    mask: PChar;
    Relevance: Integer;
  end;

  (* dont.
  TGdkPixbufFormat = record
    name: PChar;
    signature: TGdkPixbufModulePattern;
    domain, description: PChar;
    MimeTypes: PPChar;
    Extensions: PPChar;
    flags: GUInt32;
  end;
  *)
  
  TGdkColorspace = (csRGB);

  (* sigh ... fixme *)
  TGdkPixbufSaveFunc = function(buf: Pointer; count: gsize; error: PPWGError; pixbuf: Pointer): gboolean; cdecl;
  TGdkInterpType = (inNearest, inTiles, inBilinear, inHyper);  

implementation

end.
