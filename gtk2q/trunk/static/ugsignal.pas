unit ugsignal;

interface
uses iugsignal, ugobject, contnrs, classes, sysutils;

type
  // TODO: Two different signals may have the same name, if they have differing types.
  // 'private' class
  DSignalHandler = class;
  DCustomSignalHandler = class;
  DSignalHandlerClass = class of DCustomSignalHandler;

  // 'private' class
  DCustomSignal = class //, IGSignal)
  private
    Fname: string;
    //Fclosure: Pointer;
    Fid: TSignalID;
    Fowner: TObject;
    Fdata: TObjectList;
    //Fdata: TObjectList;
    // TODO map SignalHandlerID -> DSignalHandlerData

    procedure AddData(data: DCustomSignalHandler);
    procedure RemoveData(id: TSignalHandlerID);
    function FindData(id: TSignalHandlerID): DCustomSignalHandler;
  protected
    function FindByCallback(cb: TMethod): DSignalHandler;
    function Add(handlerclass: DSignalHandlerClass; cb: TMethod): TSignalHandlerID;
    function AddAfter(handlerclass: DSignalHandlerClass; cb: TMethod): TSignalHandlerID;
    procedure Remove(cb: TMethod); overload;
    function Find(cb: TMethod): TSignalHandlerID;
    function FindByReceiver(receiver: TObject): DSignalHandler; overload;
    function FindByReceiver(receiver: IInterface): DSignalHandler; overload;
    function IsConnected(cb: TMethod): Boolean; overload;
    procedure Block(cb: TMethod); overload;
    procedure Unblock(cb: TMethod); overload;
    procedure Remove(receiver: TObject); overload;
    procedure Remove(receiver: IInterface); overload;
    procedure Block(receiver: TObject); overload;
    procedure Block(receiver: IInterface); overload;
    procedure Unblock(receiver: TObject); overload;
    procedure Unblock(receiver: IInterface); overload;

  public
    constructor Create(owner: TGObject; signalName: string); //overloadoverride;
    destructor Destroy; override;
    procedure Remove(id: TSignalHandlerID); overload;
    procedure Block(id: TSignalHandlerID); overload;
    procedure Unblock(id: TSignalHandlerID); overload;
    function IsConnected(id: TSignalHandlerID): Boolean; overload;
    procedure Emit; // g_signal_emit
    procedure Handle(const closureintargs: array of const); virtual; // sloow
  protected
    function GetName: string;
  public
    function GetOwner: TObject;
    function GetID: TSignalID;
    property ID: TSignalID read GetID;
  published
    property Name: string read GetName;
  end;

  TObjectPropertyChangeCallback = procedure(Sender: TGObject; propertyName: string) of object;

  DPropertyChangedSignal = class(DCustomSignal)
  public
    function Add(cb: TObjectPropertyChangeCallback): TSignalHandlerID;
    function AddAfter(cb: TObjectPropertyChangeCallback): TSignalHandlerID;
    procedure Remove(cb: TObjectPropertyChangeCallback); overload;
    function Find(cb: TObjectPropertyChangeCallback): TSignalHandlerID;
    function IsConnected(cb: TObjectPropertyChangeCallback): Boolean;
    procedure Block(cb: TObjectPropertyChangeCallback); overload;
    procedure Unblock(cb: TObjectPropertyChangeCallback); overload;
    procedure Handle(const closureintargs: array of const); override;
  end;

  // TNotifyEvent=procedure(Sender: TObject) of object;
  DNotifySignal = class(DCustomSignal) 
  public (* TODO split before/after and call accordingly on Handle() *)
    function Add(cb: TNotifyEvent): TSignalHandlerID;
    function AddAfter(cb: TNotifyEvent): TSignalHandlerID;
    procedure Remove(cb: TNotifyEvent); overload;
    function Find(cb: TNotifyEvent): TSignalHandlerID;
    function IsConnected(cb: TNotifyEvent): Boolean;
    procedure Block(cb: TNotifyEvent); overload;
    procedure Unblock(cb: TNotifyEvent); overload;
    procedure Handle(const closureintargs: array of const); override;
  end;

  // handlers

  DCustomSignalHandler = class
  private
    Fid: TSignalHandlerID;
    Fsignal: DCustomSignal;
    Fcallback: TMethod; // no typesafety here
  public
    procedure SetSignal(ASignal: DCustomSignal);
    function GetID: TSignalHandlerID;
    function GetSignal: DCustomSignal;
    procedure GetCallback(out cb: TMethod);
    procedure Handle(const args: array of const); virtual; abstract;
    function ConnectClosure: TSignalHandlerID; virtual; abstract;
    procedure DisconnectClosure; virtual; abstract;
    property ID: TSignalHandlerID read GetID;
    property Signal: DCustomSignal read GetSignal;
    constructor Create(ASignal: DCustomSignal; ACallback: TMethod); virtual;
  end;

  DSignalHandler = class(DCustomSignalHandler) // this is a g signal handler
  protected
    Fclosure: Pointer; //PPasClosure;
    Fconnected: Boolean;
  public
    function CompareCallback(const cb: TMethod): Boolean;
    function CompareReceiver(const cbr: TObject): Boolean; overload;
    function CompareReceiver(const cbr: IInterface): Boolean; overload;
    destructor Destroy; override;
    function ConnectClosure: TSignalHandlerID; override;
    procedure DisconnectClosure; override;
    procedure Handle(const args: array of const); override;
    constructor Create(ASignal: DCustomSignal; ACallback: TMethod); overload; override;
  end;

  DNotifySignalHandler = class(DCustomSignalHandler) // this is a non-g signal handler (local, without c closure)
  public
    constructor Create(ASignal: DCustomSignal; ACallback: TMethod); override;
  end;

  DPropertyChangedSignalHandler = class(DSignalHandler) // this is a g signal handler
  public
    constructor Create(ASignal: DCustomSignal; ACallback: TMethod); override;
  end;

