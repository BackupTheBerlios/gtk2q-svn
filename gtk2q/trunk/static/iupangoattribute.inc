(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoAttribute = interface(IPointerMediator)
    ['{567035A8-9666-11DA-93C3-00055DDDEA00}']

    function GetStartIndex: Cardinal;
    function GetEndIndex: Cardinal;
    procedure SetStartIndex(value: Cardinal);
    procedure SetEndIndex(value: Cardinal);

    function IsEqual(other: IPangoAttribute): Boolean;

    property StartIndex: Cardinal read GetStartIndex write SetStartIndex; // in bytes
    property EndIndex: Cardinal read GetEndIndex write SetEndIndex; // in bytes
  end;
(*$ENDIF define_types*)
