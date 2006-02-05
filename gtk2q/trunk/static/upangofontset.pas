unit upangofontset;

interface
uses ugobject, iugobject, iupango, ugtypes;

type
  TPangoFontset = class(TGObject, IPangoFontSet, IGObject, IInvokable, IInterface)
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)
    
  published
    // foreach
    function GetFont(unicodeCharacter: Cardinal): IPangoFont;
    function GetMetrics: IPangoFontMetrics;
    
    property Metrics: IPangoFontMetrics read GetMetrics;
  end;
  
implementation
uses uwrapgnames, uwrappangonames, upangofontmetrics, upangofont, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_fontset_get_type: TGType; cdecl; external pangolib;
function pango_fontset_get_font(set1: Pointer{PangoFontSet*}; wc: guint): PWPangoFont; cdecl; external pangolib;
function pango_fontset_get_metrics(set1: Pointer{PangoFontSet*}): PWPangoFontMetrics; cdecl; external pangolib;
{$endif gtk2q_standalone}

class procedure TPangoFontset.TypeRegister; (* flat *)
begin
  inherited TypeRegister;
  DTypeRegister('TPangoFontset', 'pango', TPangoFontset, pango_fontset_get_type, IPangoFontSet);
end;

class function TPangoFontset.OverrideGType: TGType;
begin
  Result := 0;
end;

function TPangoFontset.GetFont(unicodeCharacter: Cardinal): IPangoFont;
var
  clowlevel: PWPangoFont;
begin
  clowlevel := pango_fontset_get_font(fObject, unicodeCharacter);
  Result := TPangoFont.CreateWrapped(clowlevel);
end;

function TPangoFontset.GetMetrics: IPangoFontMetrics;
var
  clowlevel: PWPangoFontMetrics;
begin
  clowlevel := pango_fontset_get_metrics(fObject);
  Result := TPangoFontMetrics.CreateWrapped(clowlevel);
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoFontset.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
