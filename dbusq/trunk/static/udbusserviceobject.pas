unit udbusobject;

interface
uses iudbus;

type
  TDBusServiceObject = class(?, IDBusServiceObject, IGObject?, IInterface)
    constructor Create(const busname: IDBusBusname; path: UTF8String);
  end;
  
implementation


constructor TDBusServiceObject.Create(const busname: IDBusBusname; path: UTF8String);
begin
  inherited;
end;

end.
