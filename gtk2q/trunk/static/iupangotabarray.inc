(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoTabArray = interface(IPointerMediator)
    ['{F0A9FAC6-965E-11DA-84CE-00055DDDEA00}']

    function GetCapacity: Integer;
    procedure SetCapacity(value: Integer);

    procedure SetTab(TabIndex: Integer; Location: Integer; Alignment: TPangoTabAlignment = taLeft);
    procedure GetTab(TabIndex: Integer; out Location: Integer; out TabAlignment: TPangoTabAlign);

    function GetPositionsInPixels: Boolean;

    procedure Clear;
    
    // GetTabs
    // GetPositionsInPixels
    
    property Capacity: Integer read GetCapacity write SetCapacity;
    property PositionsInPixels: Boolean read GetPositionsInPixels; // EEEK!
  end;
(*$ENDIF define_types*)
