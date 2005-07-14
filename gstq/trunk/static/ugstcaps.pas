unit ugstcaps;

interface

type
  TGstCapsStructuresProxy = class(TInterfacedObject, IGstCapsStructuresProxy, IInterface) (* made up *)
  protected
    fCaps: IWeakref;
  protected
    function GetStructure(const Index: Integer): IGstStructure;
    function GetCount: Integer;
  published
    constructor Create(const caps: IGstCaps);
    (* TODO: weakref the gstcaps, throw exception if accessed after gone *)
    property Items[const Index: Integer]: IGstStructure read GetStructure; default;
    property Count: Integer read GetCount;
  end;
  
  TGstCaps = class(TGInterfacedObject, IGstCaps, IGInterfacedObject, ICloneable, IInterface)
  protected
    fStructuresProxy: IGstCapsStructuresProxy;
  published
    constructor Create;
    constructor CreateWrapped(original: Pointer);
    constructur CreateAny; (* ugh *)
    constructor CreateSimple(const mediatype, fieldname: UTF8String; args: array of const);
    (*constructor CreateFull(structure: GstStructure; args: array of const);*)
    
    function Clone: ICloneable;
    
    function ToString: UTF8String;
    constructor CreateFromString(s: UTF8String);
    
    function IsAny: Boolean;
    function IsEmpty: Boolean;
    function IsFixed: Boolean;
    function IsAlwaysCompatible(const other: IGstCaps): Boolean;
    function IsEqual(const other: IGstCaps): Boolean;
    
    (* these also could be done as class functions, but I dont feel like it currently: *)
    function Normalize: IGstCaps; (* returns new instance *)
    function Union(const other: IGstCaps): IGstCaps;
    function Subtract(const other: IGstCaps): IGstCaps;
    function Intersect(const other: IGstCaps): IGstCaps;
    (* --- *)
    procedure Append(const other: IGstCaps); (* append to self *)
    
    procedure SetSimple(const field: UTF8String; args: array of const);
    
    function DoSimplify: Boolean;
    
    procedure MakeWriteable; (* ? *)
    
    
  protected
    procedure UnrefUnderlyingObject; override;
    procedure RefUnderlyingObject; override;
    
    procedure constructWrapped; override;

    function GetStructuresProxy: IGstCapsStructures;
    
  published
    property Structures: IGstCapsStructures read GetStructuresProxy;
  end;

G_CONST_RETURN GstCaps * gst_static_caps_get                            (GstStaticCaps *static_caps);

/* manipulation */
void                     gst_caps_append_structure                      (GstCaps       *caps,
                                                                         GstStructure  *structure);
int                      gst_caps_get_size                              (const GstCaps *caps); 
GstStructure *           gst_caps_get_structure                         (const GstCaps *caps,  
                                                                         int            index);
(*GstCaps *   gst_caps_copy_nth                              (const GstCaps * caps, gint nth);*)
(*
void                     gst_caps_set_simple_valist                     (GstCaps       *caps,    
                                                                         char          *field,   
                                                                         va_list        varargs);
*)                                                                        
(*
#ifndef GST_DISABLE_LOADSAVE
xmlNodePtr               gst_caps_save_thyself                          (const GstCaps *caps,     
                                                                         xmlNodePtr     parent);  
GstCaps *                gst_caps_load_thyself                          (xmlNodePtr     parent);
#endif
*)

(* utility *)
(*
void                     gst_caps_replace                               (GstCaps      **caps,   
                                                                         GstCaps       *newcaps);
*)

implementation
uses uwrapgstnames;

constructor TGstCaps.Create;
begin
  inherited Create;
  fStructuresProxy := TGstCapsStructuresProxy.Create(Self);
end;

constructor TGstCaps.CreateWrapped(original: Pointer);
begin
  inherited CreateWrapped(original);
  fStructuresProxy := TGstCapsStructuresProxy.Create(Self);
end;

constructur TGstCaps.CreateAny; (* ugh *)
begin
  setWrapped(PWGObject(gst_caps_new_any()));
  fStructuresProxy := TGstCapsStructuresProxy.Create(Self);
