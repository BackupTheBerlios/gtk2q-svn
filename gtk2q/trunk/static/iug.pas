unit iug;

interface
uses ugtypes; (*, iugobject;*)

type
  (*TIGClosureArray = array of IGClosure;*)

  IGInterface = interface
    ['{3A9AEC4D-5DC0-4FE3-BB27-1628B0146F87}']
    // TODO commonize this
    function GetUnderlying: Pointer;
  end;

(*$IFNDEF no_icloneable*)
  ICloneable = interface
    ['{49E2EE09-B4ED-44A9-9489-AB0E5B626390}']
    function Clone: ICloneable;
  end;
  IDisposable = interface
    ['{44F04A63-9D30-4B68-AA2D-D4072DADF672}']
    procedure Dispose;
  end;
(*$ENDIF no_icloneable*)

(*$IFNDEF no_iweakref*)
  IWeakRefN = interface(IInvokable)
    ['{89478CE8-7550-11D9-9893-00055DDDEA00}']
    function GetRefN: IInterface; (* quite slow right now *)
    procedure SetRefN(const value: IInterface);
    property RefN: IInterface read GetRefN write SetRefN;
  end;
                    
  INotifyWeakRefs = interface
    ['{B0024928-755E-11D9-8428-00055DDDEA00}']
    procedure RegisterWeakRef(const value: IWeakRefN);
    procedure UnregisterWeakRef(const value: IWeakRefN);
  end;
(*$ENDIF no_iweakref*)

implementation

end.
 