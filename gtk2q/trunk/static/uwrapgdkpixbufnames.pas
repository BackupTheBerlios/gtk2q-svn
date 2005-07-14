unit uwrapgdkpixbufnames;

interface
uses uwrapgdknames, uwrapgnames, ugtypes, ugdkpixbuftypes;

const
(*$IFDEF WIN32*)
  gdkpixbuflib = 'libgdk_pixbuf-2.0-0.dll';
(*$ELSE*)
  gdkpixbuflib = 'libgdk_pixbuf-2.0.so';
(*$ENDIF WIN32*)

type
  PWGdkPixbufAnimationIter = Pointer;
  PWGdkPixbufAnimation = Pointer; (* not quite gobject *)
  PWGdkPixbufLoader = PWGObject;
  PWGdkPixbuf = PWGObject;
  Pguchar = Pointer; (* grr C weirdness: that is a buffer type *)

type
  (* enums *)
  WGdkInterpType = gint;
  WGdkColorspace = gint;
  (* end enums *)

type
  WGdkPixbufSaveFunc = function(buf: Pointer; count: gsize; error: PPWGError; pixbuf: Pointer): gboolean; cdecl;
  PWGdkPixbufFormat = gpointer;

procedure HelperTGdkPixbufOptions(options: TUTF8StringArray; out optionkeys, optionvalues: PPChar);

implementation

procedure HelperTGdkPixbufOptions(options: TUTF8StringArray; out optionkeys, optionvalues: PPChar);
var
  l2: Integer;
  i: Integer;
  xoptionkeys: PPChar;
  xoptionvalues: PPChar;
begin
  l2 := (Length(options) div 2);
  assert(l2 * 2 = Length(options));

  optionkeys := g_new0(sizeof(PChar), l2 + 1);
  optionvalues := g_new0(sizeof(PChar), l2 + 1);
  xoptionkeys := optionkeys;
  xoptionvalues := optionvalues;

  for i := 0 to l2 - 1 do begin
    xoptionkeys^ := PChar(g_strdup(PGChar(PChar(options[i * 2]))));
    xoptionvalues^ := PChar(g_strdup(PGChar(PChar(options[i * 2 + 1]))));
    Inc(xoptionkeys);
    Inc(xoptionvalues);
 end;
end;

end.
 