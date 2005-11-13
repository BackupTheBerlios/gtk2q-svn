unit utyperegistry;

interface
uses ugobject, ugtypes, iugobject, sysutils;

function DGTypeKnown(const agtype: TGType): Boolean;
procedure DTypeRegister(name, namespace: string; someclass: TGObjectClass; agtype: TGType; const iface: TGuid);
function WrapGObject(nativeobject: Pointer; atleastordesc: TGObjectClass = nil): IGObject; (* will use existing if possible *)
function GObjectGetExistingWrapper(nativeobject: Pointer): TGObject;

function DCreateInstance(name, namespace: string): IGObject; overload;
function DCreateInstance(const iface: TGUID): IGObject; overload;

function DNewTypeInfo(classSize: Cardinal): Pointer{PWGTypeInfo}; overload;

procedure DGlobalTypeRegisterLock;
procedure DGlobalTypeRegisterUnlock;

//function DGetTypes: ITypeRegistry; //overload;

implementation
uses uwrapgnames, uapplication, iutyperegistry;

type
  {DTypeRegistryNamespace = class
    : DTypeRegistryEntryArray;
  end;}
  DTypeRegistryEntry = record
    name: string;
    namespace: string;
    someclass: TGObjectClass;
    agtype: TGType;
    iface: TGuid;
  end;
  DTypeRegistryEntryArray = array of DTypeRegistryEntry;
  DTypeRegistry = class //(TInterfacedObject, ITypeRegistry, IInterface)
  private
    //: DTypeRegistryNamespace;
    Fentries: DTypeRegistryEntryArray;
    Fspecialentries: DTypeRegistryEntryArray;
  public
    //class function Create: IInterface;
  public
    (* special are classes that are specialized here and have no direct gtype association *)
    procedure AddSpecial(name, namespace: string; someclass: TGObjectClass; agtype: TGType; const iface: TGUID);
    function FindSpecial(name, namespace: string): TGObjectClass;

    procedure Add(name, namespace: string; someclass: TGObjectClass; agtype: TGType; const iface: TGuid);
    function Find(name, namespace: string): TGObjectClass;
    function HasNamespace(name: string): Boolean;
    function FindGType(agtype: TGType): TGObjectClass;


    function FindSpecialInterface(const iface: TGUID): TGObjectClass;
    function FindInterface(const iface: TGUID): TGObjectClass;

    function CreateInstance(name, namespace: string): IGObject; overload;
    function CreateInstance(const iface: TGUID): IGObject; overload;

    function HasGType(agtype: TGType): Boolean;

    //constructor CreateInstance;
  end;

var
  FTypeRegistry: DTypeRegistry = nil;

procedure EnsureAvailable;
begin
  if not Assigned(FTypeRegistry) then begin
    Application.Init;
    FTypeRegistry := DTypeRegistry.Create;
  end;
end;

function typeRegistryID(name, namespace: string): string;overload;
begin
  Result := namespace + '.' + name;
end;

function typeRegistryID(re: DTypeRegistryEntry): string; overload;
begin
  Result := typeRegistryID(re.name, re.namespace);
end;

function GObjectGetExistingWrapper(nativeobject: Pointer): TGObject;
begin
  Result := TGObject.GetWrapperDirect(nativeobject);
end;

function WrapGObject(nativeobject: Pointer; atleastordesc: TGObjectClass = nil): IGObject;
var
  oc: TGObjectClass;
  i: IGObject;
begin
 // TODO optimize by looking to the 'atleastordesc' gtype first
 
  EnsureAvailable;

 // TODO check atleastordesc
  //Result := nil;
  oc := FTypeRegistry.FindGType(G_TYPE_FROM_INSTANCE(nativeobject));
  
  (* TODO TGtkFileChooserDialogCreateWrapped for filechooserdialogs ! *)
  (* TODO TGtkFileChooserWidgetCreateWrapped for filechooserwidgets ! *)

  if not Assigned(oc) then
    raise EGTypeNotFound.Create('that gtype was not found');

  i := oc.GetWrapper(nativeobject);
  if Assigned(i) then begin
    Result := i;
    g_object_unref(nativeobject); // unref the reference the called held because the wrapped has already the master reference
  end else
    Result := oc.CreateWrapped(nativeobject);
end;

procedure DTypeRegister(name, namespace: string; someclass: TGObjectClass; agtype: TGType; const iface: TGuid);
var
  ogtype: TGType;
  xname, xnamespace: string;
begin
  EnsureAvailable;
  if not FTypeRegistry.HasNamespace(namespace) then begin
    //if namespace = 'gtk' then
    //  Application.Init;
  end;
  
  // get rid of gdkdrawable to make gdkwindow take precedence to gdkdrawable. ugh.
  // (since gdk_drawable_get_type and gdk_window_get_type are the same, return te same time - 
  //  one simulates the other)
  if Assigned(someclass) and (someclass.ClassName = 'TGdkDrawable') then Exit; 
  
  if Assigned(someclass) then
    ogtype := someclass.OverrideGType
  else
    ogtype := 0;

  xname := name;
  xnamespace := namespace;
  
  if ogtype <> 0 then begin
    xname := someclass.ClassName;
    (* iface := nil; dummy FIXME *)
    if (xnamespace = 'gtk') or (xnamespace = 'gdk') or (xnamespace = 'atk')
    or (xnamespace = 'gdk-pixbuf') then
      xnamespace := 'unknown'; (* TODO warning *)
  end else
    ogtype := agtype;
    
  if not Assigned(FTypeRegistry.Find(xname, xnamespace)) then
    FTypeRegistry.Add(xname, xnamespace, someclass, ogtype, iface);
end;

function DCreateInstance(const iface: TGUID): IGObject;
begin
  EnsureAvailable;
  Result := FTypeRegistry.CreateInstance(iface);
