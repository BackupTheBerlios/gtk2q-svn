unit udbustypes;

interface

type
  TDBusErrorCode = (
  (* WARNING: in dbus, this is generated. dbus-glib-error-enum.h *)

  ecFailed,
  ecNoMemory,
  ecServiceUnknown,
  ecNameHasNoOwner,
  ecNoReply,
  ecIoError,
  ecBadAddress,
  ecNotSupported,
  ecLimitsExceeded,
  ecAccessDenied,
  ecAuthFailed,
  ecNoServer,
  ecTimeout,
  ecNoNetwork,
  ecAddressInUse,
  ecDisconnected,
  ecInvalidArgs,
  ecFileNotFound,
  ecUnknownMethod,
  ecTimedOut,
  ecMatchRuleNotFound,
  ecMatchRuleInvalid,
  ecSpawnExecFailed,
  ecSpawnForkFailed,
  ecSpawnChildExited,
  ecSpawnChildSignaled,
  ecSpawnFailed,
  ecUnixProcessIdUnknown,
  ecInvalidSignature,
  ecSelinuxSecurityContextUnknown,
  ecRemoteException
);
  
implementation

end.
