unit upointermediator;

interface
uses iupointermediator;

type // sigh. dont use if not really really *really* needed
  TPointerMediatorFreeFunc = procedure(obj: Pointer); cdecl;
  TPointerMediator = class(TInterfacedObject)
  protected
    FPtr: Pointer;
    FFreeFunc: TPointerMediatorFreeFunc;
  public
    constructor Create(ptr: Pointer; freefunc: TPointerMediatorFreeFunc); virtual;
    function GetUnderlying: Pointer;
    destructor Destroy; override;
    //class function Create: IPointerMediator;
  end;

implementation

constructor TPointerMediator.Create(ptr: Pointer; freefunc: TPointerMediatorFreeFunc);
begin
  inherited Create;
  FPtr := ptr;
  FFreeFunc := freefunc;
end;

function TPointerMediator.GetUnderlying: Pointer;
begin
  Result := FPtr;
end;

destructor TPointerMediator.Destroy;
begin
  if Assigned(FPtr) then begin
    if Assigned(FFreeFunc) then
      FFreeFunc(FPtr);
    FPtr := nil;
  end;
  inherited;
end;

end.
 