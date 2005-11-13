unit uimporttools;
(*$IFDEF FPC*)
(*$MODE OBJFPC*)
(*$ENDIF*)

interface
uses ugtypes;

(* this is actually a "generic" function, not gtk2q specific *)

function ArrayUTF8StringToPPchar(const S: TUTF8StringArray; reserveentries: longint = 0): PPChar;
function PPcharToUTF8StringArray(a: PPChar): TUTF8StringArray;

implementation

{$IFDEF FPC}
function ArrayUTF8StringToPPchar(const S: TUTF8StringArray; reserveentries: longint = 0): PPChar;
(* Extra allocate reserveentries pchar's at the beginning
   Note: for internal use by skilled programmers only
   if "s" goes out of scope in the parent procedure, the pointer is dangling.
*)
var
  p   : PPChar;
  i   : LongInt;
begin
  if High(s) < Low(s) then
    Exit(nil);
    
  GetMem(p, sizeof(PChar) * (High(s) - Low(s) + reserveentries + 2));  // one more for NIL, one more for cmd

  if p = nil then
    Exit(NIL);

  for i := Low(s) to High(s) do
     p[i + reserveentries] := PChar(s[i]);
     
  p[high(s) + 1 + reserveentries] := nil;
  Result := p;
end;
{$ELSE} { delphi }
function ArrayUTF8StringToPPchar(const S: TUTF8StringArray; reserveentries: longint = 0): PPChar;
(* Extra allocate reserveentries pchar's at the beginning
   Note: for internal use by skilled programmers only
   if "s" goes out of scope in the parent procedure, the pointer is dangling.
*)
var
  p   : PPChar;
  pCurrent: PPChar;
  i   : LongInt;
begin
  if High(s) < Low(s) then begin
    Result := nil;
    Exit;
  end;
    
  GetMem(p, sizeof(PChar) * (High(s) - Low(s) + reserveentries + 2));  // one more for NIL, one more for cmd

  if p = nil then begin
    Result := nil;
    Exit;
  end;

  assert(Low(s) = 0);
  Inc(pCurrent, reserveentries);
  for i := 0 to High(s) do begin
    pCurrent^ := PChar(s[i]);
    Inc(pCurrent);
  end;
     
  pCurrent^ := nil;
  Result := p;
end;
{$ENDIF}

function PPcharToUTF8StringArray(a: PPChar): TUTF8StringArray;
var
  i: Integer;
begin
  SetLength(Result, 0);
  
  i := 0;
  while Assigned(a) and Assigned(a^) do begin
    SetLength(Result, i + 1);
    Result[i] := a^;
    Inc(a);
    Inc(i);
  end;
end;

end.
