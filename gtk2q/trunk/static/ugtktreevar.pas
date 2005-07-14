unit ugtktreevar;

interface
uses uvarrectools;

{function VarrecGTypedHasWrapped(const invar: TVarrecArray): Boolean;
procedure VarrecGTypedToWrapped(const invar: TVarrecArray; out outvar: TVarArray);
procedure VarrecWrappedToGTyped(const invar: TVarrecArray; out outvar: TVarrecArray);
}
implementation
{uses glib2;

function VarrecGTypedHasWrapped(const invar: TVarrecArray): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to High(invar) do // fixme
    if (invar[i].VType = vtPointer) and (G_IS_OBJECT(invar[i].VPointer)) then begin
      Result := True;
    end;
end;

procedure VarrecGTypedToWrapped(const invar: TVarrecArray; out outvar: TVarArray);
var // with reference counting
  i: Integer;
begin
  SetLength(outvar, Length(invar));
  for i := 0 to High(invar) do // fixme
    outvar[i] := VariantOf(invar[i]);
end;

procedure VarrecWrappedToGTyped(const invar: TVarrecArray; out outvar: TVarrecArray);
begin // without reference counting
  SetLength(outvar, Length(invar));
  for i := 0 to High(invar) do // fixme
    if invar[i] == interface and invar[i].supports(IGObject) then
      InitVarrec(outvar[i], gtype(invar[i].GetUnderlyingObject));
    else
      outvar[i] := invar[i];
end;
}

end.
