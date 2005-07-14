unit iugsignal;

interface
uses sysutils, ugtypes;

type
  ESignalUnknown = class(Exception)
  end;
  ESignalHandlerAlreadyConnected = class(Exception)
  end;
  TSignalHandlerID = GUint;
  TSignalID = GUint;
  IGSignal = interface
    function Add(cb: TMethod): TSignalHandlerID;
    function AddAfter(cb: TMethod): TSignalHandlerID;
    procedure Remove(cb: TMethod); overload;
    procedure Remove(id: TSignalHandlerID); overload;
    function Find(cb: TMethod): TSignalHandlerID;
    function IsConnected(cb: TMethod): Boolean;
    procedure Block(cb: TMethod); overload;
    procedure Unblock(cb: TMethod); overload;
    procedure Block(id: TSignalHandlerID); overload;
    procedure Unblock(id: TSignalHandlerID); overload;
    procedure Emit;
    //procedure Emit;
    function GetName: string;
    function GetID: TSignalID;
    property Name: string read getName;
    property ID: TSignalID read getID;
  end;
                    
implementation

end.
