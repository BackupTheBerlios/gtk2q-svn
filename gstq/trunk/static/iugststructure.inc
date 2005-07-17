(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IGstStructureFieldsProxy = interface(IPointerMediator)
    ['{71EB6766-F545-11D9-8B32-00055DDDEA00}']
    
    function GetField(const key: UTF8String): Variant;
    procedure SetField(const key: UTF8String; const value: Variant);
    function GetCount: Integer;
    procedure Clear;
    property Fields[const key: UTF8String]: Variant read GetField write SetField; default;
    property Count: Integer read GetCount;
  end;

  { TGstStructure }

  IGstStructure = interface(IPointerMediator)
    ['{779E3E7C-F545-11D9-8533-00055DDDEA00}']
    
    // TODO foreach
    // TODO map_in_place
    
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
    //constructor CreateFromString(const string: UTF8String);
    //constructor CreateFromString(const string: UTF8String; out endpos: Integer);
    
    function Clone: ICloneable;
    //constructor Create;
    
    procedure Clear;
    
    function GetName: UTF8String;
    procedure SetName(const value: UTF8String); // sets Id too
    function GetId: TGQuark;
    
    property Name: UTF8String read GetName write SetName;
    property Id: TGQuark read GetId;
  end;
(*$ENDIF define_types*)
