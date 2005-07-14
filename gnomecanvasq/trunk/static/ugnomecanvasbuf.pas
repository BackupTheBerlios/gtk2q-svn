unit ugnomecanvasbuf;

interface
uses iugnomecanvasbuf, iupointermediator, upointermediator, uarttypes, ugtypes;

type
  TGnomeCanvasBuf = class(DPointerMediator, IGnomeCanvasBuf, IPointerMediator, IInvokable, IInterface)
  published
    constructor CreateWrapped(ptr: Pointer);
  protected
    function GetIsBackground: Boolean;
    function GetIsBuffer: Boolean;
    function GetBuffer: Pointer;
    function GetRect: TArtIRect;
    function GetRowstride: Integer;
    function GetBackgroundColor: guint32;

  published
    property IsBackground: Boolean read GetIsBackground;
    property IsBuffer: Boolean read GetIsBuffer;
    property Rect: TArtIRect read GetRect;
    property Rowstride: Integer read GetRowstride;
    property BackgroundColor: guint32 read GetBackgroundColor; (* $rrggbb *)
  public
    property Buffer: Pointer read GetBuffer;
  end;

implementation
uses uwrapgnames, uwrapgnomecanvasnames;

{ TGnomeCanvasBuf }

constructor TGnomeCanvasBuf.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @g_free); (* fixme *)
end;

function TGnomeCanvasBuf.GetBackgroundColor: guint32;
begin
  Result := PWGnomeCanvasBuf(Fptr)^.bgColor;
end;

function TGnomeCanvasBuf.GetBuffer: Pointer;
begin
  Result := PWGnomeCanvasBuf(Fptr)^.buf;
end;

function TGnomeCanvasBuf.GetIsBackground: Boolean;
begin

end;

function TGnomeCanvasBuf.GetIsBuffer: Boolean;
begin

end;

function TGnomeCanvasBuf.GetRect: TArtIRect;
begin

end;

function TGnomeCanvasBuf.GetRowstride: Integer;
begin

end;

end.
