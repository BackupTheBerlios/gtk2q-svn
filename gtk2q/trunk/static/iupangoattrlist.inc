(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoAttrList = interface(IPointerMediator)
    ['{10F6822C-9664-11DA-9365-00055DDDEA00}']

    procedure Insert(attribute: IPangoAttribute);
    procedure InsertBefore(attribute: IPangoAttribute);
    procedure Change(attribute: IPangoAttribute);
    // TODO function Splice(
    // TODO Filter
    // TODO get iterator

  end;
(*$ENDIF define_types*)
