unit upangofontmap;

interface
uses ugobject, iugobject, iupango, ugtypes, upangotypes;

type 
  TPangoFontMap = class(TGObject, IPangoFontMap, IGObject, IInvokable, IInterface)
  protected
    function GetShapeEngineType: string;

  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)
    
  published
    function ListFamilies: TIPangoFontFamilyArray;
    function LoadFont(context: IPangoContext; description: IPangoFontDescription): IPangoFont;
    function LoadFontset(context: IPangoContext; description: IPangoFontDescription; language: TPangoLanguage): IPangoFontset;
    
    property ShapeEngineType: string read GetShapeEngineType;
end;

implementation
uses uwrapgnames, uwrappangonames, upangofontfamily, upangofont, upangofontset, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_font_map_get_type: TGType; cdecl; external pangolib;
function pango_font_map_get_shape_engine_type(map1: Pointer{PangoFontMap*}): PChar; cdecl; external pangolib;
procedure pango_font_map_list_families(map1: Pointer{PangoFontMap*}; families: PPPWPangoFontFamily; nfamilies: PWgint); cdecl; external pangolib;
function pango_font_map_load_font(map1: Pointer{PangoFontMap*}; context: PWPangoContext; description: PWPangoFontDescription): PWPangoFont; cdecl; external pangolib;
function pango_font_map_load_fontset(map1: Pointer{PangoFontMap*}; context: PWPangoContext; description: PWPangoFontDescription; language: PWPangoLanguage): PWPangoFontset; cdecl; external pangolib;
{$endif gtk2q_standalone}

function TPangoFontMap.GetShapeEngineType: string;
var 
  clowlevel: PChar;
begin
  clowlevel := pango_font_map_get_shape_engine_type(fObject);
  Result := clowlevel;
  // do not free
end;

function TPangoFontMap.ListFamilies: TIPangoFontFamilyArray;
var
  cfamilies: PPWPangoFontFamily;
  cfamiliescnt: gint;
  i: gint;
begin
  SetLength(Result, 0);
  pango_font_map_list_families(fObject, @cfamilies, @cfamiliescnt);
  for i := 0 to cfamiliescnt - 1 do begin
    Result[i] := TPangoFontFamily.CreateWrapped((cfamilies + i)^); { TODO test refcounting? }
  end;
end;

function TPangoFontMap.LoadFont(context: IPangoContext; description: IPangoFontDescription): IPangoFont;
var
  clowlevel: PWPangoFont;
begin
  assert(Assigned(context));
  assert(Assigned(description));
  clowlevel := pango_font_map_load_font(fObject, context.GetUnderlying, description.GetUnderlying);
  Result := TPangoFont.CreateWrapped(clowlevel);
end;

function TPangoFontMap.LoadFontset(context: IPangoContext; description: IPangoFontDescription; language: TPangoLanguage): IPangoFontset;
var
  clowlevel: PWPangoFont;
begin
  assert(Assigned(context));
  assert(Assigned(description));
  clowlevel := pango_font_map_load_fontset(fObject, context.GetUnderlying, description.GetUnderlying, PWPangoLanguage(language));
  Result := TPangoFontset.CreateWrapped(clowlevel);
end;

class procedure TPangoFontMap.TypeRegister; (* flat *)
begin
  inherited TypeRegister;
  DTypeRegister('TPangoFontMap', 'pango', TPangoFontMap, pango_font_map_get_type, IPangoFontMap);
end;

class function TPangoFontMap.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoFontMap.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