implementation
uses uwrapgnames, ugtypes;

{$ifdef gtk2q_standalone}
function g_signal_connect_closure(instance: Pointer; signalname: PGChar; closure: Pointer; after: gboolean): gulong; cdecl; external gobjectlib; // ?
// *_by_id
procedure g_signal_handler_block(instance:gpointer; handler_id:gulong); cdecl; external gobjectlib;
procedure g_signal_handler_unblock(instance:gpointer; handler_id:gulong); cdecl; external gobjectlib;
procedure g_signal_handler_disconnect(instance:gpointer; handler_id:gulong); cdecl; external gobjectlib;
function g_signal_handler_is_connected(instance:gpointer; handler_id:gulong):gboolean; cdecl; external gobjectlib;
{function g_signal_handler_find(instance: gpointer; mask: TGSignalMatchType;
           signal_id: guint; detail: TGQuark; closure: PWGClosure;
           func:gpointer; data:gpointer):gulong; cdecl; external gobjectlib;}
procedure g_signal_emit_by_name(instance:gpointer; detailed_signal:Pgchar; args:array of const); cdecl; overload; external gobjectlib;
{$endif gtk2q_standalone}


const
  E_SignalHandlerNotFound = 0; (* as distilled by gtk source *)

{ DCustomSignal }

function DCustomSignal.Add(handlerclass: DSignalHandlerClass; cb: TMethod): TSignalHandlerID;
var
  sh: DCustomSignalHandler;
begin
  sh := handlerclass.Create(Self, cb);
  Result := sh.ConnectClosure;
  AddData(sh);
end;

function DCustomSignal.AddAfter(handlerclass: DSignalHandlerClass; cb: TMethod): TSignalHandlerID;
var
  sh: DCustomSignalHandler;
begin
  sh := handlerclass.Create(Self, cb);
  Result := sh.ConnectClosure;
  AddData(sh);
end;

                
procedure DCustomSignal.Block(id: TSignalHandlerID);
begin
  if id = E_SignalHandlerNotFound then Exit;
  g_signal_handler_block((Fowner as TGObject).GetUnderlying, id);
end;

procedure DCustomSignal.Block(cb: TMethod);
begin
  Block(Find(cb));
