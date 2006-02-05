unit upangolayoutiter;

interface
uses iupango, iupointermediator, upointermediator, upangotypes;

{$M+}

type
  TPangoLayoutIter = class(TPointerMediator, IPangoLayoutIter, IPointerMediator, IInvokable, IInterface)
  protected
    fPangoLayout: IPangoLayout; (* pin down the layout *)
  public
    constructor CreateWrappedPinned(ptr: Pointer; pangoLayout: IPangoLayout);
  published
    function GotoNextRun: Boolean;
    function GotoNextLine: Boolean;
    function GotoNextCluster: Boolean;
    procedure GetLineYRange(out y0, y1: Integer);
    procedure GetClusterExtents(out Ink, Logical: TPangoRectangle);
    procedure GetLineExtents(out Ink, Logical: TPangoRectangle);
    procedure GetRunExtents(out Ink, Logical: TPangoRectangle);
  protected
    function GetLine: IPangoLayoutLine;
    function GetIsAtLastLine: Boolean;
    function GetCharExtents: TPangoRectangle;
    function GetBaseline: Integer;
    function GetRun: IPangoLayoutRun;
    function GetIndex1: Integer;
    function GetLineExtentsLogical: TPangoRectangle;
    function GetRunExtentsLogical: TPangoRectangle;
    function GetClusterExtentsLogical: TPangoRectangle;
    function GetLineExtentsInk: TPangoRectangle;
    function GetRunExtentsInk: TPangoRectangle;
    function GetClusterExtentsInk: TPangoRectangle;
  published
    property Line: IPangoLayoutLine read GetLine;
    property IsAtLastLine: Boolean read GetIsAtLastLine;
    property Baseline: Integer read GetBaseline;
    property Run: IPangoLayoutRun read GetRun;
    property Index1: Integer read GetIndex1;
  public
    property CharExtents: TPangoRectangle read GetCharExtents;
    property ClusterExtentsInk: TPangoRectangle read GetClusterExtentsInk;
    property ClusterExtentsLogical: TPangoRectangle read GetClusterExtentsLogical;
    property LineExtentsInk: TPangoRectangle read GetLineExtentsInk;
    property LineExtentsLogical: TPangoRectangle read GetLineExtentsLogical;
    property RunExtentsInk: TPangoRectangle read GetRunExtentsInk;
    property RunExtentsLogical: TPangoRectangle read GetRunExtentsLogical;
  end;

implementation

uses utyperegistry, uincdec,uwrapgnames,uwrappangonames, ugtypes, upangolayoutline, upangoglyphitem;

(*$INCLUDE clinksettings.inc*)

