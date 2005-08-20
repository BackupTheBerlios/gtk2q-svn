unit udbusgconnection;

interface

type
  TCustomDBusGConnection = class(TGInterfacedObject?, IDBusGConnection, IGObject?, IInterface) (* dont *)
  protected
    procedure constructWrapped1(which: TDBusBusType);
  end;
  
  TDBusSessionGConnection = class(TDBusGConnection)
  protected
    procedure constructWrapped; override;
  end;

  TDBusSystemGConnection = class(TDBusGConnection)
  protected
    procedure constructWrapped; override;
  end;
  
implementation
uses uwrapdbusnames, uwrapgnames, iug;

(* need g_type_init *)

{$ifdef dbusq_standalone}
function dbus_g_bus_get(which: WDBusBusType; error: PPWGError): PWDBusGConnection; cdecl; external dbusglib;
{$endif dbusq_standalone}

var
  reffedOnce: Boolean = False; (* fixme *)
  
procedure TCustomDBusGConnection.constructWrapped1(which: TDBusBusType);
var
  cerror: PWGError;
  cptr: PWGObject;
begin
  inherited Create;
  cerror := nil;
  cptr := dbus_g_bus_get(which, @cerror);
  if not reffedOnce then begin
    reffedOnce := True;
    g_object_ref(cptr); (* idiotic workaround for an idiotic problem. see ending comment *)
  end;
  setWrapped(cptr);
  if Assigned(cerror) then begin
    HandleAndFreeGError(cerror, EDBusGError); (* raises *)
  end;
end;


procedure TDBusSessionGConnection.constructWrapped;
begin
  constructWrapped1(sSession);
end;

procedure TDBusSystemGConnection.constructWrapped;
begin
  constructWrapped1(sSession);
end;

(* "The DBusGConnection should never be unreffed, it lives once and is shared amongst the process".
   idiotic but true. *)

end.
