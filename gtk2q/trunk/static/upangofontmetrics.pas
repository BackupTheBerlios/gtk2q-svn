unit upangofontmetrics;

interface
uses iupointermediator, upointermediator, iupango, upangotypes, iug;

// read-only stuff

type
  // Cloneable?
  
  TPangoFontMetrics = class(TPointerMediator, IPangoFontMetrics, IPointerMediator, ICloneable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    
    function Clone: ICloneable;
    
  protected
    function GetAscent: Integer;
    function GetDescent: Integer;
    function GetApproximateCharWidth: Integer;
    function GetApproximateDigitWidth: Integer;
    function GetUnderlinePosition: Integer;
    function GetUnderlineThickness: Integer;
    function GetStrikethroughPosition: Integer;
    function GetStrikethroughThickness: Integer;

  published
    property Ascent: Integer read GetAscent;
    property Descent: Integer read GetDescent;
    property ApproximateCharWidth: Integer read GetApproximateCharWidth;
    property ApproximateDigitWidth: Integer read GetApproximateDigitWidth;
    property UnderlinePosition: Integer read GetUnderlinePosition;
    property UnderlineThickness: Integer read GetUnderlineThickness;
    property StrikethroughPosition: Integer read GetStrikethroughPosition;
    property StrikethroughThickness: Integer read GetStrikethroughThickness;
  end;
  
implementation
uses uwrapgnames, uwrappangonames;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
procedure pango_font_metrics_unref(metrics: PWPangoFontMetrics); cdecl; external pangolib;
{$endif gtk2q_standalone}

constructor TPangoFontMetrics.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_font_metrics_unref);
end;

function TPangoFontMetrics.GetAscent: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.Ascent;
end;

function TPangoFontMetrics.GetDescent: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.Descent;
end;

function TPangoFontMetrics.GetApproximateCharWidth: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.ApproximateCharWidth;
end;

function TPangoFontMetrics.GetApproximateDigitWidth: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.ApproximateDigitWidth;
end;

function TPangoFontMetrics.GetUnderlinePosition: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.UnderlinePosition;
end;

function TPangoFontMetrics.GetUnderlineThickness: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.UnderlineThickness;
end;

function TPangoFontMetrics.GetStrikethroughPosition: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.StrikethroughPosition;
end;

function TPangoFontMetrics.GetStrikethroughThickness: Integer;
begin
  Result := PWPangoFontMetrics(GetUnderlying)^.StrikethroughThickness;
end;

function TPangoFontMetrics.Clone: ICloneable;
var 
  metrics: PWPangoFontMetrics;
begin
  metrics := g_new0(sizeof(WPangoFontMetrics), 1);
  metrics^ := PWPangoFontMetrics(GetUnderlying)^;
  metrics^.RefCount := 1;
  try
    Result := TPangoFontMetrics.CreateWrapped(metrics);
  except
    g_free(metrics);
  end;
end;

end.
