unit ugweakref;

interface
uses ugobject, iugweakref, iugobject, ugtypes, ugsignal, iug;


type
  TGObjectWeakRefData = record (* hmpf *)
    (* FIXME using obj like that is probably wrong. it should be a weakbackref ;) *)
    //obj: IInterface; (* this is the one that registered the callback, to keep him alive until he noticed what he must *)
    callback: TGObjectWeakRefGoneCallback;
  end;
  (* TODO use list? *)
  TGObjectWeakRefDataArray = array of TGObjectWeakRefData;
  
  DGWeakRef = class(TGObject, IGWeakRefN, IWeakRefN, INotifyWeakRefs, IGObject, IInterface)
  private
    (* TODO timer to uncache the reffedobject *)
    Fotherobject: Pointer{PWGObject};
    (*Fcallbacks: TGObjectWeakRefDataArray;*)
    Freffed: IInterface; (* only valid a short time *)
    Freftime: TDateTime;

    Flock: Integer;
    Ftimer: guint;
  protected
    FCreateLockSignalOnGone: Integer;
    FSignalOnGone: DNotifySignal;
  public
    function GetRefN: IInterface;
    procedure SetRefN(const value: IInterface);
    function QueryInterface(const IID: TGUID; out obj): HRESULT; stdcall;
    (* Todo OnGone *)

    constructor Create; overload; override;
    constructor Create(const o: IGObject); reintroduce; overload;
    destructor Destroy; override;
  protected
    procedure CleanupReffed; (* call with lock held *)
    function Lock: Boolean;
    procedure Unlock;
    function GetOnGoneSignal: DNotifySignal;
  protected
    procedure Gone; virtual;
  published
    property OnGone: DNotifySignal read GetOnGoneSignal;
  end;

implementation
uses uwrapgnames, uincdec, utyperegistry, sysutils;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
procedure g_object_weak_ref(obj: PWGObject; notify: WGWeakNotify; data: Pointer); cdecl; external gobjectlib;
procedure g_object_weak_unref(anobject: PWGObject; notify: WGWeakNotify; data: Pointer); cdecl; external gobjectlib;

(* TODO: wrap that, then remove that *)
type
  TGSourceFunc = function(data: gpointer): gboolean; cdecl;

procedure g_source_remove(source: guint); cdecl; external glib;
function g_timeout_add(interval: guint; func: TGSourceFunc; data: gpointer): guint; external glib;
{$endif gtk2q_standalone}

procedure mynotify(wr: DGWeakRef; wheretheobjectwas: TGObject); cdecl;
begin
  wr.Gone;
end;

procedure DGWeakRef.Gone;
begin
  if Assigned(Fotherobject) then begin
    Fotherobject := nil;

    if Assigned(FSignalOnGone) then
      FSignalOnGone.Emit;
  end;
end;

{
procedure DGWeakRef.RegisterCallback(forWho: TObject; callback: TGObjectWeakRefGoneCallback);
begin
  SetLength(Fcallbacks, Length(Fcallbacks) + 1);
  Fcallbacks[High(Fcallbacks)].callback := callback;
end;

procedure DGWeakRef.UnregisterCallback(forWho: TObject; callback: TGObjectWeakRefGoneCallback);
var
  i: Integer;
  j: Integer;
begin
  for i := Low(Fcallbacks) to High(Fcallbacks) do begin
    if (Fcallbacks[i].callback = callback) and (Fcallbacks[i].forWho = forWho) then begin
      for j := i + 1 to High(Fcallbacks) do
        Fcallbacks[j - 1] := Fcallbacks[j];

      SetLength(Fcallbacks, Length(Fcallbacks) - 1);
      Break;
    end;
  end;
end;
}

function GoAroundAndStealStuff(ref: DGWeakRef): gboolean; cdecl;
var
  done: Boolean;
begin
  done := False;
  if ref.Lock then begin
    ref.CleanupReffed;
    ref.Unlock;
  end;
  done := True;
  Result := done; (* FIXME is that "keep" ? *)
end;

