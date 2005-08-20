(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)

  IDBusBus = interface(?)
    ['{5A456476-117F-11DA-922E-00055DDDEA00}']
    function GetObject(path: UTF8String): IDBusObject;
  end;
(*$ENDIF define_types*)

(*$IFDEF define_implementation*)
(*$ENDIF define_implementation*)
