unit udbusbus;

interface
uses iudbus;

// USE udbusgconnection

(* those connect to an existing bus *)

type
  TCustomDBusBus = class(, IDBusBus)
  protected
    constructor Create(which: TDBusBusType);
  published
    function GetObject(path: UTF8String): IDBusObject;
  end;
  
  TDBusSessionBus = class(TCustomBusBus, ...)
    constructor Create;
  end;
  
  TDBusSystemBus = class(TCustomBusBus, ...)
    constructor Create;
  end;
  
  TDBusBus = class(TCustomBusBus, ...)
  public
    constructor Create(which: TDBusBusType);
  
  end;
  
implementation
uses uwrapdbusnames, udbusgproxy;

{$ifdef dbusq_standalone}
function ; cdecl; external;
{$endif dbusq_standalone}

// ======================== TCustomDBusBus

constructor TCustomDBusBus.Create(which: TDBusBusType);
begin
  inherited Create;
  TODO
end;

function TCustomDBusBus.GetObject(path: UTF8String): IDBusObject;
begin
  TODO
  Result := ;
end;

// ======================== TDBusSessionBus

constructor TDBusSessionBus.Create;
begin
  inherited Create(bSession);
end;

// ======================== TDBusSystemBus

constructor TDBusSystemBus.Create;
begin
  inherited Create(bSession);
end;
  
// ======================== TDBusBus

constructor TDBusBus.Create; 
begin
  inherited Create;
end;

end.
