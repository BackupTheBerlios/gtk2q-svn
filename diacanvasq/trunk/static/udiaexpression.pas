unit udiaexpression;

interface
uses iudiacanvas, iupointermediator, upointermediator;

type
  TDiaExpression = class(DPointerMediator, IDiaExpression, IPointerMediator, IInvokable, IInterface)
  published
    constructor CreateWrapped(ptr: Pointer);
    procedure Add(var1: IDiaVariable(* TODO const? *); const factor: Double); overload;
    procedure AddExpression(const source: IDiaExpression);
    procedure Multiply(const value: Double);
  end;

implementation
uses uwrapdiacanvasnames, ugtypes;

(*$IFDEF gtk2q_standalone*)
procedure dia_expression_add(expr: PPWDiaExpression; var1: PWDiaVariable; c: gdouble); cdecl; external diacanvaslib;
procedure dia_expression_add_expression(expr: PPWDiaExpression; expr2: PWDiaExpression); cdecl; external diacanvaslib;
procedure dia_expression_times(expr: PWDiaExpression; c: gdouble); cdecl; external diacanvaslib;
procedure dia_expression_free(expr: PWDiaExpression); cdecl; external diacanvaslib;
(*$ENDIF gtk2q_standalone*)

{ TDiaExpression }

procedure TDiaExpression.Add(var1: IDiaVariable; const factor: Double);
begin
  (* FIXME can be nil?? *)
  assert(Assigned(var1));
  dia_expression_add(GetUnderlying, var1.GetUnderlying, factor);
end;

procedure TDiaExpression.AddExpression(const source: IDiaExpression);
begin
  assert(Assigned(source));
  dia_expression_add_expression(GetUnderlying, source.GetUnderlying);
end;

constructor TDiaExpression.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @dia_expression_free);
end;

procedure TDiaExpression.Multiply(const value: Double);
begin
  dia_expression_times(GetUnderlying, value);
end;

end.
