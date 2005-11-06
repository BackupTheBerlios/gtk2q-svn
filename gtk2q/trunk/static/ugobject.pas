unit ugobject;

interface
uses iugobject, drefcounter, ugvalue, ugtypes, contnrs, iug;

{$M+} // RTTI type info

type
  TGObject = class(TCustomDInterfacedObject, IGObject, IGUserData, INotifyWeakRefs, IInvokable, IInterface)
  private
    //FDummyInterface: IGObject;
    FUsedSignals: TObjectList;
  public
    constructor CreateWrapped(original: Pointer); virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  protected // 'callbacks'
    procedure Created; virtual;
  public
    procedure RegisterWeakRef(const value: IWeakRefN);
    procedure UnregisterWeakRef(const value: IWeakRefN);
            
    function ObjectGetAnyProperty(name: string; wantgtype: Integer): WGValue;
    procedure ObjectSetAnyProperty(name: string; const value: WGValue);
    function ObjectGetBoolProperty(name: string): Boolean;
    procedure ObjectSetBoolProperty(name: string; const value: Boolean);
    function ObjectGetByteProperty(name: string): Byte;
    procedure ObjectSetByteProperty(name: string; const value: Byte);
    function ObjectGetIntProperty(name: string): Integer;
    procedure ObjectSetIntProperty(name: string; const value: Integer);
    function ObjectGetUIntProperty(name: string): Cardinal;
    procedure ObjectSetUIntProperty(name: string; const value: Cardinal);
    function ObjectGetObjectUnwrappedProperty(name: string): Pointer; // GObject
    function ObjectGetObjectProperty(name: string): IGObject;
    procedure ObjectSetObjectUnwrappedProperty(name: string; const value: Pointer); // GObject
    procedure ObjectSetObjectProperty(name: string; const value: IGObject);
    function ObjectGetStringProperty(name: string): UTF8String;
    procedure ObjectSetStringProperty(name: string; const value: UTF8String);
    function ObjectGetFloatProperty(name: string): Single;
    procedure ObjectSetFloatProperty(name: string; const value: Single);
    function ObjectGetDoubleProperty(name: string): Double;
    procedure ObjectSetDoubleProperty(name: string; const value: Double);
    function ObjectGetGStrvProperty(name: string): TUTF8StringArray;
    procedure ObjectSetGStrvProperty(name: string; const value: TUTF8StringArray);

  public
    (* registers a signal to be freed again later on. this does not mean every signal is in there. 
       Just every _used_ signal. *)
    procedure RegisterSignal(signal: TObject{DCustomSignal});
  protected
    procedure constructWrapped; virtual;
    procedure setWrapped(obj: Pointer{PWGObject}); virtual;
    procedure unsetWrapped; virtual;
  protected
    procedure UnrefUnderlyingObject; override;
    procedure RefUnderlyingObject; override;
  protected
  public
    class function OverrideGType: TGType; virtual; (* 0: not *)
    class procedure TypeRegister; virtual; (* flat! from nothing to one *)
    //class function GetOrCreateWrapped(original: PWGObject): IGObject; virtual;
    //destructor Destroy; override;
    class function GetWrapper(obj: Pointer{PWGObject}): IGObject;
    class function GetWrapperDirect(obj: Pointer{PWGObject}): TGObject;
    procedure Destroyed; override;
    //function Connect(signal: string; slot: TSlot): Integer; // dont.
    //destructor Destroy; override; // fixme return value

    procedure FreezeNotify;
    procedure ThawNotify;
    procedure Notify(propertyName: string);

  protected
    function GetUserData(const key: UTF8String): IInterface;
    procedure SetUserData(const key: UTF8String; const v: IInterface);
  
  public
    (* User Data Stuff *)
    function GetUserDataVariant(const key: UTF8String): Variant;
    procedure SetUserDataVariant(const key: UTF8String; const v: Variant);
    
  (*$IFNDEF FPC*)
  (*published*)
  (*$ENDIF FPC*)
    property UserData[const key: UTF8String]: IInterface read GetUserData write SetUserData;
  end;
  TGObjectClass = class of TGObject;

procedure g_object_unref(anobject: Pointer); cdecl;
function g_object_ref(anobject: Pointer): Pointer; cdecl;

procedure g_object_set(anObject: Pointer; first_property_name:Pointer{PGChar}; args:array of const); cdecl;
procedure g_object_get(anObject: Pointer; first_property_name:Pointer{PGchar}; args:array of const); cdecl;

