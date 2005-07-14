unit ugclosure;

(* crap *)

interface
uses drefcounter, iugobject, iug;

type
  //IGInterfacedObject,
  //IGObject,  
  DGCustomClosure = class(TCustomGInterfacedObject, IGClosure, IInterface)
  private
    Fcontainerobject: IGObject;
    FClosureSize: Cardinal;
    FClosure: Pointer;
  protected
    //procedure constructWrapped; override;
    procedure UnrefUnderlyingObject; override;
    procedure RefUnderlyingObject; override;
    //procedure setWrapped(obj: Pointer); // PGClosure
  public
    //procedure Invoke; //virtual;
    procedure Sink;
  end;
  // when deriving, use: class function Create(aobject: IGObject): IGClosure;, set Fcontainerobject and Fclosuresize

  DGPropertyNotificationClosure = class(DGCustomClosure, IGClosure, IGObject, IInterface)
  protected
    procedure constructWrapped; override;
  public
    constructor Create(AObject: IGObject); override;
    destructor Destroy; override;
  end;
  
  DGClosure = class(DGCustomClosure, IGClosure, IGObject, IInterface)
  public
  end;
  
implementation
uses glib2;

procedure DGCustomClosure.UnrefUnderlyingObject;
begin
  g_closure_unref(PGClosure(Fobject));
end;

procedure DGCustomClosure.Sink;
begin
  g_closure_sink(PGClosure(Fobject));
end;

procedure DGCustomClosure.RefUnderlyingObject;
begin
  g_closure_ref(PGClosure(Fobject));
end;

procedure DGCustomClosure.constructWrapped;
begin
  Fobject := g_closure_new_object(FClosureSize, Fcontainerobject.GetUnderlying);
  FixRefCount;
end;

{procedure DGCustomClosure.Invoke;
begin
  g_closure_invoke(PGClosure(Fobject));
end;}

// DGPropertyNotificationClosure = class(DGCustomClosure, IGClosure, IGObject, IInterface)

type
  PGPropertyNotificationClosureInternal = ^TGPropertyNotificationClosureInternal;
  TGPropertyNotificationClosureInternal = record
    closure: TGClosure;
    
  end;

procedure MarshalPropertyNotification(
	closure: PGClosure;
	value: PGValue;  nParamValues: GUInt;  paramvalues: PGValue;
	invocation_hint: gpointer; marshal_data: gpointer); cdecl;
begin
  //Writeln(str(nParamValues));
end;

destructor DGPropertyNotificationClosure.Destroy;
begin
  Dispose(FObject);
  inherited Destroy;
end;
  
constructor DGPropertyNotificationClosure.Create(AObject: IGObject);
begin
  inherited Create;
  New(PGPropertyNotificationClosureInternal);
  FClosureSize := sizeof(TGPropertyNotificationClosureInternal);
end;

procedure DGPropertyNotificationClosure.constructWrapped;
beign
  inherited;
  //PGPropertyNotificationClosureInternal(Fobject)^
end;

end.