end;

procedure MarshallCustomSignal(
  closure: PWGClosure; returnvalue: PWGValue; 
  nparamvalues: guint; 
  const paramvalues: PWGValue; 
  invocationhint, marshaldata: gpointer
); cdecl;
var
  cs: DCustomSignal;
begin
  cs := nil;
  
  // todo connect to the correct customsignal instance and handle the callback
  
  cs.Handle([closure, returnvalue, nparamvalues, paramvalues, invocationhint, marshaldata]);
end;

constructor DCustomSignal.Create(owner: TGObject; signalName: string);
begin
  owner.RegisterSignal(Self);
  Fowner := owner;
  Fname := signalName;
  if not Assigned(Fdata) then begin
    Fdata := TObjectList.Create;
    Fdata.OwnsObjects := True;
  end;
end;

destructor DCustomSignal.Destroy;
begin
  // Fdata clear

  FData.Clear;
  FData.Free;

  inherited;
end;

procedure DCustomSignal.Handle(const closureintargs: array of const);
begin
end;

function DCustomSignal.FindByReceiver(receiver: TObject): DSignalHandler;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then begin
        Result := Fdata[i] as DSignalHandler;
        Exit;
      end;
end;
function DCustomSignal.FindByReceiver(receiver: IInterface): DSignalHandler;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
(*$IFDEF FPCOLD*)
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then begin
(*$ELSE*)
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then begin
(*$ENDIF FPCOLD*)
        Result := Fdata[i] as DSignalHandler;
        Exit;
      end;
end;

function DCustomSignal.FindByCallback(cb: TMethod): DSignalHandler;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
(*$IFDEF FPCOLD*)
      if (Fdata[i] as DSignalHandler).CompareCallback(cb) then begin
(*$ELSE*)
      if (Fdata[i] as DSignalHandler).CompareCallback(cb) then begin
(*$ENDIF FPCOLD*)
        Result := Fdata[i] as DSignalHandler;
        Exit;
      end;
end;

function DCustomSignal.Find(cb: TMethod): TSignalHandlerID;
var
  sh: DSignalHandler;
begin
  sh := FindByCallback(cb);
  if Assigned(sh) then
    Result := sh.ID
  else
    Result := E_SignalHandlerNotFound;
end;

function DCustomSignal.GetID: TSignalID;
begin
  Result := Fid;
end;

function DCustomSignal.GetName: string;
begin
  Result := Fname;
end;

function DCustomSignal.IsConnected(cb: TMethod): Boolean;
begin
(*$IFDEF FPCOLD*)
  Result := IsConnected(Find(@cb));
(*$ELSE*)
  Result := IsConnected(Find(cb));
(*$ENDIF*)
end;

procedure DCustomSignal.Block(receiver: TObject);
var
  i: Integer;
begin
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then
        Block((Fdata[i] as DSignalHandler).ID);
end;

procedure DCustomSignal.Block(receiver: IInterface);
var
  i: Integer;
begin
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then
        Block((Fdata[i] as DSignalHandler).ID);
end;

procedure DCustomSignal.Unblock(receiver: TObject);
var
  i: Integer;
begin
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then
        Unblock((Fdata[i] as DSignalHandler).ID);
end;

procedure DCustomSignal.Unblock(receiver: IInterface);
var
  i: Integer;
begin
  for i := 0 to Fdata.Count - 1 do 
    if Fdata[i] is DSignalHandler then
      if (Fdata[i] as DSignalHandler).CompareReceiver(receiver) then
        Unblock((Fdata[i] as DSignalHandler).ID);
end;

procedure DCustomSignal.Remove(receiver: TObject);
var
  sh: DSignalHandler;
begin
  sh := FindByReceiver(receiver);
  while assigned(sh) do begin
    Remove(sh.ID);
    sh := FindByReceiver(receiver);
  end;
end;

procedure DCustomSignal.Remove(receiver: IInterface);
var
  sh: DSignalHandler;
begin
  sh := FindByReceiver(receiver);
  while assigned(sh) do begin
    Remove(sh.ID);
    sh := FindByReceiver(receiver);
  end;
