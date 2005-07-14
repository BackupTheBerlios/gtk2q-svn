{$ifdef a_define_interface_uses}
, iugsignal, ugsignal
{$endif a_define_interface_uses}
{$ifdef a_define_types}
  _SIGNAL_MAP_KEY = TSignalHandlerID;
  _SIGNAL_MAP_VALUE = THighCallback;
  _SIGNAL_INTERFACE = interface
    function Add(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHandlerID;
    function AddAfter(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHanderID;
    procedure Remove(cb: _SIGNAL_CUSTOM_CALLBACK);
    procedure Remove(id: TSignalHandlerID);
    function Find(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHandlerID;
    function IsConnected(cb: _SIGNAL_CUSTOM_CALLBACK): Boolean;
    procedure Block
    procedure Unblock
    procedure Emit;
    function GetName: string;
    function GetID: TSignalID;
    property Name: string read GetName;
    property ID: TSignalID read GetID;
  end;
  _SIGNAL_CLASS = class(DCustomSignal, _SIGNAL_INTERFACE, IGSignal, IInterface)
    function Add(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHandlerID;
    function AddAfter(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHanderID;
    procedure Remove(cb: _SIGNAL_CUSTOM_CALLBACK);
    procedure Remove(id: TSignalHandlerID);
    function Find(cb: _SIGNAL_CUSTOM_CALLBACK): TSignalHandlerID;
    function IsConnected(cb: _SIGNAL_CUSTOM_CALLBACK): Boolean;
    procedure Block
    procedure Unblock
    procedure Emit;
    function GetName: string;
    function GetID: TSignalID;
    property Name: string read GetName;
    property ID: TSignalID read GetID;
  end;
{$endif a_define_types}
{$ifdef a_define_implementation}
{$endif a_define_implementation}
