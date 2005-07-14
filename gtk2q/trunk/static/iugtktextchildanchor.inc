(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  
  IGtkTextChildAnchor = interface(IGObject)
  function GetWidgets: TIGtkWidgetArray;
  function GetDeleted: Boolean;
  end;
(*$ENDIF define_types*)

 