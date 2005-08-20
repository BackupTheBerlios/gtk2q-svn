unit udbusbus;

interface
uses iudbus;

(* for dbus service *)

type
  TDBusBusname = class(, IDBusBusname)
    constructor Create(const bus: IDBus; name: UTF8String);
  end;
  
implementation

end.
