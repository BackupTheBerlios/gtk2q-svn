unit upangocontext;

interface
uses iupango, iugobject, ugobject, upangotypes, ugtypes;

type
  TPangoContext = class(TGObject, IPangoContext, IGObject,IGUserData,IInvokable,IInterface)
  public
    function GetMetrics(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontMetrics;

  protected
    function GetLanguage: TPangoLanguage;
    procedure SetLanguage(value: TPangoLanguage);
    
    function GetBaseDirection: TPangoDirection;
    procedure SetBaseDirection(value: TPangoDirection);
    
    function GetFontDescription: IPangoFontDescription; // do not modify result!
    procedure SetFontDescription(value: IPangoFontDescription);
    
    function GetMatrix: TPangoMatrix;
    procedure SetMatrix(value: TPangoMatrix);
    
    // internal use ! function GetFontMap: IPangoFontMap;
  public
    constructor Create; override;
    
    function ListFamilies: TIPangoFontFamilyArray;
    function LoadFont(description: IPangoFontDescription): IPangoFont;
    function LoadFontset(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontset;
    
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)

  public    
    property Language: TPangoLanguage read GetLanguage write SetLanguage;
    property Matrix: TPangoMatrix read GetMatrix write SetMatrix;
  published
    property BaseDirection: TPangoDirection read GetBaseDirection write SetBaseDirection;
    property FontDescription: IPangoFontDescription read GetFontDescription write SetFontDescription;
  end;
  
implementation
uses upangofontmetrics, upangofontdescription, upangofont, upangofontset, uwrappangonames, 
     uwrapgnames, upangofontfamily, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_context_get_type: TGType; cdecl; external pangolib;
function pango_context_get_base_dir(context: Pointer{PangoContext*}): WPangoDirection; cdecl; external pangolib;
function pango_context_get_font_description(context: Pointer{PangoContext*}): PWPangoFontDescription; cdecl; external pangolib;
function pango_context_get_font_map(context: Pointer{PangoContext*}): PWPangoFontMap; cdecl; external pangolib;
function pango_context_get_language(context: Pointer{PangoContext*}): PWPangoLanguage; cdecl; external pangolib;
function pango_context_get_matrix(context: Pointer{PangoContext*}): PWPangoMatrix; cdecl; external pangolib;
function pango_context_get_metrics(context: Pointer{PangoContext*}; description: PWPangoFontDescription; language: PWPangoLanguage): PWPangoFontMetrics; cdecl; external pangolib;
procedure pango_context_list_families(context: Pointer{PangoContext*}; families: PPPWPangoFontFamily; nfamilies: PWgint); cdecl; external pangolib;
function pango_context_load_font(context: Pointer{PangoContext*}; description: PWPangoFontDescription): PWPangoFont; cdecl; external pangolib;
function pango_context_load_fontset(context: Pointer{PangoContext*}; description: PWPangoFontDescription; language: PWPangoLanguage): PWPangoFontset; cdecl; external pangolib;
function pango_context_new(): PWPangoContext; cdecl; external pangolib;
procedure pango_context_set_base_dir(context: Pointer{PangoContext*}; direction: WPangoDirection); cdecl; external pangolib;
procedure pango_context_set_font_description(context: Pointer{PangoContext*}; description: PWPangoFontDescription); cdecl; external pangolib;
procedure pango_context_set_font_map(context: Pointer{PangoContext*}; fontmap: PWPangoFontMap); cdecl; external pangolib;
procedure pango_context_set_language(context: Pointer{PangoContext*}; language: PWPangoLanguage); cdecl; external pangolib;
procedure pango_context_set_matrix(context: Pointer{PangoContext*}; {const}matrix: PWPangoMatrix); cdecl; external pangolib;
{$endif gtk2q_standalone}

constructor TPangoContext.Create;
begin
  inherited Create;
end;

function TPangoContext.GetMetrics(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontMetrics;
var
  lowlevel: PWPangoFontMetrics;
begin
  lowlevel := pango_context_get_metrics(fObject, description, language);
  Result := TPangoFontMetrics.CreateWrapped(lowlevel);
end;

function TPangoContext.GetLanguage: TPangoLanguage;
begin
  Result := TPangoLanguage(pango_context_get_language(fObject)); // handle-like
end;

procedure TPangoContext.SetLanguage(value: TPangoLanguage);
begin
  pango_context_set_language(fObject, PWPangoLanguage(value)); // handle-like
end;
    
function TPangoContext.GetBaseDirection: TPangoDirection;
begin
  Result := TPangoDirection(pango_context_get_base_dir(fObject));
end;

procedure TPangoContext.SetBaseDirection(value: TPangoDirection);
begin
  pango_context_set_base_dir(fObject, WPangoDirection(value));
end;
    
function TPangoContext.GetFontDescription: IPangoFontDescription; // do not modify result!
var
  cwrappee: Pointer;
begin
  cwrappee := pango_context_get_font_description(fObject);
  Result := TPangoFontDescription.CreateWrapped(cwrappee); // TODO test
end;

procedure TPangoContext.SetFontDescription(value: IPangoFontDescription);
begin
  assert(Assigned(value));
  pango_context_set_font_description(fObject, value.GetUnderlying);
end;

function TPangoContext.GetMatrix: TPangoMatrix;
var
  cmatrix: PWPangoMatrix;
begin
  cmatrix := pango_context_get_matrix(fObject);
  if Assigned(cmatrix) then begin
    Result := TPangoMatrix(cmatrix^);
  end else begin (* is that an identity matrix? *)
    Result.xx := 1.0;
    Result.xy := 1.0;
    Result.yx := 1.0;
    Result.yy := 1.0;
    Result.x0 := 1.0;
    Result.y0 := 1.0;
  end;
end;

procedure TPangoContext.SetMatrix(value: TPangoMatrix);
begin
  pango_context_set_matrix(fObject, PWPangoMatrix(@value));
  (*  pango_context_set_matrix(fObject, nil); also possible *)
end;

function TPangoContext.ListFamilies: TIPangoFontFamilyArray;
var
  families: PPWPangoFontFamily;
  cntFamilies: gint;
  i: Integer;
begin
  // TODO test!
  families := nil;
  pango_context_list_families(fObject, @families, @cntFamilies);
  SetLength(Result, 0);
  
  if Assigned(families) then begin
    SetLength(Result, cntFamilies);
    
    // TODO delphi
    for i := 0 to cntFamilies - 1 do begin
      Result[i] := TPangoFontFamily.CreateWrapped((families + i)^); // FIXME refcounting?
    end;
    
    g_free(families);
  end;
end;

function TPangoContext.LoadFont(description: IPangoFontDescription): IPangoFont;
var
  clowlevel: PWPangoFont;
begin
  // TODO test
  assert(Assigned(description));
  clowlevel := pango_context_load_font(fObject, description.GetUnderlying);
  if Assigned(clowlevel) then begin
    Result := TPangoFont.CreateWrapped(clowlevel);
  end else begin
    Result := nil;
  end;
end;

function TPangoContext.LoadFontset(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontset;
var
  clowlevel: PWPangoFontset;
begin
  assert(Assigned(description));
  clowlevel := pango_context_load_fontset(fObject, description.GetUnderlying, PWPangoLanguage(language));
  if Assigned(clowlevel) then begin
    Result := TPangoFontset.CreateWrapped(clowlevel);
  end else begin
    Result := nil;
  end;
end;

class procedure TPangoContext.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('TPangoContext', 'pango', TPangoContext, pango_context_get_type, IPangoContext);
end;

class function TPangoContext.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoContext.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
