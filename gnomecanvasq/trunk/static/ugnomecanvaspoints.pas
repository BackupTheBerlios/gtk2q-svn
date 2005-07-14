unit ugnomecanvaspoints;

interface
uses upointermediator, iugnomecanvas, iupointermediator, iuart;

type
  TGnomeCanvasPoints = class(DPointerMediator, IGnomeCanvasPoints, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  protected
    function GetPoints: TTArtPointArray;
    procedure SetPoints(const arr: TTArtPointArray);
    function GetCount: Integer;

  published
    property Points: TTArtPointArray read GetPoints write SetPoints;
    property Count: Integer read GetCount;
  end;
  
implementation
uses uwrapgnomecanvasnames, uwrapgnames, ugtypes;

(*$IFDEF gtk2q_standalone*)
function gnome_canvas_points_new(numpoints: gint): PWGnomeCanvasPoints; cdecl; external gnomecanvaslib;
function gnome_canvas_points_ref(obj: PWGnomeCanvasPoints): PWGnomeCanvasPoints; cdecl; external gnomecanvaslib;
procedure gnome_canvas_points_free(points: PWGnomeCanvasPoints); cdecl; external gnomecanvaslib;
(*$ENDIF gtk2q_standalone*)


constructor TGnomeCanvasPoints.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gnome_canvas_points_free);
end;

function NextCanvasCoord(pdoud: PgDouble): PgDouble;
(*$IFDEF FPC*)
begin
  Inc(pdoud);
  Result := pdoud;
end;
(*$ELSE*)
asm
  mov eax, pdoud
  add eax, sizeof(pdoud)
  mov Result, eax
end;
(*$ENDIF FPC*)

function TGnomeCanvasPoints.GetPoints: TTArtPointArray;
var
  pdoud: PgDouble;
  cpoints: PWGnomeCanvasPoints;
  i: Integer;
begin
  cpoints := PWGnomeCanvasPoints(GetUnderlying);
  SetLength(Result, cpoints^.numPoints);
  pdoud := cpoints^.coords;
  for i := 0 to High(Result) do begin
    Result[i].x := pdoud^;
    pdoud := NextCanvasCoord(pdoud);
    Result[i].y := pdoud^;
    pdoud := NextCanvasCoord(pdoud);
  end;
end;

procedure TGnomeCanvasPoints.SetPoints(const arr: TTArtPointArray);
var
  cpoints: PWGnomeCanvasPoints;
  i: Integer;
  pdoud: PgDouble;
begin
  cpoints := PWGnomeCanvasPoints(GetUnderlying);
  if Assigned(cpoints^.coords) then begin
    g_free(cpoints^.coords);
    cpoints^.coords := nil;
  end;
    
  cpoints^.coords := g_new0(sizeof(gdouble), Length(arr) * 2);
  cpoints^.numPoints := Length(arr);
  pdoud := cpoints^.coords;
  
  for i := 0 to High(arr) do begin
    pdoud^ := arr[i].x;
    pdoud := NextCanvasCoord(pdoud);
    pdoud^ := arr[i].y;
    pdoud := NextCanvasCoord(pdoud);
  end;
end;

function TGnomeCanvasPoints.GetCount: Integer;
var
  cpoints: PWGnomeCanvasPoints;
begin
  cpoints := PWGnomeCanvasPoints(GetUnderlying);
  Result := cpoints^.numPoints;
end;

end.
