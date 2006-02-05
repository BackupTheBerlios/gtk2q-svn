
{$ifdef define_types}
type
  IPangoGlyphItem = interface;
  IPangoLayoutRun = IPangoGlyphItem;
  IPangoLayoutLine = interface;
{$endif define_types}
{$INCLUDE iupangolayoutiter.inc}
{$INCLUDE iupangolayoutline.inc}
{$INCLUDE iupangoglyphitem.inc}
{$INCLUDE ../output/pango/iupangolayout.inc}