implementation
uses uwrapgnames, sysutils, utyperegistry, unicegvalue, uapplication, ugsignal,
variants;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
procedure g_object_unref(anobject: Pointer); cdecl; external gobjectlib;
function g_object_ref(anobject: Pointer): Pointer; cdecl; external gobjectlib;
procedure g_object_set(anObject: Pointer; first_property_name:Pointer; args:array of const); cdecl; overload; external gobjectlib;
procedure g_object_get(anObject: Pointer; first_property_name:Pointer; args:array of const); cdecl; overload; external gobjectlib;

type
  TGDestroyNotify = procedure(data: pointer); cdecl;

// gobject
function g_object_get_data(anobject: PWGObject; key: PGChar): pointer; cdecl; external gobjectlib;
procedure g_object_set_data(anobject: PWGObject; key: PGChar; data: pointer); cdecl; external gobjectlib;
procedure g_object_set_data_full(anobject: PWGObject; key: PGChar; data: pointer; destroy: TGDestroyNotify); cdecl; external gobjectlib;
procedure g_object_get_property(anobject: PWGObject; propertyname: PGChar; value: PWGValue); cdecl; external gobjectlib;
procedure g_object_set_property(anobject: PWGObject; propertyname: PGChar; value: PWGValue); cdecl; external gobjectlib;
procedure g_object_freeze_notify(anobject: PWGObject); cdecl; external gobjectlib;
procedure g_object_thaw_notify(anobject: PWGObject); cdecl; external gobjectlib;
procedure g_object_notify(anobject: PWGObject; name: PGChar); cdecl; external gobjectlib;
procedure g_object_set_qdata(anobject: PWGObject; quark: TGQuark; data: gpointer); cdecl; external gobjectlib;
function g_object_get_qdata(anobject: PWGObject; quark: TGQuark): gpointer; cdecl; external gobjectlib;

{$endif gtk2q_standalone}

{ TGObject }

class function TGObject.OverrideGType: TGType;
begin
  Result := 0;
end;

function TGObject.ObjectGetIntProperty(name: string): Integer;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_INT);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetIntProperty(name: string; const value: Integer);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_INT);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;

function TGObject.ObjectGetGStrvProperty(name: string): TUTF8StringArray;
var
  cstrv: PGStrv;
begin
  g_object_get(fObject, PChar(name), [@cstrv, nil]);
  Result := UTF8StringArrayFromStrv(cstrv);
end;

procedure TGObject.ObjectSetGStrvProperty(name: string; const value: TUTF8StringArray);
var
  cstrv: PGStrv;
begin
  cstrv := StrvFromUTF8StringArray(value);
  g_object_set(fObject, PChar(name), [cstrv, nil]);
  g_strfreev(cstrv);
end;


{function TGObject.Connect(signal: string; slot: TSlot): Integer;
begin
  Result := g_signal_connect_swapped(Fobject, PGChar(PChar(signal)), G_CALLBACK (@slot), nil);
end;}

procedure TGObject.RegisterSignal(signal: TObject{DCustomSignal});
begin
  (* TODO thread safety! *)
  if not Assigned(FUsedSignals) then begin
    FUsedSignals := TObjectList.Create;
    FUsedSignals.OwnsObjects := True;
  end;
  
  FUsedSignals.Add(signal);
end;
    
destructor TGObject.Destroy;
begin
  (* TODO thread safe? *)
  FUsedSignals.Free;
  
  inherited Destroy;
end;

constructor TGObject.Create;
var
  didref: Boolean;
begin
  inherited Create;
  didref := False;
  try
    constructWrapped;
    assert(Assigned(Fobject));
    g_object_ref(Fobject); (* hold a reference so that Created; will 
      not make the gobject vanish before one can poke it (after construction) *)
    didref := True;
    Created;
  except
    if didref then
      g_object_unref(Fobject);
  end;
  
  (* the TGObject original instance holds one (1) reference to the native object *)
  (* this one reference will be released in the Destroy destructor *)
end;

class function TGObject.GetWrapperDirect(obj: Pointer{PWGObject}): TGObject;
begin
(*
  Result := TGObject(g_object_get_data(obj, PGChar(PChar('p-wrapper'))));
*)
  Result := TGObject(g_object_get_qdata(obj, PasWrapperQuark));
end;

class function TGObject.GetWrapper(obj: Pointer): IGObject;
var
  kobj: TGObject;
begin
(*
  kobj := TGObject(g_object_get_data(obj, PGChar(PChar('p-wrapper'))));
*)
  kobj := TGObject(g_object_get_qdata(obj, PasWrapperQuark));
  Result := (kobj) as IGObject;
end;

