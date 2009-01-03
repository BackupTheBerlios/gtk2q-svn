unit uincdec;

interface

function InterlockedIncrement(var value: Integer): Integer; inline;
function InterlockedDecrement(var value: Integer): Integer; inline;

implementation
uses sysutils{$IFDEF DELPHI}, windows{$ENDIF DELPHI};

function InterlockedIncrement(var value: Integer): Integer; inline;
begin
   {$IFDEF DELPHI}
   Result := windows.InterlockedIncrement(value);
   {$ELSE}
   Result := InterlockedIncrement(value);
   {$ENDIF DELPHI}
end;

function InterlockedDecrement(var value: Integer): Integer; inline;
begin
   {$IFDEF DELPHI}
   Result := windows.InterlockedDecrement(value);
   {$ELSE}
   Result := InterlockedDecrement(value);
   {$ENDIF DELPHI}
end;


end.
