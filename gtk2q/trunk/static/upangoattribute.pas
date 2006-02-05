unit upangoattribute;

interface
uses upointermediator, iupointermediator, iupango, upangotypes;

{$M+}

type
  TPangoAttribute = class(TPointerMediator, IPangoAttribute, IPointerMediator, IInvokable, IInterface)
  protected
    fAttributeList: IPangoAttrList; // FIXME can one attribute be in multiple lists?
  public
    constructor CreateWrappedCopy(ptr: Pointer);
    constructor CreateWrappedPinned(ptr: Pointer; attributelist: IPangoAttrList);
    constructor CreateNew(ptr: Pointer);
  published
    constructor CreateLanguageAttribute(language: TPangoLanguage);
    constructor CreateFamilyAttribute(family: string);
    constructor CreateForegroundAttribute(red, green, blue: Word);
    constructor CreateBackgroundAttribute(red, green, blue: Word);
    constructor CreateSizeAttribute(size: Integer);
    constructor CreateAbsoluteSizeAttribute(absoluteSize: Integer);
    constructor CreateStyleAttribute(style: TPangoStyle);
    constructor CreateWeightAttribute(weight: TPangoWeight);
    constructor CreateVariantAttribute(avariant: TPangoVariant);
    constructor CreateStretchAttribute(stretch: TPangoStretch);
    constructor CreateFontDescriptionAttribute(description: IPangoFontDescription);
    constructor CreateUnderlineAttribute(underline: TPangoUnderline);
    constructor CreateUnderlineColorAttribute(red, green, blue: Word);
    constructor CreateStrikethroughAttribute(strikethrough: Boolean);
    constructor CreateStrikethroughColorAttribute(red, green, blue: Word);
    constructor CreateRiseAttribute(rise: Integer);
    constructor CreateScaleAttribute(scaleFactor: Double);
    constructor CreateFallbackAttribute(enableFallback: Boolean);
    constructor CreateLetterSpacingAttribute(letterSpacing: Integer);
    constructor CreateShapeAttribute(ink, logical: TPangoRectangle);
  end;
  
implementation
uses uwrapgnames, uwrappangonames, ugtypes;

function pango_attr_size_new(size: gint): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_strikethrough_new(strikethrough: Boolean): PWPangoAttribute; cdecl; external pangolib;
function pango_attribute_equal(attr1: {const} PWPangoAttribute;attr2: {const} PWPangoAttribute): Boolean; cdecl; external pangolib;
function pango_attr_stretch_new(stretch: WPangoStretch): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_rise_new(rise: gint): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_background_new(red: Word;green: Word;blue: Word): PWPangoAttribute; cdecl; external pangolib;
//function pango_attr_shape_new_with_data(ink_rect: {const} PWPangoRectangle;logical_rect: {const} PWPangoRectangle;data: gpointer;copy_func: PWPangoAttrDataCopyFunc;destroy_func: DGDestroyNotify): PWangoAttribute; cdecl; external pangolib;
function pango_attr_size_new_absolute(size: gint): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_fallback_new(enable_fallback: Boolean): PWPangoAttribute; cdecl; external pangolib;
procedure pango_attribute_destroy(attr: PWPangoAttribute); cdecl; external pangolib;
function pango_attr_strikethrough_color_new(red: Word;green: Word;blue: Word): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_family_new(family: PChar): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_style_new(style: WPangoStyle): PWPangoAttribute; cdecl; external pangolib;
function ango_attr_style_new(style: WPangoStyle): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_language_new(language: PWPangoLanguage): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_underline_new(underline: WPangoUnderline): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_underline_color_new(red: Word;green: Word;blue: Word): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_font_desc_new(desc: Pointer{const PangoFontDescription*}): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_shape_new(ink_rect: {const} PWPangoRectangle;logical_rect: {const} PWPangoRectangle): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_scale_new(scale_factor: Double): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_variant_new(variant: WPangoVariant): PWPangoAttribute; cdecl; external pangolib;
function pango_attribute_copy(attr: {const} PWPangoAttribute): PWPangoAttribute ; cdecl; external pangolib;
function pango_attr_foreground_new(red: Word;green: Word;blue: Word): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_letter_spacing_new(letter_spacing: gint): PWPangoAttribute; cdecl; external pangolib;
function pango_attr_weight_new(weight: WPangoWeight): PWPangoAttribute; cdecl; external pangolib;

