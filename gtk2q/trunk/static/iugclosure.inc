(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  
  IGClosure = interface
    ['{F5B0365D-418D-4ACC-93C1-AA7CF9550086}']
    //procedure Invoke;
    function GetUnderlying: Pointer; // accelgroup wants to use that
  end;

(*$ENDIF define_types*)

 
