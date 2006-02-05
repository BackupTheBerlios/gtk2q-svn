(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoTabArray = interface(IPointerMediator)
    ['{F0A9FAC6-965E-11DA-84CE-00055DDDEA00}']

    function GetCount: Integer;

    procedure SetTab(TabIndex: Integer; Location: Integer);
    procedure GetTab(TabIndex: Integer; out Location: Integer; out TabAlignment: TPangoTabAlign);

    procedure Clear;
    
    // GetTabs
    // GetPositionsInPixels
    
    property Count: Integer read GetCount;
  end;
(*$ENDIF define_types*)