constructor TPangoAttribute.CreateWrappedCopy(ptr: Pointer);
begin
  fAttributeList := nil;
  CreateNew(pango_attribute_copy(ptr));
end;

constructor TPangoAttribute.CreateWrappedPinned(ptr: Pointer; attributelist: IPangoAttrList);
begin
  fAttributeList := attributelist;
  inherited Create(ptr, nil);
end;

constructor TPangoAttribute.CreateNew(ptr: Pointer);
begin
  fAttributeList := nil;
  inherited Create(ptr, @pango_attribute_destroy);
end;

constructor TPangoAttribute.CreateLanguageAttribute(language: TPangoLanguage);
begin
  CreateNew(pango_attr_language_new(PWPangoLanguage(language)));
end;
  
constructor TPangoAttribute.CreateFamilyAttribute(family: string);
begin
  CreateNew(pango_attr_family_new(PChar(family)));
end;
  
constructor TPangoAttribute.CreateForegroundAttribute(red, green, blue: Word);
begin
  CreateNew(pango_attr_foreground_new(red, green, blue));
end;

constructor TPangoAttribute.CreateBackgroundAttribute(red, green, blue: Word);
begin
  CreateNew(pango_attr_background_new(red, green, blue));
end;

constructor TPangoAttribute.CreateSizeAttribute(size: Integer);
begin
  CreateNew(pango_attr_size_new(size));
end;

constructor TPangoAttribute.CreateAbsoluteSizeAttribute(absoluteSize: Integer);
begin
  CreateNew(pango_attr_size_new_absolute(absoluteSize));
end;

constructor TPangoAttribute.CreateStyleAttribute(style: TPangoStyle);
begin
  CreateNew(pango_attr_style_new(WPangoStyle(style)));
end;

constructor TPangoAttribute.CreateWeightAttribute(weight: TPangoWeight);
begin
  CreateNew(pango_attr_weight_new(WPangoWeight(weight)));
end;

constructor TPangoAttribute.CreateVariantAttribute(avariant: TPangoVariant);
begin
  CreateNew(pango_attr_variant_new(WPangoVariant(avariant)));
end;

constructor TPangoAttribute.CreateStretchAttribute(stretch: TPangoStretch);
begin
  CreateNew(pango_attr_stretch_new(WPangoStretch(stretch)));
end;

constructor TPangoAttribute.CreateFontDescriptionAttribute(description: IPangoFontDescription);
begin
  assert(Assigned(description));
  // copies
  CreateNew(pango_attr_font_desc_new(description.GetUnderlying));
end;
  
constructor TPangoAttribute.CreateUnderlineAttribute(underline: TPangoUnderline);
begin
  CreateNew(pango_attr_underline_new(WPangoUnderline(underline)));
end;
  
constructor TPangoAttribute.CreateUnderlineColorAttribute(red, green, blue: Word);
begin
  CreateNew(pango_attr_underline_color_new(red, green, blue));
end;

constructor TPangoAttribute.CreateStrikethroughAttribute(strikethrough: Boolean);
begin
  CreateNew(pango_attr_strikethrough_new(strikethrough));
end;

constructor TPangoAttribute.CreateStrikethroughColorAttribute(red, green, blue: Word);
begin
  CreateNew(pango_attr_strikethrough_color_new(red, green, blue));
end;
  
constructor TPangoAttribute.CreateRiseAttribute(rise: Integer);
begin
  CreateNew(pango_attr_rise_new(rise));
end;

constructor TPangoAttribute.CreateScaleAttribute(scaleFactor: Double);
begin
  CreateNew(pango_attr_scale_new(scaleFactor));
end;

constructor TPangoAttribute.CreateFallbackAttribute(enableFallback: Boolean);
begin
  CreateNew(pango_attr_fallback_new(enableFallback));
end;

constructor TPangoAttribute.CreateLetterSpacingAttribute(letterSpacing: Integer);
begin
  CreateNew(pango_attr_letter_spacing_new(letterSpacing));
end;

constructor TPangoAttribute.CreateShapeAttribute(ink, logical: TPangoRectangle);
var
  cink: WPangoRectangle;
  clogical: WPangoRectangle;
begin
  cink := WPangoRectangle(ink);
  clogical := WPangoRectangle(logical);
  CreateNew(pango_attr_shape_new(@cink, @clogical));
end;

end.
