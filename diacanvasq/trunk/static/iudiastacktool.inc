(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IDiaStackTool = interface
    ['{63524529-61BC-47D7-A4FC-9F6860374D74}']
    procedure Push(tool: IDiaTool);
    procedure Pop;
  end;
(*$ENDIF define_types*)

