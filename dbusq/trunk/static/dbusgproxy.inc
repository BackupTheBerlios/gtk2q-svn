(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IDBusGProxyCall = interface(IPointerMediator)
    ['{DB3214BC-1184-11DA-8739-00055DDDEA00}']
    function GetOwner: IDBusGProxy;
    property Owner: IDBusGProxy read GetOwner;
    // strong owner ref
  end;
  
  IDBusGProxy = interface(IGObject)
    ['{9FA28720-1183-11DA-8783-00055DDDEA00}']
    //constructor CreateForName(connection: IDBusGConnection; name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
    //constructor CreateForNameOwner(name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
    //constructor CreateFromProxy(const proxy: IDBusGProxy; pathName: UTF8String; interfaceName: UTF8String);
    //constructor CreateForPeer(pathName: UTF8String; interfaceName: UTF8String);
    
    procedure SetInterface(interfaceName: UTF8String); (* ????? FIXME *)
    procedure AddSignal(signalName: UTF8String; types: array of const); (* ????? FIXME *)
    
    procedure ConnectSignal(signalName: UTF8String; handler: TMethod); (*userdata, freee*)
    procedure DisconnectSignal(signalName: UTF8String; handler: TMethod);
    
    function Call(methodName: UTF8String; args: array of const): Boolean; (* raises exception *)
    procedure CallNoReply(methodName: UTF8String; args: array of const);
    
    function BeginCall(methodName: UTF8String; notify: TDBusGProxyCallNotify; {data;} args: array of const): IDBusGProxyCall;
    function EndCall(const call: IDBusGProxyCall; args: array of const{???}): Boolean; (* raises exception *)
    procedure CancelCall(const call: IDBusGProxyCall);
    
    function GetPath: UTF8String;
    function GetBusname: UTF8String;
    function GetInterface: UTF8String;
    
    { dbus_g_method_return, dbus_g_method_return_error ? }
    
    property Path: UTF8String read GetPath;
    property Busname: UTF8String read GetBusname;
    property Interface1: UTF8String read GetInterface write SetInterface; (* ugh. *)
    
  end;
(*$ENDIF define_types*)

(*$IFDEF define_implementation*)
(*$ENDIF define_implementation*)
