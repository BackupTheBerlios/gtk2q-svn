unit upangocoverage;

interface
uses iupango, upointermediator, iupointermediator, iug, upangotypes;

{$M+}

type 
  TPangoCoverage = class(TPointerMediator, IPangoCoverage, IPointerMediator, IInvokable, ICloneable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    constructor Create; reintroduce;
    
    function Clone: ICloneable;
  published
    function GetLevel(aindex: Integer): TPangoCoverageLevel;
    procedure Max(other: IPangoCoverage);
    procedure SetLevel(aindex: Integer; level: TPangoCoverageLevel);
  end;

implementation
uses ugtypes, uwrapgnames, uwrappangonames;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_coverage_new: PWPangoCoverage; cdecl; external pangolib;
function pango_coverage_ref(coverage: PWPangoCoverage): PWPangoCoverage; cdecl; external pangolib;
procedure pango_coverage_unref(coverage: PWPangoCoverage); cdecl; external pangolib;
function pango_coverage_copy(coverage: PWPangoCoverage): PWPangoCoverage; cdecl; external pangolib;
function pango_coverage_get(coverage: PWPangoCoverage; aindex: gint): WPangoCoverageLevel; cdecl; external pangolib;
procedure pango_coverage_max(coverage, other: PWPangoCoverage); cdecl; external pangolib;
procedure pango_coverage_set(coverage: PWPangoCoverage; aindex: gint; level: WPangoCoverageLevel); cdecl; external pangolib;

//procedure pango_coverage_to_bytes(coverage: PWPangoCoverage; uchar** bytes, int*nbytes); cdecl; external pangolib;

//function pango_coverage_from_bytes(guchar* bytes, int n_bytes): PWPangoCoverage; cdecl; external pangolib;

{$endif gtk2q_standalone}

function TPangoCoverage.Clone: ICloneable;
begin
  Result := (*$IFDEF FPC*)TPangoCoverage.(*$ENDIF FPC*)CreateWrapped(pango_coverage_copy(GetUnderlying));
end;                                             

constructor TPangoCoverage.Create;
begin
  CreateWrapped(pango_coverage_new());
end;

function TPangoCoverage.GetLevel(aindex: Integer): TPangoCoverageLevel;
begin
  Result := TPangoCoverageLevel(pango_coverage_get(GetUnderlying, aindex));
end;
    
procedure TPangoCoverage.Max(other: IPangoCoverage);
begin
  assert(Assigned(other));
  pango_coverage_max(GetUnderlying, other.GetUnderlying);
end;

procedure TPangoCoverage.SetLevel(aindex: Integer; level: TPangoCoverageLevel);
begin
  pango_coverage_set(GetUnderlying, aindex, WPangoCoverageLevel(level));
end;

constructor TPangoCoverage.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_coverage_unref);
end;

end.