end;

procedure DCustomSignal.Remove(cb: TMethod);
begin
(*$IFDEF FPCOLD*)
  if IsConnected(@cb) then
    Remove(Find(@cb));
(*$ELSE*)
  if IsConnected(cb) then
    Remove(Find(cb));
(*$ENDIF*)
end;

procedure DCustomSignal.Remove(id: TSignalHandlerID);
begin
  if id = E_SignalHandlerNotFound then Exit;

  RemoveData(id);
end;

procedure DCustomSignal.Unblock(cb: TMethod);
begin
  Unblock(Find(cb));
end;

procedure DCustomSignal.Unblock(id: TSignalHandlerID);
begin
  if id = E_SignalHandlerNotFound then Exit;
  g_signal_handler_unblock((Fowner as TGObject).GetUnderlying, id);
end;

procedure DCustomSignal.Emit;
begin
  if id = E_SignalHandlerNotFound then Exit;
  g_signal_emit_by_name((Fowner as TGObject).GetUnderlying, PGChar(PChar(Fname)), []);
end;


procedure DCustomSignal.AddData(data: DCustomSignalHandler);
var
  i: Integer;
begin
  // TODO optimize
  for i := 0 to Fdata.count - 1 do
    if Fdata[i] = data then Exit;

  FData.Add(data);
  //assert(data.id <> 0); ?
  // TODO
end;

procedure DCustomSignal.RemoveData(id: TSignalHandlerID);
var
  sh: DCustomSignalHandler;
begin
  sh := FindData(id);
  if not Assigned(sh) then Exit; // already gone

  sh.DisconnectClosure;
  sh.Free;
end;

function DCustomSignal.IsConnected(id: TSignalHandlerID): Boolean;
begin
  Result := g_signal_handler_is_connected((Fowner as TGObject).GetUnderlying, id);
end;

function DCustomSignal.GetOwner: TObject;
begin
  Result := Fowner;
end;

function DCustomSignal.FindData(
  id: TSignalHandlerID): DCustomSignalHandler;
var
  i: Integer;
begin
  // TODO optimize

  Result := nil;

  for i := 0 to Fdata.Count - 1 do
    if (Fdata[i] as DCustomSignalHandler).GetID = id then begin
      Result := Fdata[i] as DCustomSignalHandler;
      Break;
    end;

  // TODO implement find

end;

{ DPropertyChangedSignal }

function DPropertyChangedSignal.Add(
  cb: TObjectPropertyChangeCallback): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited Add(DPropertyChangedSignalHandler, TMethod(@cb));
(*$ELSE*)
  Result := inherited Add(DPropertyChangedSignalHandler, TMethod(cb));
(*$ENDIF FPCMODE*)
end;

function DPropertyChangedSignal.AddAfter(
  cb: TObjectPropertyChangeCallback): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited AddAfter(DPropertyChangedSignalHandler, TMethod(@cb));
