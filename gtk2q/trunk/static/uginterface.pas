unit uginterface;

interface
uses iug, ugobject, iugobject;

(* dummy class *)
type
  TGInterface = class(TGObject, IGInterface, IGObject, IInterface)
  end;
  
implementation
end.
