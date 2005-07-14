unit udiadashstyle;

interface
uses iugnomecanvas, upointermediator, iupointermediator, iudiacanvas;

type
  TDiaDashStyle = class(DPointerMediator, IDiaDashStyle, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  protected
    (*function GetIndexer: IDiaDashStyleIndexer;*)
    function GetDash: TDashArray;
    procedure SetDash(const value: TDashArray);

  published
    (*property Dash: IDiaDashStyleIndexer read GetIndexer;*)
    property Dash: TDashArray read GetDash write SetDash;
  end;

implementation
uses uwrapartnames, ugtypes, uwrapgnames, uwrapdiacanvasnames;

(*$IFDEF gtk2q_standalone*)
const
(*$IFDEF WIN32*)
  //glib = 'libglib-2.0-0.dll';
  artlib = 'libart_lgpl_2-2.dll';
(*$ELSE*)
  //glib = 'libglib-2.0.so';
  artlib = 'libart_lgpl_2.so';
(*$ENDIF*)

(*procedure g_free(ptr: Pointer); cdecl; external glib; -> uwrapgnames *)
(*art_vpath_dash_ensure_*)

(*$ENDIF gtk2q_standalone*)

constructor TDiaDashStyle.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @g_free);
end;

function NextgDouble(dova: PgDouble): PgDouble;
(*$IFDEF FPC*)inline;
begin
  Inc(dova);
  Result := dova;
end;
(*$ELSE*)
asm
  mov eax, dova
  add eax, dword ptr sizeof(gdouble)
  mov Result, eax
end;
(*$ENDIF FPC*)

function TDiaDashStyle.GetDash: TDashArray;
var
  i: Integer;
  cnt: Integer;
  pdash: PgDouble; 
begin
  cnt := PWDiaDashStyle(GetUnderlying)^.nDash;
  pdash := PWDiaDashStyle(GetUnderlying)^.dash;
  SetLength(Result, cnt);
  for i := 0 to cnt - 1 do begin
    Result[i] := pdash^;
    pdash := NextGDouble(pdash);
  end;
end;

procedure TDiaDashStyle.SetDash(const value: TDashArray);
begin
  (*WDiaDashStyle(GetUnderlying).dash!!! cant do it yet... there is no ensure_size *)
  (*TODO*)
end;

end.
