unit drefcountertest;

interface
uses dobject, dgtk, iwidget, iobject, glib2;

procedure TestRefCounter;

implementation
uses dialogs, sysutils;

function assertRefCnt(const a: IGObject; cnt: Integer): Boolean;
var
  rcnt: Integer;
  b: Boolean;
begin
  rcnt := PGObject(a.GetUnderlying).ref_count;
  Dec(rcnt, 2);
  b := rcnt = cnt;
  Result := b;
  assert(b);
end;

procedure TestXRef(i: IGtkEntry);
begin
  assertRefCnt(i as IGObject, 3);
end;

procedure TestRefCounter;
var
  i: IGtkEntry;
begin
  i := TGtkEntry.Create;
  assertRefCnt(i as IGObject, 1);

  TestXRef(i);

  try
    assertRefCnt(i as IGObject, 1);
  except
    // Runtime error 217 when an exception was raised before SysUtils is initialized or after it is finalized
    sHowmessage('moo');
    i := nil;
    raise;
  end;

end;

initialization

end.
