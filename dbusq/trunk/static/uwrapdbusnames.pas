unit uwrapdbusnames;

interface
uses uwrapgnames;

{$INCLUDE clinksettings.inc}

(* glib centric *)


(*
need GError
need g_type_init
need g_error_free
(need g_printerr)
need g_strfreev
need g_object_unref
need G_TYPE_INVALID
*)

type
  WDBusBusType = gint; (* enum *)
(*  WDBusBusType = (bSession, bSystem, bStarter); *)
  

DBUS_SERVICE_DBUS
DBUS_PATH_DBUS
DBUS_INTERFACE_DBUS

DBUS_GERROR == gerror domain
DBUS_GERROR_REMOTE_EXCEPTION == gerror code
  gboolean         dbus_g_error_has_name    (GError      *error,
                                             const char  *name);
                                             
  dbus_g_error_get_name(gerror)
  gerror->message
  

function dbus_g_bus_get(which: WDBusBusType; 
                        outerror: PPWGError
): PWDBusGConnection; cdecl;

function dbus_g_proxy_new_for_name(
  connection: PWDBusGConnection; 
  serviceName: UTF8String; 
  objectPath: UTF8String;
  interface1Name: UTF8String): PWDBusGProxy; cdecl; 

function dbus_g_proxy_call(proxy: PWDBusGProxy;
                           name: PG?Char;
                           outerror: PWGError;
                           send: array of const (* terminated by G_TYPE_INVALID *),
                           receive: array of const (* terminated by G_TYPE_INVALID *),
): gboolean; cdecl;

function dbus_g_error_quark; TGQuark; cdecl;

(* ex.
 if (!dbus_g_proxy_call (proxy, "Foobar", &error,
                          G_TYPE_INT, 42, G_TYPE_STRING, "hello",
			  G_TYPE_INVALID,
			  DBUS_TYPE_G_UCHAR_ARRAY, &arr, G_TYPE_INVALID))
    {
*)
(* DBUS_TYPE_G_UCHAR_ARRAY -> & GArray* *)
(* DBUS_TYPE_G_STRING_STRING_HASH -> GHashTable *)
(* G_TYPE_STRV -> null terminated array of char* *)
(* variant:

 GValue val = {0, };

 if (!dbus_g_proxy_call (proxy, "GetVariant", &error, G_TYPE_INVALID,
                          G_TYPE_VALUE, &val, G_TYPE_INVALID))
*)

dbus_g_proxy_begin_call  ;cdecl;
dbus_g_proxy_connect_signal ;cdecl;
dbus_g_proxy_add_signal ;cdecl;
dbus_g_object_register_marshaller ; cdecl;
function dbus_g_error_has_name(error: PWGError; name: PChar): gboolean; cdecl;
function dbus_g_error_has_name(error: PWGError; name: PChar): PChar(*const*); cdecl;

procedure dbus_g_error_domain_register(domain: TGQuark;
                                       {const} defaultInterface: PChar;
                                      codeEnum: TGType); cdecl;

procedure dbus_g_connection_register_g_object(connection: PWDBusGConnection;
                                              {const} atPath: PChar;
                                              object1: PWGObject); cdecl;

function dbus_g_connection_lookup_g_object(connection; PWDBusGConnection;
                                           {const} atPath: PChar): PWGObject; cdecl;

procedure dbus_g_object_register_marshaller(marshaller: WGClosureMarshal;
                                            rettype: TGType;
                                            args: array of const); cdecl;

procedure dbus_g_object_register_marshaller_array(marshaller: WGClosureMarshal;
                                                  rettype: TGType;
                                                  ntypes: guint;
                                                  const types: PGType{array}); cdecl;

(*
procedure dbus_g_thread_init; cdecl;
*)

(*
async

dbus_g_proxy_begin_call.
This returns a DBusGPendingCall object; 
you may then set a notification function using 
dbus_g_pending_call_set_notify.

signals

You may connect to signals using dbus_g_proxy_add_signal 
and dbus_g_proxy_connect_signal. 
You must invoke dbus_g_proxy_add_signal to specify the 
signature of your signal handlers; you may then invoke 
dbus_g_proxy_connect_signal multiple times.
 
Note that it will often be the case that there is no 
builtin marshaller for the type signature of a remote 
signal. In that case, you must generate a marshaller 
yourself by using glib-genmarshal, and then register 
it using dbus_g_object_register_marshaller.
*)
 
(*
Error handling and remote exceptions

All of the GLib binding methods such as dbus_g_proxy_end_call return a GError. This GError can represent two different things:

    *
    
          An internal D-BUS error, such as an out-of-memory condition, an I/O error, or a network timeout. Errors generated by the D-BUS library itself have the domain DBUS_GERROR, and a corresponding code such as DBUS_GERROR_NO_MEMORY. It will not be typical for applications to handle these errors specifically.
              *
              
                    A remote D-BUS exception, thrown by the peer, bus, or service. D-BUS remote exceptions have both a textual "name" and a "message". The GLib bindings store this information in the GError, but some special rules apply.
                    
                          The set error will have the domain DBUS_GERROR as above, and will also have the code DBUS_GERROR_REMOTE_EXCEPTION. In order to access the remote exception name, you must use a special accessor, such as dbus_g_error_has_name or dbus_g_error_get_name. The remote exception detailed message is accessible via the regular GError message member. 
*)

type
  PWDBusGConnection = ^WDBusGConnection;
  WDBusGConnection = record (* C *)
    TODO
  end;
  PWDBusGProxy = ^WDBusGProxy;
  WDBusGProxy = record (* C *)
    TODO
  end;
  PWDBusGPendingCall = ^WDBusGPendingCall;
  WDBusGPendingCall = record (* C *)
    TODO
  end;
  
  PWDBusGProxyCall = ^WDBusGProxyCall;
  WDBusGProxyCall = record (* C *)
    TODO
  end;
  
  PWDBusGProxy = PWGObject;
  PWDBusGProxyCall = Pointer; // ??!
  WDBusGProxyCallNotify = procedure(proxy: PWDBusGProxy; callId: PWDBusGProxyCall; userdata: Pointer); cdecl;
  
 
implementation

end.
