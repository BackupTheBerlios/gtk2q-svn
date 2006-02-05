unit upangoglyphitem;

interface
uses iupointermediator, iupango, upointermediator;

// Pair of PangoItem and a glyph string

type 
  TPangoGlyphItem = class(TPointerMediator, IPangoGlyphItem, IPointerMediator, IInvokable, IInterface)
  protected
    fIter: IPangoLayoutIter; (* pin down the iter *)
  public
    constructor CreateWrappedPinned(ptr: Pointer; iter: IPangoLayoutIter);
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

constructor TPangoGlyphItem.CreateWrappedPinned(ptr: Pointer; iter: IPangoLayoutIter);
begin
  fIter := iter;
  inherited Create(ptr, nil); // I dont own it so I dont free it either. @pango_glyph_item_free);
end;

end.
