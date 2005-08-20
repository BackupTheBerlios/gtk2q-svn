unit udbusgproxy;

interface
uses iudbus, iug;

type
  TDBusGProxy = class(TGInterfacedObject, IDBusGProxy, IGObject, IInterface)
    constructor CreateForName(const connection: IDBusGConnection; name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
    constructor CreateForNameOwner(const connection: IDBusGConnection; name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
    constructor CreateFromProxy(const proxy: IDBusGProxy; pathName: UTF8String; interfaceName: UTF8String);
    constructor CreateForPeer(const connection: IDBusGConnection; pathName: UTF8String; interfaceName: UTF8String);
    procedure AddSignal(signalName: UTF8String; types: array of const); (* ????? FIXME *)
    
    procedure ConnectSignal(signalName: UTF8String; handler: TMethod); (*userdata, freee*)
    procedure DisconnectSignal(signalName: UTF8String; handler: TMethod);
    
    function Call(methodName: UTF8String; args: array of const): Boolean; (* raises exception *)
    procedure CallNoReply(methodName: UTF8String; args: array of const);
    
    function BeginCall(methodName: UTF8String; notify: data: destroy; args: array of const): IDBusGProxyCall;
    function EndCall(const call: IDBusGProxyCall; args: array of const{???}): Boolean; (* raises exception *)
    procedure CancelCall(const call: IDBusGProxyCall);
    
  protected
    
    procedure SetInterface(interfaceName: UTF8String); (* ????? FIXME *)
    function GetPath: UTF8String;
    function GetBusname: UTF8String;
    function GetInterface: UTF8String;
    
  published
    { dbus_g_method_return, dbus_g_method_return_error ? }
    
    property Path: UTF8String read GetPath;
    property Busname: UTF8String read GetBusname;
    property Interface: UTF8String read GetInterface write SetInterface; (* ugh. *)
  end;

implementation
uses uwrapdbusnames, uwrapgnames;

{$IFDEF gtk2q_standalone}
function dbus_g_proxy_get_type: TGType; cdecl; external dbusglib;

function dbus_g_proxy_new_for_name(connection: PWDBusGConnection;
                                   {const} name: PChar;
                                   {const} path: PChar;
                                   {cobst} interface1: PChar): PWDBusGProxy; cdecl; external dbusglib;

function dbus_g_proxy_new_for_name_owner(connection: PWDBusGConnection;
                                         {const} name: PChar;
                                         {const} path: PChar;
                                         {const} interface1: PChar;
                                         outerror: PPWGError): PWDBusGProxy; cdecl; external dbusglib;
                                         
function dbus_g_proxy_new_from_proxy        (DBusGProxy        *proxy,
                                                      const char        *interface,
                                                      const char        *path_name): PWDBusGProxy; cdecl; external dbusglib;
function dbus_g_proxy_new_for_peer          (DBusGConnection   *connection,
                                                      const char        *path_name,
                                                      const char        *interface_name): PWDBusGProxy; cdecl; external dbusglib;

procedure dbus_g_proxy_set_interface         (DBusGProxy        *proxy,
						      const char        *interface_name); cdecl; external dbusglib;

procedure dbus_g_proxy_add_signal            (DBusGProxy        *proxy,
						      const char        *signal_name,
						      GType              first_type, 
						      ...); cdecl; external dbusglib;

procedure dbus_g_proxy_connect_signal        (DBusGProxy        *proxy,
                                                      const char        *signal_name,
                                                      GCallback          handler,
                                                      void              *data,
                                                      GClosureNotify     free_data_func); cdecl; external dbusglib;
procedure dbus_g_proxy_disconnect_signal     (DBusGProxy        *proxy,
                                                      const char        *signal_name,
                                                      GCallback          handler,
                                                      void              *data); cdecl; external dbusglib;

(*
 * dbus_g_proxy_call:
 *
 * All of the input arguments are
 * specified first, followed by G_TYPE_INVALID, followed by all of the
 * output values, followed by G_TYPE_INVALID.
 *
 * @param proxy a proxy for a remote interface
 * @param method method to invoke
 * @param error return location for an error
 * @param first_arg_type type of first "in" argument
 * @returns #FALSE if an error is set, TRUE otherwise
*)						      
function dbus_g_proxy_call                  (DBusGProxy        *proxy,
						      const char        *method,
						      GError           **error,
						      GType              first_arg_type,
						      ...): gboolean; cdecl; external dbusglib;

procedure dbus_g_proxy_call_no_reply         (DBusGProxy        *proxy,
                                                      const char        *method,
                                                      GType              first_arg_type,
                                                      ...); cdecl; external dbusglib;

function dbus_g_proxy_begin_call(proxy: PWDBusGProxy;
                                 {const} method1: PChar;
                                 notify1: WDBusGProxyCallNotify;
                                 data: gpointer;
                                 destoy1: WGDestroyNotify;
                                 firstArgType: TGType;
                                 args: array of const): PWDBusGProxyCall; cdecl; external dbusglib;

function dbus_g_proxy_end_call(proxy: PWDBusGProxy;
                               call: PWDBusGProxyCall;
                               error: PPWGError;
                               firstArgType: TGType;
                               args: array of const): gboolean; cdecl; external dbusglib;
                                                      
procedure dbus_g_proxy_cancel_call(proxy: PWDBusGProxy; call: PWDBusGProxyCall); cdecl; external dbusglib;

function dbus_g_proxy_get_path(proxy: WDBusGProxy): PChar{const}; cdecl; external dbusglib;

function dbus_g_proxy_get_bus_name(proxy: WDBusGProxy): PChar{const}; cdecl; external dbusglib;

function dbus_g_proxy_get_interface(proxy: WDBusGProxy): PChar{const}; cdecl; external dbusglib;

(* typedef struct _DBusGMethodInvocation DBusGMethodInvocation; *)

{
procedure dbus_g_method_return               (DBusGMethodInvocation *context, ...); cdecl; external dbusglib;
procedure dbus_g_method_return_error         (DBusGMethodInvocation *context, GError *error); cdecl; external dbusglib;
}

{$ENDIF gtk2q_standalone}

constructor TDBusGProxy.CreateForName(const connection: IDBusGConnection; name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
begin
  inherited Create;
  
  setWrapped(dbus_g_proxy_new_for_name(connection.GetUnderlying, name, pathName, interfaceName));
end;

constructor TDBusGProxy.CreateForNameOwner(const connection: IDBusGConnection; name: UTF8String; pathName: UTF8String; interfaceName: UTF8String);
var
  error: PWGError;
begin
  inherited Create;
  error := nil;
  
  setWrapped(dbus_g_proxy_new_for_name_owner(connection.GetUnderlying, 
    name, pathName, interfaceName, @error));
  if Assigned(error) then begin
    HandleAndFreeGError(error, EDBusGError);
  end;
end;

constructor TDBusGProxy.CreateFromProxy(const proxy: IDBusGProxy; pathName: UTF8String; interfaceName: UTF8String);
begin
  inherited Create;
  
  setWrapped(dbus_g_proxy_new_from_proxy(proxy.GetUnderlying, interfaceName, pathName));
end;

constructor TDBusGProxy.CreateForPeer(const connection: IDBusGConnection; pathName: UTF8String; interfaceName: UTF8String);
begin
  inherited Create;
  
  setWrapped(dbus_g_proxy_new_for_peer(connection.GetUnderlying, pathName, interfaceName));
end;

procedure TDBusGProxy.AddSignal(signalName: UTF8String; types: array of const); (* ????? FIXME *)
begin
  dbus_g_proxy_add_signal(fObject, types + [G_TYPE_INVALID]);
end;
    
procedure TDBusGProxy.ConnectSignal(signalName: UTF8String; handler: TMethod); (*userdata, freee*)
begin
  dbus_g_proxy_connect_signal(fObject, FIXME);
end;

procedure TDBusGProxy.DisconnectSignal(signalName: UTF8String; handler: TMethod);
begin
  dbus_g_proxy_disconnect_signal(fObject, FIXME);
end;
    
function TDBusGProxy.Call(methodName: UTF8String; args: array of const): Boolean; (* raises exception *)
begin
  Result := dbus_g_proxy_call(fObject, FIXME);
  TODO exception ?
end;

procedure TDBusGProxy.CallNoReply(methodName: UTF8String; args: array of const);
begin
  dbus_g_proxy_call_no_reply(fObject, FIXME);
end;
    
function TDBusGProxy.BeginCall(methodName: UTF8String; notify: data: destroy; args: array of const): IDBusGProxyCall;
begin
  Result := dbus_g_proxy_begin_call(fObject, PChar(methodName), FIXME);
  TODO exception ?
end;

function TDBusGProxy.EndCall(const call: IDBusGProxyCall; args: array of const{???}): Boolean; (* raises exception *)
begin
  Result := dbus_g_proxy_end_call(fObject, call.GetUnderlying, FIXME);
  TODO exception ?
end;

procedure TDBusGProxy.CancelCall(const call: IDBusGProxyCall);
begin
  dbus_g_proxy_cancel_call(fObject, call.GetUnderlying);
end;
    
procedure TDBusGProxy.SetInterface(interfaceName: UTF8String); (* ????? FIXME *)
begin
  dbus_g_proxy_set_interface(fObject, PChar(interfaceName));
end;

function TDBusGProxy.GetPath: UTF8String;
begin
  Result := dbus_g_proxy_get_path(fObject);
  // do not free
end;

function TDBusGProxy.GetBusname: UTF8String;
begin
  Result := dbus_g_proxy_get_bus_name(fObject);
  // do not free
end;

function TDBusGProxy.GetInterface: UTF8String;
begin
  Result := dbus_g_proxy_get_interface(fObject);
  // do not free
end;


(* "The DBusGConnection should never be unreffed, it lives once and is shared amongst the process".
   idiotic but true. give them a cluebat how to do singletons... *)
   
end.
