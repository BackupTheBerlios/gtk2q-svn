unit ugststructure;

interface
uses sysutils, ugtypes, upointermediator, iupointermediator;

type
  TGstStructure = class;
  TGstStructureFieldsProxy = class(TInterfacedObject, IGstStructureFieldsProxy, IInterface)
  protected
    fOwner: TGstStructure;
  protected
    function GetField(const key: UTF8String): Variant;
    procedure SetField(const key: UTF8String; const value: Variant);
    function GetCount: Integer;
    procedure Clear;
  published
    constructor Create(Owner: TGstStructure);
    property Fields[const key: UTF8String]: Variant read GetField write SetField; default;
    property Count: Integer read GetCount;
  end;

  { TGstStructure }

  TGstStructure = class(TPointerMediator, IPointerMediator, IGstStructure, ICloneable, IPointerMediator, IInterface)
    // TODO foreach
    // TODO map_in_place
    
    destructor Destroy; override;
    
    procedure RemoveField(const key: UTF8String);
    // TODO RemoveFields
    
    function HasField(const key: UTF8String): Boolean;
    function HasFieldTyped(const key: UTF8String; atype: TVarType): Boolean;
    function GetInteger(const key: UTF8String): Integer;
    function GetDouble(const key: UTF8String): Double;
    function GetFourcc(const key: UTF8String): guint32;
    function GetString(const key: UTF8String): UTF8String; // fixme guaranteed?
    function GetBoolean(const key: UTF8String): Boolean;
    function GetValue(const key: UTF8String): Variant;
    function GetType(const key: UTF8String): TVarType;
    function GetCount: Integer;
    
    // TODO id_get_value
    // TODO id_set_value
    // TODO gst_structure_set_parent_refcount
    
    function ToString: UTF8String;
    constructor CreateFromString(const string: UTF8String);
    constructor CreateFromString(const string: UTF8String; out endpos: Integer);
    
    function Clone: ICloneable;
    constructor Create;
    
    procedure Clear;
    
    function GetName: UTF8String;
    procedure SetName(const value: UTF8String); // sets Id too
    function GetId: TGQuark;
    
    property Name: UTF8String read GetName write SetName;
    property Id: TGQuark read GetId;
  end;

implementation
uses uwrapgstnames;

{$IFNDEF gst_no_external}
function gst_structure_get_type: TGType; cdecl; external gstlib;

function gst_structure_empty_new(name: PGChar): PWGstStructure; cdecl; external gstlib;
function gst_structure_id_empty_new(quark: TGQuark): PWGstStructure; cdecl; external gstlib;
function gst_structure_new(name, firstfield: PGChar; args: array of const); cdecl; external gstlib;

// gst_structure_new_valist

function gst_structure_copy(strc: PWGstStructure): PWGstStructure; cdecl; external gstlib;
procedure gst_structure_set_parent_refcount(strc: PWGstStructure; refcount: Pgint); cdecl; external gstlib;
procedure gst_structure_free(strc: PWGstStructure); cdecl; external gstlib;
function gst_structure_get_name(strc: PWGstStructure): PGChar(*const*); cdecl; external gstlib;
function gst_structure_get_name_id(strc: PWGstStructure): TGQuark; cdecl; external gstlib;

procedure gst_structure_set_name(strc: PWGstStructure; name: PGChar(*const*)): TGQuark; cdecl; external gstlib;

procedure gst_structure_id_set_value(strc: PWGstStructure; field: TGQuark: value: PGValue); cdecl; external gstlib;

procedure gst_structure_set_value(strc: PWGstStructure; name: PGChar(*const*); value: PGValue(*const*)); cdecl; external gstlib;
procedure gst_structure_set(strc: PWGstStructure; name: PGChar(*const*); args: array of const); cdecl; external gstlib;

//gst_structure_set_valist

function gst_structure_id_get_value(strc: PWGstStructure; field: TGQuark): PGValue(*const*); cdecl; external gstlib;
function gst_structure_get_value(strc: PWGstStructure; name: PGChar(*const*)): PGValue(*const*); cdecl; external gstlib;

procedure gst_structure_remove_field(strc: PWGstStructure; name: PGChar(*const*)); cdecl; external gstlib;
//procedure gst_structure_remove_fields(strc: PWGstStructure; fieldname: PGChar(*const*); args: array of const); cdecl; external gstlib;

//gst_structure_remove_fields_valist
procedure gst_structure_remove_all_fields(strc: PWGstStructure); cdecl; external gstlib;

function gst_structure_get_field_type( (*const*)strc: PWGstStructure; name: PGChar(*const*)): TGType; cdecl; external gstlib;

(*
gboolean                gst_structure_foreach              (const GstStructure      *structure,
							    GstStructureForeachFunc  func,
							    gpointer                 user_data);
*)
(*
gboolean                gst_structure_map_in_place         (GstStructure            *structure,
							    GstStructureMapFunc      func,
							    gpointer                 user_data);
*)

function gst_structure_n_fields( (*const*) strc: PWGstStructure): gint; cdecl; external gstlib;
function gst_structure_has_field( (*const*) strc: PWGstStructure; (*const*) name: PGChar): gboolean; cdecl; external gstlib;

function gst_structure_has_field_typed( (*const*) strc: PWGstStructure;
   (*const*) name: PGChar; atype: TGType): gboolean; cdecl; external gstlib;

(* utility functions *)
function gst_structure_get_boolean( (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*); gboolean *value): gboolean; cdecl; external gstlib;							    

