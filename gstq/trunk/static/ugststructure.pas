unit ugststructure;

interface
uses sysutils, ugtypes;

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
    property Fields[const key: UTF8String]: Variant read GetField write SetField;
    property Count: Integer read GetCount;
  end;
  TGstStructure = class(TInterfacedObject, IGstStructure, ICloneable, IPointerMediator, IInterface)
    // TODO foreach
    // TODO map_in_place
    
    destructor Destroy; override;
    
    procedure RemoveField(const key: UTF8String);
    // TODO RemoveFields
    
    function HasField(const key: UTF8String): Boolean;
    function HasFieldTyped(const key: UTF8String; type: TVarType): Boolean;
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
    
    procedure Clear;
    
    function GetName: UTF8String;
    procedure SetName(const value: UTF8String); // sets Id too
    function GetId: TGQuark;
    
    property Name: UTF8String read GetName write SetName;
    property Id: TGQuark read GetId;
  end;

implementation

(*
gst_structure_empty_new
gst_structure_id_empty_new
gst_structure_new
*)

constructor TGstStructure.Create;
begin
  inherited Create;
  fObject := gst_structure_empty_new('dummyname');
end;

procedure TGstStructure.Clear;
begin
  gst_structure_remove_all_fields(fObject);
end;

destructor TGstStructure.Destroy;
begin
  //  todo check ownership flag ?
  gst_structure_free(fObject);
  inherited Destroy;
end;

function TGstStructure.GetCount: Integer;
begin
  Result := gst_structure_n_fields(fObject);
end;



end.

