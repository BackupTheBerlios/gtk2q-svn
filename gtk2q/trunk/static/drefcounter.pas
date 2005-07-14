unit drefcounter;

interface

type
  TCustomDInterfacedObject = class(TObject, IInterface)
  private
    FMootRefCount: Integer; (* for interlockedincrement; counter for as long as the underlying object is not set. *)
    FMineRefCount: Integer; (* for interlockeddecrement; counter for number of pascal interface references *)
  protected
    Fobject: Pointer; (* TODO maybe move that to ugobject too (and use GetUnderlying here) *)
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out obj): HRESULT; stdcall;
    procedure UnrefUnderlyingObject; virtual; abstract;
    procedure RefUnderlyingObject; virtual; abstract;
    procedure SinkUnderlyingObject; virtual; (* most dont have that *)
    procedure FixRefCount; (* not called often. not optimized. *)
    procedure Destroyed; virtual;
  public
    destructor Destroy; override;
    procedure UnrefAll;
    function GetUnderlying: Pointer; virtual; (* virtual not really needed yet *)
  end;


implementation
uses uincdec;

{$IFDEF FPC}
const E_NOINTERFACE: HRESULT = HRESULT($80004002);
{$ENDIF FPC}

{ TCustomDInterfacedObject }


function TCustomDInterfacedObject._AddRef: Integer; stdcall;
begin
  Result := 0;
  if GetUnderlying = nil then
    InterlockedIncrement(FMootRefCount)
  else
    RefUnderlyingObject;

  InterlockedIncrement(FMineRefCount);
end;

function TCustomDInterfacedObject._Release: Integer; stdcall;
begin
  Result := 0;
  if GetUnderlying = nil then 
    InterlockedDecrement(FMootRefCount)
  else
    UnrefUnderlyingObject;

  if InterlockedDecrement(FMineRefCount) = 0 then 
    Self.Destroy;
end;

procedure TCustomDInterfacedObject.SinkUnderlyingObject;
begin
end;

function TCustomDInterfacedObject.QueryInterface(const IID: TGUID;
  out obj): HRESULT; stdcall;
begin
  if GetInterface(IID, obj) then
    Result := 0
  else
    Result := E_NoInterface;
end;


procedure TCustomDInterfacedObject.FixRefCount;
begin
  InterlockedIncrement(FMootRefCount); (* to make it work when already 0 *)
  
  while InterlockedDecrement(FMootRefCount) >= 1 do begin
    RefUnderlyingObject;
  end;
  
  InterlockedDecrement(FMootRefCount);
end;

procedure TCustomDInterfacedObject.Destroyed;
begin
  (* override that *)
end;

destructor TCustomDInterfacedObject.Destroy;
begin
  if GetUnderlying <> nil then begin (* note that this requires self to hold a reference or else hell will break loose *)
    SinkUnderlyingObject; 
      
    UnrefAll;
  end;
  //end;
  
  Destroyed;
  
  inherited Destroy;
end;

procedure TCustomDInterfacedObject.UnrefAll;
begin
  InterlockedIncrement(FMineRefCount);
  while InterlockedDecrement(FMineRefCount) >= 1 do 
    UnrefUnderlyingObject;

  InterlockedDecrement(FMineRefCount);
end;

function TCustomDInterfacedObject.GetUnderlying: Pointer;
begin
  Result := Fobject;
end;

end.