procedure TGObject.setWrapped(obj: Pointer);
begin
  // obj = PWGObject!
  Fobject := obj;
  (*
  g_object_set_data(fObject, PGChar(PChar('p-wrapper')), Self);
  *)
  g_object_set_qdata(fObject, PasWrapperQuark, Self);
  FixRefCount;
end;

function TGObject.ObjectGetAnyProperty(name: string; wantgtype: Integer): WGValue;
var
  prop: PGChar;
begin
  prop := PGChar(PChar(name));
  Result := gValueInit(wantgtype);
  g_object_get_property(Fobject, prop, @Result);
end;

procedure TGObject.ObjectSetAnyProperty(name: string; const value: WGValue);
var
  prop: PGChar;
begin
  prop := PGChar(PChar(name));
  g_object_set_property (Fobject, prop, @value);
end;

procedure TGObject.ObjectSetBoolProperty(name: string; const value: Boolean);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_BOOLEAN);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;
function TGObject.ObjectGetUIntProperty(name: string): Cardinal;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_UINT);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetUIntProperty(name: string; const value: Cardinal);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_UINT);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;

function TGObject.ObjectGetStringProperty(name: string): UTF8String;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_STRING);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetStringProperty(name: string; const value: UTF8String);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_STRING);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;

function TGObject.ObjectGetDoubleProperty(name: string): Double;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_DOUBLE);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetDoubleProperty(name: string; const value: Double);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_DOUBLE);
  try
    gValueSetValue(gval, value);
  finally
    ObjectSetAnyProperty(name, gval);
    gValueUnset(gval);
  end;
end;

function TGObject.ObjectGetFloatProperty(name: string): Single;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_FLOAT);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetFloatProperty(name: string; const value: Single);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_FLOAT);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;


function TGObject.ObjectGetBoolProperty(name: string): Boolean;
var
  prop: WGValue;
  b: LongBool;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_BOOLEAN);
  try
    gValueGetValue(prop, b);
    Result := b;
  finally
    gValueUnset(prop);
  end;
end;

function TGObject.ObjectGetObjectUnwrappedProperty(name: string): Pointer;
var
  prop: WGValue;
  obj: PWGObject;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_OBJECT);
  try
    gValueGetValue(prop, obj); // TODO ref counting?
    assert(G_TYPE_CHECK_INSTANCE_TYPE(obj, G_TYPE_OBJECT));
    Result := obj;
  finally
    gValueUnset(prop);
  end;
end;

function TGObject.ObjectGetObjectProperty(name: string): IGObject;
var
  cwidget: Pointer;
begin
  cwidget := ObjectGetObjectUnwrappedProperty(name);
  if not Assigned(cwidget) then
    Result := nil
  else
    {GetOrCreateWrapped}
    Result := WrapGObject(cwidget) as IGObject; // FIXME getwrapped?
end;


procedure TGObject.ObjectSetObjectUnwrappedProperty(name: string;
  const value: Pointer);
var
  gval: WGValue;
begin
  //assert(g_type_check_instance_is_a(value, G_TYPE_OBJECT));
  //assert(G_TYPE_CHECK_INSTANCE_TYPE(value, G_TYPE_OBJECT)); // or derived
  gval := gValueInit(G_TYPE_OBJECT);
  try
    gValueSetValue(gval, PWGObject(value));
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;

{class function TGObject.GetOrCreateWrapped(original: PWGObject): IGObject;
begin
  Result := GetWrapper(original);
  if not Assigned(Result) then
    Result := CreateWrapped(original) as IGObject;
end;}

{destructor TGObject.Destroy;
begin
end;}

procedure TGObject.ObjectSetObjectProperty(name: string; const value: IGObject);
begin
  ObjectSetObjectUnwrappedProperty(name, value.GetUnderlying);
end;

constructor TGObject.CreateWrapped(original: Pointer);
begin
  setWrapped(original);
  Created; (* somewhat :) also to make gtkobject take over ownership of the initial reference *)
  //FDummyInterface := Self as IGObject;
end;

procedure TGObject.Created;
begin

end;

procedure TGObject.Destroyed;
begin
  if Assigned(Fobject) then begin
    unsetWrapped;
    g_object_unref(Fobject);
  end;
  //inherited Destroy;
  Fobject := nil;
  inherited;
end;


procedure TGObject.unsetWrapped;
begin
  if Assigned(Fobject) then
    g_object_set_data(Fobject, PGChar(PChar('p-wrapper')), nil);
end;

procedure TGObject.constructWrapped;
begin
  raise EAbstractError.Create('TGObject cannot be instantiated. Use TGObject.CreateWrapped for a wrapper');
end;