constructor DGWeakRef.Create;
begin
  inherited Create;
  Fotherobject := nil;
end;

constructor DGWeakRef.Create(const o: IGObject);
begin
  inherited Create;

  Fotherobject := o.GetUnderlying;
  (* if not Assigned(Fotherobject) then TODO errors? *)
  g_object_weak_ref(Fotherobject, WGWeakNotify(@mynotify), Self);

  Ftimer := g_timeout_add(500, @GoAroundAndStealStuff, Self);
end;

destructor DGWeakRef.Destroy;
begin
  if Ftimer <> 0 then begin
    g_source_remove(Ftimer);
    Ftimer := 0;
  end;

  if Assigned(Fotherobject) then
    (* didnt fire, so its still here and we dont want it to fire on inherited destroy (yet) 
       since that has not been designed (registering a weakref to oneself for oneself) *)
    FSignalOnGone.Free;

  inherited Destroy;  
end;

procedure DGWeakRef.CleanupReffed; (* call with lock held *)
begin
  Freffed := nil; (* that does much more than it looks like, believe me ;) *)
end;

procedure DGWeakRef.SetRefN(const value: IInterface);
var
  p: Pointer;
begin
  if InterlockedIncrement(Flock) = 1 then begin
    try
      (* TODO atomize *)
      p := fOtherObject;
      fOtherObject := nil;
  
      if Assigned(p) then begin
        g_object_weak_unref(p, WGWeakNotify(@mynotify), Self);
      end;
     
      p := (value as IGObject).GetUnderlying;
      (* if not Assigned(Fotherobject) then TODO errors? *)
      g_object_weak_ref(p, WGWeakNotify(@mynotify), Self);
      fOtherObject := p;
    except
      InterlockedDecrement(Flock);
    end;
  end else InterlockedDecrement(Flock);
end;

function DGWeakRef.GetRefN: IInterface;
begin
  if InterlockedIncrement(Flock) = 1 then begin
    try
      if not Assigned(Freffed) then begin
        Freffed := WrapGObject(Fotherobject) as IInterface;
        Freftime := Now;
      end;
    finally
      InterlockedDecrement(Flock);
    end;
  end else InterlockedDecrement(Flock);
  Result := Freffed;
end;

{$IFDEF FPC}
const E_NOINTERFACE: HRESULT = HRESULT($80004002);
{$ENDIF FPC}

function DGWeakRef.QueryInterface(const IID: TGUID; out obj): HRESULT; stdcall;
var
  o: IInterface;
begin
(*
  - IGWeakRef self

  - IGObject derived stuff delegate to TGObjectGetOrCreateWrapper Fotherobject
      - cached for a bit time

  - other error
*)

  if GetInterface(IID, obj) then
    Result := 0 (* S_OK it seems *)
  else begin
    o := GetRefN;
    if Assigned(o) then
      Result := o.QueryInterface(IID, obj)
    else
      Result := E_NoInterface;
  end;
end;

function DGWeakRef.Lock: Boolean;
begin
  Result := False;
  if InterlockedIncrement(Flock) = 1 then
    Result := True
  else
    InterlockedDecrement(Flock);
end;

procedure DGWeakRef.Unlock;
begin
  InterlockedDecrement(Flock);
end;

{
procedure DGWeakRef.RegisterCallbackSimple(
  callback: TGObjectWeakRefGoneCallback);
begin
  RegisterCallback(nil, callback);
end;

procedure DGWeakRef.UnregisterCallbackSimple(
  callback: TGObjectWeakRefGoneCallback);
begin
  UnregisterCallback(nil, callback);
end;
}

function DGWeakRef.GetOnGoneSignal: DNotifySignal;
begin
  if not Assigned(FSignalOnGone) then begin
    if InterlockedIncrement(FCreateLockSignalOnGone) = 1 then
      FSignalOnGone := DNotifySignal.Create(Self, 'gone');
      
    InterlockedDecrement(FCreateLockSignalOnGone);
  end;
  Result := FSignalOnGone;
end;

end.
