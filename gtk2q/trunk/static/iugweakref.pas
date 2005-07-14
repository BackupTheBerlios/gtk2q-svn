unit iugweakref;

interface
uses ugsignal, iug;

type
  TGObjectWeakRefGoneCallback = procedure(Sender: TObject) of object;
  IGWeakRefN = interface(IWeakRefN)
    ['{536BFF74-BD81-4065-9702-5CC47AAE6E1A}']
    (*
    procedure RegisterCallbackSimple(callback: TGObjectWeakRefGoneCallback);
    procedure UnregisterCallbackSimple(callback: TGObjectWeakRefGoneCallback);

    procedure RegisterCallback(forWho: TObject; callback: TGObjectWeakRefGoneCallback);
    procedure UnregisterCallback(forWho: TObject; callback: TGObjectWeakRefGoneCallback);
    *)
    (*function GetReffed: IGObject;*) (* quite slow right now *)

    function GetOnGoneSignal: DNotifySignal;
    property OnGone: DNotifySignal read GetOnGoneSignal;
  end;

implementation

end.