class procedure TGObject.TypeRegister;
begin
  GtkApplicationInit;
  // hmm g_object_type_register
end;

function TGObject.ObjectGetByteProperty(name: string): Byte;
var
  prop: WGValue;
begin
  prop := ObjectGetAnyProperty(name, G_TYPE_UCHAR);
  try
    gValueGetValue(prop, Result);
  finally
    gValueUnset(prop);
  end;
end;

procedure TGObject.ObjectSetByteProperty(name: string; const value: Byte);
var
  gval: WGValue;
begin
  gval := gValueInit(G_TYPE_UCHAR);
  try
    gValueSetValue(gval, value);
    ObjectSetAnyProperty(name, gval);
  finally
    gValueUnset(gval);
  end;
end;

procedure TGObject.FreezeNotify;
begin
  g_object_freeze_notify(GetUnderlying);
end;

procedure TGObject.Notify(propertyName: string);
begin
  g_object_notify(GetUnderlying, PGChar(PChar(propertyName)));
end;

procedure TGObject.ThawNotify;
begin
  g_object_thaw_notify(GetUnderlying);
end;

(* User Data Stuff *)

const
  ITYPE_VARIANT = 7;
  ITYPE_IINTERFACE = 9;

function TGObject.GetUserDataVariant(const key: UTF8String): Variant;
var
  typekey: UTF8String;
  valkey: UTF8String;
  typ: TVarType;
  va: gpointer;
begin
  typekey := 'p-type-' + key;
  valkey := 'd-' + key;
  typ := gint(g_object_get_data(Fobject, PGChar(PChar(typekey))));
  assert(typ = ITYPE_VARIANT);
  va := g_object_get_data(Fobject, PGChar(PChar(valkey)));
  if not Assigned(va) then
    raise EUserDataNotFound.Create(Format('Userdata %s not found', [key]));
  Result := PVariant(va)^;
end;

function TGObject.GetUserData(const key: UTF8String): IInterface;
var
  typekey: UTF8String;
  valkey: UTF8String;
  typ: TVarType;
  va: gpointer;
begin
  typekey := 'p-type-' + key;
  valkey := 'd-' + key;
  typ := gint(g_object_get_data(Fobject, PGChar(PChar(typekey))));
  assert(typ = ITYPE_IINTERFACE);
  va := g_object_get_data(Fobject, PGChar(PChar(valkey)));
  if not Assigned(va) then
    raise EUserDataNotFound.Create(Format('Userdata %s not found', [key]));
  Result := IInterface(va);
end;

procedure myIInterfaceVarDestroy(what: gpointer); cdecl;
var
  v: IInterface;
begin
  v := IInterface(what);
  v._Release;
  (* will be decrefed now *)
end;

procedure myVariantVarDestroy(what: gpointer); cdecl;
var
  v: Variant;
begin
  v := PVariant(what)^;
  (* will be decrefed now *)
end;

procedure TGObject.SetUserDataVariant(const key: UTF8String; const v: Variant);
var
  typekey: UTF8String;
  valkey: UTF8String;
begin
  typekey := 'p-type-' + key;
  valkey := 'd-' + key;
  
  g_object_set_data(Fobject, PGChar(PChar(typekey)), gpointer(ITYPE_VARIANT));
  g_object_set_data_full(Fobject, PGChar(Pchar(valkey)), gpointer(PVariant(@v)), myVariantVarDestroy);
  (* TODO incref the variant *)
end;

procedure TGObject.SetUserData(const key: UTF8String; const v: IInterface);
var
  typekey: UTF8String;
  valkey: UTF8String;
begin
  typekey := 'p-type-' + key;
  valkey := 'd-' + key;
  
  v._AddRef;
  
  g_object_set_data(Fobject, PGChar(PChar(typekey)), gpointer(ITYPE_IINTERFACE));
  g_object_set_data_full(Fobject, PGChar(Pchar(valkey)), gpointer(v), myIInterfaceVarDestroy);
end;



procedure TGObject.UnrefUnderlyingObject;
begin
  g_object_unref(PWGObject(Fobject));
end;

procedure TGObject.RefUnderlyingObject;
begin
  g_object_ref(PWGObject(Fobject));
end;

procedure TGObject.RegisterWeakRef(const value: IWeakRefN);
begin
  (* TODO *)
end;

procedure TGObject.UnregisterWeakRef(const value: IWeakRefN);
begin
  (* TODO *)
end;

(* freeuserdata? *)

initialization
  DGlobalTypeRegisterLock;
  TGObject.TypeRegister;
  DGlobalTypeRegisterUnlock;

finalization
      
end.
