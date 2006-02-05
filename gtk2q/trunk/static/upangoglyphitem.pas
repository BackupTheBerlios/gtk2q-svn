unit upangoglyphitem;

interface
uses iupointermediator, iupango, upointermediator;

// Pair of PangoItem and a glyph string

type 
  TPangoGlyphItem = class(TPointerMediator, IPangoGlyphItem, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    // TODO
    
    // Split?
    // ApplyAttrs?
    // LetterSpace?
  end;
  
  TPangoLayoutRun = TPangoGlyphItem; // backwards compat.
  
implementation
uses uwrapgnames, uwrappangonames, ugtypes;

// TODO

function pango_glyph_item_split(orig: PWPangoGlyphItem; text: PChar; splitIndex: gint): PWPangoGlyphItem; cdecl; external pangolib;
procedure pango_glyph_item_free(glyphItem: PWPangoGlyphItem); cdecl; external pangolib;
function pango_glyph_item_apply_attrs  (glyphItem: PWPangoGlyphItem;
                                        text: PChar; list: PWPangoAttrList): PWGSList; cdecl; external pangolib;
procedure pango_glyph_item_letter_space (glyphItem: PWPangoGlyphItem;
                                               text: PChar;
                                               logAttrs: PWPangoLogAttr;
                                               letterSpacing: gint); cdecl; external pangolib;

constructor TPangoGlyphItem.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_glyph_item_free);
end;

end.