function pango_layout_iter_next_run(iter: PWPangoLayoutIter): Boolean; cdecl; external pangolib;
function pango_layout_iter_get_line(iter: PWPangoLayoutIter): PWPangoLayoutLine; cdecl; external pangolib;
function pango_layout_iter_next_line(iter: PWPangoLayoutIter): Boolean; cdecl; external pangolib;
function pango_layout_iter_next_cluster(iter: PWPangoLayoutIter): Boolean; cdecl; external pangolib;
procedure pango_layout_iter_get_line_yrange(iter: PWPangoLayoutIter;y0_: PWint;y1_: PWint); cdecl; external pangolib;
procedure pango_layout_iter_get_char_extents(iter: PWPangoLayoutIter;logical_rect: PWPangoRectangle); cdecl; external pangolib;
procedure pango_layout_iter_get_cluster_extents(iter: PWPangoLayoutIter;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;
function pango_layout_iter_at_last_line(iter: PWPangoLayoutIter): Boolean; cdecl; external pangolib;
function pango_layout_iter_get_baseline(iter: PWPangoLayoutIter): gint; cdecl; external pangolib;
procedure pango_layout_iter_get_line_extents(iter: PWPangoLayoutIter;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;
function pango_layout_iter_get_run(iter: PWPangoLayoutIter): PWPangoLayoutRun; cdecl; external pangolib;
procedure pango_layout_iter_free(iter: PWPangoLayoutIter); cdecl; external pangolib;
function pango_layout_iter_get_index(iter: PWPangoLayoutIter): gint; cdecl; external pangolib;
procedure pango_layout_iter_get_run_extents(iter: PWPangoLayoutIter;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;
function pango_layout_iter_next_char(iter: PWPangoLayoutIter): Boolean; cdecl; external pangolib;
procedure pango_layout_iter_get_layout_extents(iter: PWPangoLayoutIter;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;

constructor TPangoLayoutIter.CreateWrappedPinned(ptr: Pointer; pangoLayout: IPangoLayout);
begin
  fPangoLayout := pangoLayout;
  inherited Create(ptr, nil); // I don't own it so I don't free it either: @pango_layout_iter_free);
end;

function TPangoLayoutIter.GotoNextRun: Boolean;
begin
  Result := pango_layout_iter_next_run(GetUnderlying);
end;

function TPangoLayoutIter.GotoNextLine: Boolean;
begin
  Result := pango_layout_iter_next_line(GetUnderlying);
end;

function TPangoLayoutIter.GotoNextCluster: Boolean;
begin
  Result := pango_layout_iter_next_cluster(GetUnderlying);
end;

procedure TPangoLayoutIter.GetLineYRange(out y0, y1: Integer);
var
  cy0, cy1: Wint;
begin
  pango_layout_iter_get_line_yrange(GetUnderlying, @cy0, @cy1);
  y0 := cy0;
  y1 := cy1;
end;

procedure TPangoLayoutIter.GetClusterExtents(out Ink, Logical: TPangoRectangle);
var
  cink, clogical: WPangoRectangle;
begin
  pango_layout_iter_get_cluster_extents(GetUnderlying, @cink, @clogical);
  Ink := TPangoRectangle(cink);
  Logical := TPangoRectangle(clogical);
end;
  
procedure TPangoLayoutIter.GetLineExtents(out Ink, Logical: TPangoRectangle);
var
  cink, clogical: WPangoRectangle;
begin
  pango_layout_iter_get_line_extents(GetUnderlying, @cink, @clogical);
  Ink := TPangoRectangle(cink);
  Logical := TPangoRectangle(clogical);
end;

procedure TPangoLayoutIter.GetRunExtents(out Ink, Logical: TPangoRectangle);
var
  cink, clogical: WPangoRectangle;
begin
  pango_layout_iter_get_run_extents(GetUnderlying, @cink, @clogical);
  Ink := TPangoRectangle(cink);
  Logical := TPangoRectangle(clogical);
end;

function TPangoLayoutIter.GetLine: IPangoLayoutLine;
var
  clowlevel: PWPangoLayoutLine;
begin
  clowlevel := pango_layout_iter_get_line(GetUnderlying);
  Result := TPangoLayoutLine.CreateWrapped(clowlevel);
end;

function TPangoLayoutIter.GetIsAtLastLine: Boolean;
begin
  Result := pango_layout_iter_at_last_line(GetUnderlying);
end;

function TPangoLayoutIter.GetCharExtents: TPangoRectangle;
var
  clogical: WPangoRectangle;
begin
  pango_layout_iter_get_char_extents(GetUnderlying, @clogical);
  Result := TPangoRectangle(clogical);
end;

function TPangoLayoutIter.GetBaseline: Integer;
begin
  Result := pango_layout_iter_get_baseline(GetUnderlying);
end;

function TPangoLayoutIter.GetRun: IPangoLayoutRun;
var
  clowlevel: PWPangoLayoutRun;
begin
  // UNSAFE, UNTESTED and MOST PROBABLY BROKEN FUNCTION
  
  assert(False);
  
  clowlevel := pango_layout_iter_get_run(GetUnderlying);
  // FIXME need refcount?
  Result := TPangoGlyphItem.CreateWrappedPinned(clowlevel, Self);
end;
  
function TPangoLayoutIter.GetIndex1: Integer;
begin
  Result := pango_layout_iter_get_index(GetUnderlying);
end;

function TPangoLayoutIter.GetLineExtentsLogical: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetLineExtents(Ink, Logical);
  Result := Logical;
end;

function TPangoLayoutIter.GetRunExtentsLogical: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetRunExtents(Ink, Logical);
  Result := Logical;
end;

function TPangoLayoutIter.GetClusterExtentsLogical: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetClusterExtents(Ink, Logical);
  Result := Logical;
end;

function TPangoLayoutIter.GetLineExtentsInk: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetLineExtents(Ink, Logical);
  Result := Ink;
end;

function TPangoLayoutIter.GetRunExtentsInk: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetRunExtents(Ink, Logical);
  Result := Ink;
end;

function TPangoLayoutIter.GetClusterExtentsInk: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetClusterExtents(Ink, Logical);
  Result := Ink;
end;

end.