function gst_structure_get_int( (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*); 
  value: Pgint): gboolean; cdecl; external gstlib;
  
function gst_structure_get_fourcc( (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*);
  value: Pguint32): gboolean; cdecl; external gstlib;

function gst_structure_get_double( (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*);
  value: Pgdouble): gboolean; cdecl; external gstlib;

function gst_structure_get_string( (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*)): PGChar(*const*); cdecl; external gstlib;

function gst_structure_to_string( (*const*) strc: PWGstStructure): PGChar; cdecl; external gstlib;

function gst_structure_from_string( (*const*) astring: PGChar; endptr: PPgchar): PWGstStructure; cdecl; external gstlib;

function gst_caps_structure_fixate_field_nearest_int(
  (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*);
  target: gint(*actually non-g*)): gboolean; cdecl; external gstlib;

function gst_caps_structure_fixate_field_nearest_double(
  (*const*) strc: PWGstStructure;
  fieldname: PGChar(*const*);
  target: gdouble(*actually non-g*)): gboolean; cdecl; external gstlib;

{$ENDIF}

(*
gst_structure_empty_new
gst_structure_id_empty_new
gst_structure_new
*)

constructor TGstStructure.Create;
begin
  inherited Create(gst_structure_empty_new('dummyname'));
end;

procedure TGstStructure.Clear;
begin
  gst_structure_remove_all_fields(fObject);
end;

function TGstStructure.GetName: UTF8String;
begin
  Result := gst_structure_get_name(fObject);
  // no free needed
end;

procedure TGstStructure.SetName(const value: UTF8String);
begin
  gst_structure_set_name(fObject, PGChar(PChar(value)));
end;

function TGstStructure.GetId: TGQuark;
begin
  Result := gst_structure_get_name_id(fObject);
end;

destructor TGstStructure.Destroy;
begin
  //  todo check ownership flag ?
  gst_structure_free(fObject);
  inherited Destroy;
end;

procedure TGstStructure.RemoveField(const key: UTF8String);
begin
  gst_structure_remove_field(fObject, PGChar(PChar(key)));
end;

function TGstStructure.HasField(const key: UTF8String): Boolean;
begin
  Result := gst_structure_has_field(fObject, PGChar(PChar(key)));
end;

function TGstStructure.HasFieldTyped(const key: UTF8String; atype: TVarType
  ): Boolean;
var
  agtype: TGType;
begin
  agtype := GTypeByVarType(atype);
  Result := gst_structure_has_field_typed(fObject, PGChar(PChar(key)), agtype);
end;

// TODO maybe an exception ?

function TGstStructure.GetInteger(const key: UTF8String): Integer;
begin
  assert(gst_structure_get_int(fObject, PGChar(PChar(key)), @Result));
end;

function TGstStructure.GetDouble(const key: UTF8String): Double;
begin
  assert(gst_structure_get_double(fObject, PGChar(PChar(key)), @Result));
end;

function TGstStructure.GetFourcc(const key: UTF8String): guint32;
begin
  assert(gst_structure_get_fourcc(fObject, PGChar(PChar(key)), @Result));
end;

function TGstStructure.GetString(const key: UTF8String): UTF8String;
var
  native: PGChar;
begin
  native := gst_structure_get_string(fObject, PGChar(PChar(key)));
  assert(Assigned(native));
  Result := native;
  // no free needed
end;

function TGstStructure.GetBoolean(const key: UTF8String): Boolean;
var
  gb: gboolean;
begin
  assert(gst_structure_get_boolean(fObject, PGChar(PChar(key)), @gb));
  Result := gb;
end;

function TGstStructure.GetValue(const key: UTF8String): Variant;
var
  gv: PGValue;
begin
  gv := gst_structure_get_value(fObject);
  Result := VariantFromGValue(gv);
  // no free needed
end;

function TGstStructure.GetType(const key: UTF8String): TVarType;
begin
  Result := VarTypeFromGType(gst_structure_get_x(fObject, PGChar(PChar(key))));
end;

function TGstStructure.GetCount: Integer;
begin
  Result := gst_structure_n_fields(fObject);
end;

function TGstStructure.ToString: UTF8String;
var
  native: PGChar;
begin
  Result := '';
  native := gst_structure_to_string(fObject);
  if Assigned(native) then begin
    Result := native;
    g_free(native);
  end;
end;

constructor TGstStructure.CreateFromString(const string: UTF8String);
begin
  inherited Create(gst_structure_from_string(string, nil));
end;

constructor TGstStructure.CreateFromString(const string: UTF8String; out
  endpos: Integer);
var
  ac: PGChar;
begin
  inherited Create(gst_structure_from_string(string, @ac));
  endpos := Integer(ac);
end;

function TGstStructure.Clone: ICloneable;
begin
  Result := TGstStructure.Create(gst_structure_copy(fObject));
end;

// TGstStructureProxy

  protected
    fOwner: TGstStructure;
  protected
function TGstStructureProxy.GetField(const key: UTF8String): Variant;
begin
  Result := fOwner.GetValue(key);
end;

procedure TGstStructureProxy.SetField(const key: UTF8String; const value: Variant);
begin
  fOwner.SetValue(key, value);
end;

function TGstStructureProxy.GetCount: Integer;
begin
  Result : fOwner.GetCount;
end;

procedure TGstStructureProxy.Clear;
begin
  fOwner.Clear;
end;

constructor TGstStructureProxy.Create(Owner: TGstStructure);
begin
  inherited Create;
  fOwner := Owner;
end;

end.

