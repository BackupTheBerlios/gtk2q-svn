(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)

  IDiaExpression = interface(IPointerMediator)
    ['{0A1112A5-2C09-4093-8382-25F312777BE2}']
    procedure Add(var1: IDiaVariable(* TODO const? *); const factor: Double); overload;
    procedure AddExpression(const source: IDiaExpression);
    procedure Multiply(const value: Double);
    (* ll *expr = NULL create a new expression *)
  end;

(*$ENDIF define_types*)

