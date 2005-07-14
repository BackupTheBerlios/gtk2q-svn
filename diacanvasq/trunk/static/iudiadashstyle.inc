(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)

  TDashArray = array of gdouble;
  IDiaDashStyle = interface (* + IPointerMediator *)
    ['{47003763-1C2C-4B6D-969C-3E95E9150BC5}']
    function GetDash: TDashArray;
    procedure SetDash(const value: TDashArray);

    property Dash: TDashArray read GetDash write SetDash;
  end;

(*$ENDIF define_types*)

