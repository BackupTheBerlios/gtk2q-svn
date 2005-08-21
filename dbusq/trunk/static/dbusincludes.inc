{$ifdef define_types}
type
  IDBusGProxy = interface;
  IDBusGProxyCall = interface;
  {$INCLUDE objdbuscallback.inc}
  
{$endif define_types}
{$INCLUDE dbusserviceobject.inc}
{$INCLUDE dbusbusname.inc}
{$INCLUDE dbusgproxy.inc}
{$INCLUDE dbusgconnection.inc}
