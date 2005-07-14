(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)

  IDiaUndoAction = interface(IPointerMediator)
    ['{42BF0ACD-1F36-4B67-B5E5-B0D6DC9B08E5}']
    procedure Undo;
    procedure Redo;
    
    (*
    DiaUndoFunc     undo;
    DiaUndoFunc     redo;
    GDestroyNotify  destroy;
    *)

  end;

(*$ENDIF define_types*)