(*$ELSE*)
  Result := inherited AddAfter(DPropertyChangedSignalHandler, TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DPropertyChangedSignal.Block(cb: TObjectPropertyChangeCallback);
begin
(*$IFDEF FPCMODE*)
  inherited Block(TMethod(@cb));
(*$ELSE*)
  inherited Block(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

function DPropertyChangedSignal.Find(
  cb: TObjectPropertyChangeCallback): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited Find(TMethod(@cb));
(*$ELSE*)
  Result := inherited Find(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

function DPropertyChangedSignal.IsConnected(
  cb: TObjectPropertyChangeCallback): Boolean;
begin
(*$IFDEF FPCMODE*)
  Result := inherited IsConnected(TMethod(@cb));
(*$ELSE*)
  Result := inherited IsConnected(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DPropertyChangedSignal.Remove(cb: TObjectPropertyChangeCallback);
begin
(*$IFDEF FPCMODE*)
  inherited Remove(TMethod(@cb));
(*$ELSE*)
  inherited Remove(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DPropertyChangedSignal.Unblock(
  cb: TObjectPropertyChangeCallback);
begin
(*$IFDEF FPCMODE*)
  inherited Unblock(TMethod(@cb));
(*$ELSE*)
  inherited Unblock(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DPropertyChangedSignal.Handle(const closureintargs: array of const);
begin
  // TODO
end;


// ============================= handlers =====================================
{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
type
  WGClosureMarshal = procedure(
    closure: PWGClosure; returnvalue: PWGValue;
    nparamvalues: guint;
    const paramvalues: PWGValue;
    invocationhint: gpointer
  ); cdecl;
  PPasClosure = ^TPasClosure;
  TPasClosure = record
    closure: WGClosure;
    handler: DSignalHandler;
    // extra data
  end;

procedure g_closure_sink(closure: PWGClosure); cdecl; external gobjectlib;
procedure g_closure_unref(closure: PWGClosure); cdecl; external gobjectlib;
function g_closure_ref(closure: PWGClosure): PWGClosure; cdecl; external gobjectlib;
procedure g_closure_invoke(
  closure: PWGClosure; returnvalue: PWGValue{out}; nparams: guint;
  paramvalues: PWGValue; invocationhint: gpointer
); cdecl; external gobjectlib;
procedure g_closure_invalidate(closure: PWGClosure); cdecl; external gobjectlib;
procedure g_closure_set_marshal(closure: PWGClosure; marshal: WGClosureMarshal); cdecl; external gobjectlib;
function g_closure_new_simple(size: guint; data: gpointer): PWGClosure; cdecl; external gobjectlib;
{$endif gtk2q_standalone}

procedure DCustomSignalMarshall(
    closure: PWGClosure; returnvalue: PWGValue;
    nparamvalues: guint;
    const paramvalues: PWGValue;
    invocationhint: gpointer;
    marshaldata: gpointer
  ); cdecl;
var
  sh: DSignalHandler;
begin
  (* find handler class for this closure (1:1 relationship) *)

  sh := PPasClosure(closure)^.handler;

  sh.Handle([closure, returnvalue, nparamvalues, paramvalues, invocationhint, marshaldata]);
end;

function pas_closure_new(data: gpointer): PPasClosure;
begin
  Result := PPasClosure(g_closure_new_simple(sizeof(TPasClosure), data));

  // g_closure_add_finalize_notifier
  g_closure_set_marshal(PWGClosure(Result), @DCustomSignalMarshall);
  //g_closure_add_marshal_guards();
end;
// then g_closure_sink, g_closure_unref

{ DSignalHandler }

constructor DSignalHandler.Create(ASignal: DCustomSignal; ACallback: TMethod);
begin
(*$IFDEF FPCOLD*)
  inherited Create(ASignal, @ACallback);
(*$ELSE*)
  inherited Create(ASignal, ACallback);
(*$ENDIF FPCOLD*)
  Fclosure := pas_closure_new(nil);
  g_closure_ref(Fclosure);
  PPasClosure(Fclosure)^.handler := Self;
end;

function DSignalHandler.ConnectClosure: TSignalHandlerID;
var
  signal: DCustomSignal;
begin
  if Fconnected then begin
    Result := Fid;
    Exit;
    (*raise ESignalHandlerAlreadyConnected.Create('signal handler is already connected');*)
  end;

  Fconnected := True;

  signal := GetSignal;
  Fid := g_signal_connect_closure ((signal.GetOwner as TGObject).GetUnderlying, PGChar(PChar(signal.GetName)), Fclosure, False);
  Result := Fid;
end;


destructor DSignalHandler.Destroy;
begin
  g_closure_sink(Fclosure);
  g_closure_unref(Fclosure);
  inherited;
end;

// Handle() is called by the DSignalHandleMarshall() function which is called
// from the g_closure_invoke()

procedure DSignalHandler.Handle(const args: array of const);
begin
  (* inherited; doesnt work on fpc *)

end;


procedure DSignalHandler.DisconnectClosure;
begin
  (* TODO lock *)
  if not Fconnected then Exit;
  Fconnected := False;
  g_signal_handler_disconnect((GetSignal.GetOwner as TGObject).GetUnderlying, Fid);

  (*inherited; abstract methods blahblah *)
end;

function DSignalHandler.CompareReceiver(const cbr: TObject): Boolean;
begin
  Result := Fcallback.Data = Pointer(cbr);
end;
function DSignalHandler.CompareReceiver(const cbr: IInterface): Boolean;
begin
  Result := Fcallback.Data = Pointer(cbr);
end;

function DSignalHandler.CompareCallback(const cb: TMethod): Boolean;
begin
(*$IFDEF FPCMODE*)
  Result := Fcallback = cb;
(*$ELSE*)
  Result := @Fcallback = @cb;
(*$ENDIF FPCMODE*)
end;

{ DPropertyChangedSignalHandler }

constructor DPropertyChangedSignalHandler.Create(ASignal: DCustomSignal;
  ACallback: TMethod);
begin
(*$IFDEF FPCOLD*)
  inherited Create(ASignal, @ACallback);
(*$ELSE*)
  inherited Create(ASignal, ACallback);
(*$ENDIF FPCOLD*)
end;

{ DCustomSignalHandler }

constructor DCustomSignalHandler.Create(ASignal: DCustomSignal;
  ACallback: TMethod);
begin
  Fsignal := ASignal;
  Fcallback := ACallback;
end;

procedure DCustomSignalHandler.GetCallback(out cb: TMethod);
begin
  cb := Fcallback;
end;

function DCustomSignalHandler.GetID: TSignalHandlerID;
begin
  Result := Fid;
end;

function DCustomSignalHandler.GetSignal: DCustomSignal;
begin
  Result := Fsignal;
end;

procedure DCustomSignalHandler.SetSignal(ASignal: DCustomSignal);
begin
  Fsignal := ASignal;
end;

{ DNotifySignalHandler }

constructor DNotifySignalHandler.Create(ASignal: DCustomSignal;
  ACallback: TMethod);
begin
  inherited;

end;

{ DNotifySignal }

function DNotifySignal.Add(cb: TNotifyEvent): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited Add(DPropertyChangedSignalHandler, TMethod(@cb));
(*$ELSE*)
  Result := inherited Add(DPropertyChangedSignalHandler, TMethod(cb));
(*$ENDIF FPCMODE*)
end;

function DNotifySignal.AddAfter(cb: TNotifyEvent): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited AddAfter(DPropertyChangedSignalHandler, TMethod(@cb));
(*$ELSE*)
  Result := inherited AddAfter(DPropertyChangedSignalHandler, TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DNotifySignal.Block(cb: TNotifyEvent);
begin
(*$IFDEF FPCMODE*)
  inherited Block(TMethod(@cb));
(*$ELSE*)
  inherited Block(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

function DNotifySignal.Find(cb: TNotifyEvent): TSignalHandlerID;
begin
(*$IFDEF FPCMODE*)
  Result := inherited Find(TMethod(@cb));
(*$ELSE*)
  Result := inherited Find(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DNotifySignal.Handle(const closureintargs: array of const);
var
  i: Integer;
begin
  inherited;

  // simulate gobject behaviour

  // todo randomize order ? [ for testing ]
  for i := 0 to Fdata.Count - 1 do
    (Fdata[i] as DCustomSignalHandler).Handle(closureintargs);
end;

function DNotifySignal.IsConnected(cb: TNotifyEvent): Boolean;
begin
(*$IFDEF FPCMODE*)
  Result := inherited IsConnected(TMethod(@cb));
(*$ELSE*)
  Result := inherited IsConnected(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DNotifySignal.Remove(cb: TNotifyEvent);
begin
(*$IFDEF FPCMODE*)
  inherited Remove(TMethod(@cb));
(*$ELSE*)
  inherited Remove(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

procedure DNotifySignal.Unblock(cb: TNotifyEvent);
begin
(*$IFDEF FPCMODE*)
  inherited Unblock(TMethod(@cb));
(*$ELSE*)
  inherited Unblock(TMethod(cb));
(*$ENDIF FPCMODE*)
end;

end.
