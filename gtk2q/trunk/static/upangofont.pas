unit upangofont;

interface
uses ugobject, iupango, iugobject, upangotypes, ugtypes;

type
  TPangoFont = class(TGObject, IPangoFont, IGObject, IInvokable, IInterface)
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)

  published
    function Describe: IPangoFontDescription;

    function FindShaper(language: TPangoLanguage; CharacterCode: Cardinal): IPangoEngineShape;
    
    function GetCoverage(language: TPangoLanguage = nil): IPangoCoverage; // SLOW
    
    procedure GetGlyphExtents(glyph: TPangoGlyph; out InkRectangle: TPangoRectangle; out LogicalRectangle: TPangoRectangle);
    
    function GetMetrics(language: TPangoLanguage = nil): IPangoFontMetrics;
    
  protected
    function GetFontMap: IPangoFontMap;
  published    
    property FontMap: IPangoFontMap read GetFontMap;
  end;

implementation
uses uwrapgnames, uwrappangonames, upangofontdescription, upangocoverage, upangofontmetrics, upangofontmap, 
  upangoengineshape, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
// TODO? wrap
function pango_font_get_type: TGType; cdecl; external pangolib;
function pango_font_describe(font: Pointer{PangoFont*}): PWPangoFontDescription; cdecl; external pangolib;
function pango_font_get_coverage(font: Pointer{PangoFont*}; language: PWPangoLanguage): PWPangoCoverage; cdecl; external pangolib;
function pango_font_get_metrics(font: Pointer{PangoFont*}; language: PWPangoLanguage): PWPangoFontMetrics; cdecl; external pangolib;
procedure pango_font_get_glyph_extents(font: Pointer{PangoFont*};
                                       glyph: WPangoGlyph; 
                                       InkRect: PWPangoRectangle;
                                       LogicalRect: PWPangoRectangle); cdecl; external pangolib;
function pango_font_get_font_map(font: Pointer{PangoFont*}): PWPangoFontMap; cdecl; external pangolib;
function pango_font_find_shaper(font: Pointer{PangoFont*}; language: PWPangoLanguage; ch: guint32): PWPangoEngineShape; cdecl; external pangolib;
{$endif gtk2q_standalone}

function TPangoFont.Describe: IPangoFontDescription;
var
  clowlevel: PWPangoFontDescription;
begin
  clowlevel := pango_font_describe(fObject);
  Result:= TPangoFontDescription.CreateWrapped(clowlevel);
end;

function TPangoFont.FindShaper(language: TPangoLanguage; CharacterCode: Cardinal): IPangoEngineShape;
var
  clowlevel: PWPangoEngineShape;
begin
  clowlevel := pango_font_find_shaper(fObject, PWPangoLanguage(language), CharacterCode);
  Result := TPangoEngineShape.CreateWrapped(clowlevel);
end;
    
function TPangoFont.GetCoverage(language: TPangoLanguage = nil): IPangoCoverage;
var
  clowlevel: PWPangoCoverage;
begin
  clowlevel := pango_font_get_coverage(fObject, PWPangoLanguage(language));
  Result := TPangoCoverage.CreateWrapped(clowlevel);
end;
   
procedure TPangoFont.GetGlyphExtents(glyph: TPangoGlyph; out InkRectangle: TPangoRectangle; out LogicalRectangle: TPangoRectangle);
var
  cinkrectangle: WPangoRectangle;
  clogicalrectangle: WPangoRectangle;
begin
  pango_font_get_glyph_extents(fObject, glyph, @cinkrectangle, @clogicalrectangle);
  InkRectangle := TPangoRectangle(cinkrectangle);
  LogicalRectangle := TPangoRectangle(cinkrectangle);
end;
    
function TPangoFont.GetMetrics(language: TPangoLanguage = nil): IPangoFontMetrics;
var
  clowlevel: PWPangoFontMetrics;
begin
  clowlevel := pango_font_get_metrics(fObject, PWPangoLanguage(language));
  // TODO can this be nil?
  
  Result := TPangoFontMetrics.CreateWrapped(clowlevel);
end;
    
function TPangoFont.GetFontMap: IPangoFontMap;
var
  clowlevel: PWPangoFontMap;
begin
  clowlevel := pango_font_get_font_map(fObject);
  Result := TPangoFontMap.CreateWrapped(clowlevel);
end;

class procedure TPangoFont.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('TPangoFont', 'pango', TPangoFont, pango_font_get_type, IPangoFont);
end;

class function TPangoFont.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoFont.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