end;

function DCreateInstance(name, namespace: string): IGObject;
begin
  EnsureAvailable;
  Result := FTypeRegistry.CreateInstance(name, namespace);
end;

{function DGetTypes: ITypeRegistry; overload;
begin
  Result := FTypeRegistry;
end;}

{ DTypeRegistry }

(* special are classes that are specialized here and have no direct gtype association *)
procedure DTypeRegistry.AddSpecial(name, namespace: string; 
  someclass: TGObjectClass; agtype: TGType; 
  const iface: TGuid); 
begin
  assert(agtype <> 0);
  assert(someclass <> nil);
  assert(name <> '');
  assert(namespace <> '');
  
  SetLength(Fspecialentries, Length(Fspecialentries) + 1);
  Fspecialentries[High(Fspecialentries)].name := name;
  Fspecialentries[High(Fspecialentries)].namespace := namespace;
  Fspecialentries[High(Fspecialentries)].agtype := agtype;
  Fspecialentries[High(Fspecialentries)].someclass := someclass;
  Fspecialentries[High(Fspecialentries)].iface := iface;
  
end;

function DTypeRegistry.FindSpecial(name, namespace: string): TGObjectClass;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(Fspecialentries) do begin
    if (Fspecialentries[i].name = name) and (Fspecialentries[i].namespace = namespace) then begin
      Result := Fspecialentries[i].someclass;
      Break;
    end;
  end;
end;

procedure DTypeRegistry.Add(name, namespace: string;
  someclass: TGObjectClass; agtype: TGType; 
  const iface: TGuid);
begin
  if Assigned(Find(name,namespace)) then Exit;
  if Assigned(FindGType(agtype)) then begin
    // warn that already registered
  end;

  SetLength(Fentries, Length(Fentries) + 1);
  Fentries[High(Fentries)].name := name;
  Fentries[High(Fentries)].namespace := namespace;
  Fentries[High(Fentries)].agtype := agtype;
  Fentries[High(Fentries)].someclass := someclass;
  Fentries[High(Fentries)].iface := iface;
end;

function DTypeRegistry.FindInterface(const iface: Tguid): TGObjectClass;
var
  i: Integer;
begin
  Result := FindSpecialInterface(iface);
  if Assigned(Result) then Exit;
  
  for i := Low(Fentries) to High(Fentries) do
    if (GUIDToString(Fentries[i].iface) = GUIDToString(iface)) then begin
      Result := Fentries[i].someclass;
      Exit;
    end;
end;

function DTypeRegistry.FindSpecialInterface(const iface: TGUID): TGObjectClass;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(Fspecialentries) do begin
    if (GUIDToString(Fspecialentries[i].iface) = GUIDToString(iface)) then begin
      Result := Fspecialentries[i].someclass;
      Break;
    end;
  end;
end;

function DTypeRegistry.Find(name, namespace: string): TGObjectClass;
var
  i: Integer;
begin
  Result := FindSpecial(name, namespace);
  if Assigned(Result) then Exit;
  
  for i := Low(Fentries) to High(Fentries) do
    if (Fentries[i].name = name) and (Fentries[i].namespace = namespace) then begin
      Result := Fentries[i].someclass;
      Exit;
    end;
end;

function DTypeRegistry.FindGType(agtype: TGType): TGObjectClass;
var
  i: Integer;
begin
  Result := nil;
  for i := Low(Fentries) to High(Fentries) do
    if (Fentries[i].agtype = agtype) then begin
      Result := Fentries[i].someclass;
      Exit;
    end;
end;



function DTypeRegistry.HasNamespace(const name: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Fentries) to High(Fentries) do
    if (Fentries[i].namespace = name) then begin
      Result := True;
      Exit;
    end;
end;

function DTypeRegistry.CreateInstance(const iface: TGUID): IGObject;
var
  someclass: TGObjectClass;
begin
  Result := nil;
  //if not HasNamespace(name) then Exit;

  someclass := FindInterface(iface);
  
  if Assigned(someclass) then
    Result := someclass.Create as IGObject
  else
    raise EGTypeNotFound.Create('gtype for interface not found');
end;

function DTypeRegistry.CreateInstance(name, namespace: string): IGObject;
var
  someclass: TGObjectClass;
begin
  Result := nil;
  if not HasNamespace(name) then Exit;

  someclass := Find(name, namespace);
  
  if Assigned(someclass) then
    Result := someclass.Create as IGObject
  else
    raise EGTypeNotFound.Create(Format('class %s.%s gtype not found', [namespace, name]));
end;

function DGTypeKnown(agtype: TGType): Boolean;
begin
  EnsureAvailable;
  Result := FTypeRegistry.HasGType(agtype);
end;

function DTypeRegistry.HasGType(agtype: TGType): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Fspecialentries) to High(Fspecialentries) do 
    if Fspecialentries[i].agtype = agtype then begin
      Result := True;
      Break;
    end;

  for i := Low(Fentries) to High(Fentries) do 
    if Fentries[i].agtype = agtype then begin
      Result := True;
      Break;
    end;
end;


procedure DGlobalTypeRegisterLock;
begin (* thread stuff... todo *)
end;

procedure DGlobalTypeRegisterUnlock;
begin (* thread stuff... todo *)
end;

function DNewTypeInfo(classSize: Cardinal): Pointer{PWGTypeInfo}; overload;
var
  ti: PWGTypeInfo;
begin
  ti := g_new0(sizeof(WGTypeInfo), 1);
  ti^.classSize := classSize;
  Result := ti;
end;

initialization
  FTypeRegistry := DTypeRegistry.Create;

finalization
  FTypeRegistry.Free;
  FTypeRegistry := nil;
  
end.
