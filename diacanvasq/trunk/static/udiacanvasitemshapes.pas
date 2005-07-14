unit udiacanvasitemshapes;

interface
uses classes, iudiacanvas, udiacanvasitem;

type
  TDiaCanvasItemShapes = class(TInterfacedObject, IDiaCanvasItemShapes, IInvokable, IInterface)
  protected
    Fowner: TDiaCanvasItem;
    Fcount: Integer;
    Fcountok: Boolean;
  published
    constructor Create(Owner: TDiaCanvasItem);
  protected
    function GetItem(index: Integer): IDiaShape;
    function GetCount: Integer;
    procedure EnsureCount;
  public
    property Item[index: Integer]: IDiaShape read GetItem stored False; default;
  published
    property Count: Integer read GetCount;
  end;

implementation
uses udiacanvastypes, sysutils;

constructor TDiaCanvasItemShapes.Create(Owner: TDiaCanvasItem);
begin
  inherited Create;
  Fowner := Owner;
end;

function TDiaCanvasItemShapes.GetItem(index: Integer): IDiaShape;
var
  i: Integer;
  b: Boolean;
  citer: TDiaCanvasIter;
begin
  (* TODO make faster *)

  i := 0;
  b := Fowner.GetShapeIter(citer);
  while b do begin
    if i = index then begin
      Result := Fowner.ShapeValue(citer);
    end;

    b := Fowner.ShapeNext(citer);
    Inc(i);
  end;
  
  raise ERangeError.Create('TDiaCanvasItemShapes.GetItem: index out of range');
end;

procedure TDiaCanvasItemShapes.EnsureCount;
var
  iter: TDiaCanvasIter;
  b: Boolean;
begin
  Fcountok := True;
  Fcount := 0;
  
  b := Fowner.GetShapeIter(iter);
  while b do begin
    Inc(Fcount);
    b := Fowner.ShapeNext(iter);
  end;
end;

function TDiaCanvasItemShapes.GetCount: Integer;
begin
  EnsureCount;
  Result := Fcount;
end;

end.
