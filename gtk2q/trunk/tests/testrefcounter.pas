program rc;

{$ASSERTIONS ON}

uses heaptrc, drefcounter;

var
  refcnt: Integer = 0;
  maxrefcnt: Integer = 0;
  destroycalled: Boolean = False;
  
type
  IBA = interface
  end;
  TRC = class(TCustomDInterfacedObject, IBA, IInterface)
  protected
    procedure RefUnderlyingObject; override;
    procedure UnrefUnderlyingObject; override;
  public
    destructor Destroy; override;
  end;

procedure TRC.RefUnderlyingObject;
begin
  Writeln('moo');
  Inc(refcnt);
  if refcnt > maxrefcnt then
    maxrefcnt := refcnt;
end;

procedure TRC.UnrefUnderlyingObject;
begin
  Dec(refcnt);
end;

destructor TRC.Destroy;
begin
  destroycalled := True;
  inherited Destroy;
end;

procedure X;
var
  ba: IBA;  
begin
  ba := TRC.Create;
  Writeln('refcnt', refcnt);
  assert(refcnt = 1);
  assert(maxrefcnt = 1);
end;

begin
  try
    X; 
    assert(refcnt = 0);
    assert(maxrefcnt = 1);
    assert(destroycalled = True);
  except
    raise;
  end;
end.

