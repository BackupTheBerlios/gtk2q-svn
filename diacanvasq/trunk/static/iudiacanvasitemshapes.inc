(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)

  IDiaCanvasItemShapes = interface
    function GetItem(index: Integer): IDiaShape;
    function GetCount: Integer;

    property Item[index: Integer]: IDiaShape read GetItem; default;
    property Count: Integer read GetCount;
  end;

(*$ENDIF define_types*)

