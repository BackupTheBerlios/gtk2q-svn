unit uartuta;

interface
uses classes, iugnomecanvas, uarttypes, iupointermediator, upointermediator, sysutils, iuart;

type
  TArtUta = class;
  TArtUtaItems = class(TInterfacedObject, IArtUtaItems, IInterface)
  protected
    fArtUta: TArtUta;
    function GetCount: Integer;
    function GetItem(const index: Integer): TArtUtaBbox;
  protected
    constructor Create(Owner: TArtUta);
  public
    property Item[const index: Integer]: TArtUtaBbox read GetItem;
    property Count: Integer read GetCount;
  end;

  TArtUta = class(DPointerMediator, IArtUta, IPointerMediator, IInvokable, IInterface)
  protected
    fItems: IArtUtaItems;
    fItemsLock: Integer;
  public
    function GetX0: Integer;
    function GetY0: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
    procedure SetX0(const value: Integer);
    procedure SetY0(const value: Integer);
    procedure SetWidth(const value: Integer);
    procedure SetHeight(const value: Integer);
    function GetItemsProxy: IArtUtaItems;
  protected
    function ItemGet(const index: Integer): Integer;
    function ItemGetCount: Integer;
  published
    constructor CreateWrapped(ptr: Pointer);
    property x0: Integer read GetX0 write SetX0;
    property y0: Integer read GetY0 write SetY0;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Items: IArtUtaItems read GetItemsProxy (*implements IEnumerable todo?*);
  end;

implementation
uses uwrapartnames, ugtypes, uwrapgnames, uincdec;

(*$IFDEF gtk2q_standalone*)
function art_uta_new(x0,y0,x1,y1: gint): Pointer{PWArtUta}; cdecl; external artlib; (* actually int *)
procedure art_uta_free(ptr: Pointer{PWArtUta}); cdecl; external artlib;
(*$ENDIF gtk2q_standalone*)

{ TArtUta }

constructor TArtUta.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @art_uta_free);
end;

function TArtUta.GetHeight: Integer;
begin
  Result := PWArtUta(fPtr)^.height;
end;

function TArtUta.GetItemsProxy: IArtUtaItems;
begin
  if InterlockedIncrement(fItemsLock) = 1 then begin
    fItems := TArtUtaItems.Create(Self);
  end else
    InterlockedDecrement(fItemsLock);

  Result := fItems;
end;

function TArtUta.GetWidth: Integer;
begin
  Result := PWArtUta(fPtr)^.width;
end;

function TArtUta.GetX0: Integer;
begin
  Result := PWArtUta(fPtr)^.x0;
end;

function TArtUta.GetY0: Integer;
begin
  Result := PWArtUta(fPtr)^.y0;
end;

function AGetTile(const boxes: PWArtUtaBbox; const index: Integer): WArtUtaBbox;
(*$IFDEF FPC*)
begin
  Result := (boxes + index)^;
end;
(*$ELSE*)
asm
  mov esi, boxes
(*  add esi, sizeof(PWArtUtaBbox) * index *)
  mov ebx, index
  mov eax, dword ptr [esi + 4 * ebx]
  mov Result, eax
end;
(*$ENDIF FPC*)

function TArtUta.ItemGet(const index: Integer): Integer;
begin
  (* TODO out of range *)
  if (index < 0) or (index >= ItemGetCount) then
    raise ERangeError.Create(Format('ArtUta Index %d out of range', [index]))
  else begin
    Result := AGetTile(PWArtUta(fPtr)^.utiles, index);
  end;
end;

function TArtUta.ItemGetCount: Integer;
begin
  Result := ((PWArtUta(fPtr)^.width + 31) * (PWArtUta(fPtr)^.height + 31)) div (32*32);
end;

procedure TArtUta.SetHeight(const value: Integer);
begin
  PWArtUta(fPtr)^.height := value;
end;

procedure TArtUta.SetWidth(const value: Integer);
begin
  PWArtUta(fPtr)^.width := value;
end;

procedure TArtUta.SetX0(const value: Integer);
begin
  PWArtUta(fPtr)^.x0 := value;
end;

procedure TArtUta.SetY0(const value: Integer);
begin
  PWArtUta(fPtr)^.y0 := value;
end;

{ TArtUtaItems }

constructor TArtUtaItems.Create(Owner: TArtUta);
begin
  inherited Create;
  fArtUta := Owner;
end;

function TArtUtaItems.GetCount: Integer;
begin
  Result := fArtUta.ItemGetCount;
end;

function TArtUtaItems.GetItem(const index: Integer): TArtUtaBbox;
begin
  Result := fArtUta.ItemGet(index);
end;

end.