end;

constructor TGstCaps.CreateSimple(const mediatype, fieldname: UTF8String; args: array of const);
begin
  setWrapped(PWGObject(gst_caps_new_simple(mediatype, fieldname, args)));
  fStructuresProxy := TGstCapsStructuresProxy.Create(Self);
end;

(*
constructor TGstCaps.CreateFull(structure: GstStructure; args: array of const);
begin
  setWrapped(PWGObject(gst_caps_new_full()));
  fStructuresProxy := TGstCapsStructuresProxy.Create(Self);
end;
*)

function TGstCaps.ToString: UTF8String;
var
  native: PGChar;
begin
  native := gst_caps_to_string();
  if Assigned(native) then begin
    Result := native;
    g_free(native);
  end else begin
    Result := '';
  end;
end;

constructor TGstCaps.CreateFromString(s: UTF8String);
begin
  inherited CreateWrapped(gst_caps_from_string(s));
end;
    

procedure TGstCaps.constructWrapped;
begin
  setWrapped(PWGObject(gst_caps_new_empty())); 
end;

procedure TGstCaps.UnrefUnderlyingObject;
begin
  gst_caps_unref(fObject);
end;

procedure TGstCaps.RefUnderlyingObject;
begin
  gst_caps_ref(fObject);
end;

function TGstCaps.Clone: ICloneable;
var
  unde: PWGstCaps;
begin
  unde := gst_caps_copy(fObject);
  Result := CreateWrapped(unde);
end;

function TGstCaps.IsAny: Boolean;
begin
  Result := gst_caps_is_any(fObject);
end;

function TGstCaps.IsEmpty: Boolean;
begin
  Result := gst_caps_is_empty(fObject);
end;

function TGstCaps.IsFixed: Boolean;
begin
  Result := gst_caps_is_fixed(fObject);
end;

function TGstCaps.IsAlwaysCompatible(const other: IGstCaps): Boolean;
begin
  Result := gst_caps_is_always_compatible(fObject, other.GetUnderlyingObject);
end;

function TGstCaps.IsEqual(const other: IGstCaps): Boolean;
begin
  Result := gst_caps_is_equal(fObject, other.GetUnderlyingObject);
end;

function TGstCaps.Normalize: IGstCaps; (* returns new instance *)
begin
  Result := CreateWrapped(gst_caps_normalize(fObject));
end;

function TGstCaps.Union(const other: IGstCaps): IGstCaps;
begin
  Result := gst_caps_union(fObject, other.GetUnderlying);
end;

function TGstCaps.Subtract(const other: IGstCaps): IGstCaps;
begin
  Result := gst_caps_subtract(fObject, other.GetUnderlying);
end;

function TGstCaps.Intersect(const other: IGstCaps): IGstCaps;
begin
  Result := gst_caps_intersect(fObject, other.GetUnderlying);
end;

function TGstCaps.DoSimplify: Boolean;
begin
  Result := gst_caps_do_simplify(fObject);
end;

procedure TGstCaps.MakeWriteable;
begin
  gst_caps_make_writeable(fObject);
end;

procedure TGstCaps.SetSimple(const field: UTF8String; args: array of const);
begin
  (* FIXME *)
  gst_caps_set_simple(fObject, field, args);
end;

procedure TGstCaps.Append(const other: IGstCaps);
begin
  gst_caps_append(fObject, other.GetUnderlying);
end;


function TGstCaps.GetStructuresProxy: IGstCapsStructures;
begin
  Result := fStructuresProxy;
end;

// proxy

function TGstCapsStructuresProxy.GetStructure(const Index: Integer): IGstStructure;
begin 
  Result := UGH gst_caps_get_structure(fCaps.GetUnderlying, Index);
end;

function TGstCapsStructuresProxy.GetCount: Integer;
begin
  Result := gst_caps_get_size(fCaps.GetUnderlying);
end;

constructor TGstCapsStructuresProxy.Create(const caps: IGstCaps);
begin
  inherited Create;
  fCaps := TWeakref.Create(caps);
end;

end.
