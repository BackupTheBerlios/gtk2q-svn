unit upangolayoutline;

interface
uses iupango, upointermediator, iupointermediator, upangotypes;

{$M+}

type
  TPangoLayoutLine = class(TPointerMediator, IPangoLayoutLine, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  protected
    function GetInkExtents: TPangoRectangle;
    function GetLogicalExtents: TPangoRectangle;
    function GetInkPixelExtents: TPangoRectangle;
    function GetLogicalPixelExtents: TPangoRectangle;
  public
    property InkExtents: TPangoRectangle read GetInkExtents;
    property LogicalExtents: TPangoRectangle read GetLogicalExtents;
    property InkPixelExtents: TPangoRectangle read GetInkPixelExtents;
    property LogicalPixelExtents: TPangoRectangle read GetLogicalPixelExtents;
  published
    procedure GetExtents(out InkExtents, LogicalExtents: TPangoRectangle);
    procedure GetPixelExtents(out InkExtents, LogicalExtents: TPangoRectangle);
    function IndexToX(index: Integer; trailing: Boolean): Integer;
    function XToIndex(xPos: Integer; out index: Integer; out trailing: Boolean): Boolean;
    function GetXRanges(startindex, endindex: Integer): TPangoRangeArray;
  end;

implementation
uses utyperegistry, uincdec,uwrapgnames,uwrappangonames, ugtypes;

procedure pango_layout_line_get_extents(line: PWPangoLayoutLine;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;
procedure pango_layout_line_get_pixel_extents(layout_line: PWPangoLayoutLine;ink_rect: PWPangoRectangle;logical_rect: PWPangoRectangle); cdecl; external pangolib;
procedure pango_layout_line_index_to_x(line: PWPangoLayoutLine;index_: gint;trailing: Boolean;x_pos: PWint); cdecl; external pangolib;
function pango_layout_line_x_to_index(line: PWPangoLayoutLine;x_pos: gint;index_: PWint;trailing: PWint): Boolean; cdecl; external pangolib;
procedure pango_layout_line_get_x_ranges(line: PWPangoLayoutLine; startindex, endindex: Wint; ranges: PPWint; nranges: PWint); cdecl; external pangolib;

function pango_layout_line_ref(line: PWPangoLayoutLine): PWPangoLayoutLine; cdecl; external pangolib;
procedure pango_layout_line_unref(line: PWPangoLayoutLine); cdecl; external pangolib;

constructor TPangoLayoutLine.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_layout_line_unref);
end;

function TPangoLayoutLine.GetInkExtents: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetExtents(Ink, Logical);
  Result := Ink;
end;

function TPangoLayoutLine.GetLogicalExtents: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetExtents(Ink, Logical);
  Result := Logical;
end;

function TPangoLayoutLine.GetInkPixelExtents: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetPixelExtents(Ink, Logical);
  Result := Ink;
end;

function TPangoLayoutLine.GetLogicalPixelExtents: TPangoRectangle;
var
  Ink, Logical: TPangoRectangle;
begin
  GetPixelExtents(Ink, Logical);
  Result := Logical;
end;

procedure TPangoLayoutLine.GetExtents(out InkExtents, LogicalExtents: TPangoRectangle);
var
  cink: WPangoRectangle;
  clogical: WPangoRectangle;
begin
  pango_layout_line_get_extents(GetUnderlying, @cink, @clogical);
  InkExtents := TPangoRectangle(cink);
  LogicalExtents := TPangoRectangle(clogical);
end;
  
procedure TPangoLayoutLine.GetPixelExtents(out InkExtents, LogicalExtents: TPangoRectangle);
var
  cink: WPangoRectangle;
  clogical: WPangoRectangle;
begin
  pango_layout_line_get_pixel_extents(GetUnderlying, @cink, @clogical);
  InkExtents := TPangoRectangle(cink);
  LogicalExtents := TPangoRectangle(clogical);
end;
  
function TPangoLayoutLine.IndexToX(index: Integer; trailing: Boolean): Integer;
var
  cx: Wint;
begin
  pango_layout_line_index_to_x(GetUnderlying, index, trailing, @cx);
  Result := cx;
end;

function TPangoLayoutLine.XToIndex(xPos: Integer; out index: Integer; out trailing: Boolean): Boolean;
var
  cindex: Wint;
  ctrailing: Wint;
begin
  Result := pango_layout_line_x_to_index(GetUnderlying, xPos, @cindex, @ctrailing);
  index := cindex;
  trailing := ctrailing <> 0; (* TODO correct? *)
end;

function TPangoLayoutLine.GetXRanges(startindex, endindex: Integer): TPangoRangeArray;
var
  cranges: PWint;
  crangecnt: Wint;
  i: Wint;
begin
  // TODO delphi
  pango_layout_line_get_x_ranges(GetUnderlying, startindex, endindex, @cranges, @crangecnt);
  SetLength(Result, crangecnt);
  for i := 0 to crangecnt - 1 do begin
    Result[i] := (cranges + i)^; 
  end;
end;
        
end.
