unit uincdec;

interface

function InterlockedIncrement(var value: Integer): Integer;
function InterlockedDecrement(var value: Integer): Integer;

implementation
uses sysutils{$IFDEF DELPHI}, windows{$ENDIF DELPHI};

function InterlockedIncrement(var value: Integer): Integer;
begin
   {$IFDEF DELPHI}
   Result := windows.InterlockedIncrement(value);
   {$ELSE}
   Result := sysutils.InterlockedIncrement(value);
   {$ENDIF DELPHI}
end;

function InterlockedDecrement(var value: Integer): Integer;
begin
   {$IFDEF DELPHI}
   Result := windows.InterlockedDecrement(value);
   {$ELSE}
   Result := sysutils.InterlockedDecrement(value);
   {$ENDIF DELPHI}
end;


end.
