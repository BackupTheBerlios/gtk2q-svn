unit iutyperegistry;

interface
uses iugobject, ugobject, ugtypes, sysutils;

type
  ITypeRegistry = interface
    ['{A9B6C55C-B4C6-4F57-AE11-5257B5A765DE}']
    procedure Add(const name, namespace: string; 
       const someclass: TGObjectClass; const agtype: TGType; 
       const iface: TGUID);
       
    function Find(const name, namespace: string): TGObjectClass;

    (* special are classes that are specialized here and have no direct gtype association *)
    procedure AddSpecial(const name, namespace: string; 
       const someclass: TGObjectClass; const agtype: TGType; 
       const iface: TGUID);
       
    function FindSpecial(const name, namespace: string): TGObjectClass;

    function FindSpecialInterface(const iface: TGUID): TGObjectClass;
    function FindInterface(const iface: TGUID): TGObjectClass;

    function FindGType(const agtype: TGType): TGObjectClass;
    //function FindClass(someclass: TGObjectClass): GType; TODO

    function CreateInstance(const name, namespace: string): IGObject; overload;
    function CreateInstance(const iface: TGUID): IGObject; overload;

    function HasGType(const agtype: TGType): Boolean;
  end;
  EGTypeNotFound = class(Exception)
  end;

implementation

end.
