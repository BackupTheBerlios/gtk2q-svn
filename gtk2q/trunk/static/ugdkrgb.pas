unit ugdkrgb;

interface
uses ugtypes;

type
  TGdkRgbColor = guint32; (* made that up *)

function RGBA(r,b,g: Byte; a: Byte = 255): TGdkRgbColor;

implementation

function RGBA(r,b,g: Byte; a: Byte = 255): TGdkRgbColor;
begin
  Result := (a shl 24) or (g shl 16) or (b shl 8) or r;
end;

end.
