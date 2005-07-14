unit uutf8codec;

(* OLD FPC only *)
(* UTF8CharacterToUnicode / UnicodeToUTF8 from LCL *)

interface

function UTF8Encode(const source: WideString): UTF8String;
function UTF8Decode(const source: UTF8String): WideString;

implementation
uses sysutils;

function UTF8CharacterToUnicode(p: PChar; var CharLen: integer): Cardinal;
begin
  if p<>nil then begin
    if ord(p^)<$C0 then begin
      // regular single byte character (#0 is a normal char, this is pascal ;)
      Result:=ord(p^);
      CharLen:=1;
    end
    else if ((ord(p^) and $E0) = $C0) then begin
      // could be double byte character
      if (ord(p[1]) and $C0) = $80 then begin
        Result:=((ord(p^) and $1F) shl 6)
                or (ord(p[1]) and $3F);
        CharLen:=2;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else if ((ord(p^) and $F0) = $E0) then begin
      // could be triple byte character
      if ((ord(p[1]) and $C0) = $80)
      and ((ord(p[2]) and $C0) = $80) then begin
        Result:=((ord(p^) and $1F) shl 12)
                or ((ord(p[1]) and $3F) shl 6)
                or (ord(p[2]) and $3F);
        CharLen:=3;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else if ((ord(p^) and $F8) = $F0) then begin
      // could be 4 byte character
      if ((ord(p[1]) and $C0) = $80)
      and ((ord(p[2]) and $C0) = $80)
      and ((ord(p[3]) and $C0) = $80) then begin
        Result:=((ord(p^) and $1F) shl 18)
                or ((ord(p[1]) and $3F) shl 12)
                or ((ord(p[2]) and $3F) shl 6)
                or (ord(p[3]) and $3F);
        CharLen:=4;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else begin
      Result:=ord(p^);
      CharLen:=1;
    end;
  end else begin
    Result:=0;
    CharLen:=0;
  end;
end;

function UnicodeToUTF8(u: cardinal): string;

  procedure RaiseInvalidUnicode;
  begin
    raise Exception.Create('UnicodeToUTF8: invalid unicode: '+IntToStr(u));
  end;

begin
  case u of
    0..$7f:
      begin
        SetLength(Result,1);
        Result[1]:=char(byte(u));
      end;
    $80..$7ff:
      begin
        SetLength(Result,2);
        Result[1]:=char(byte($c0 or (u shr 6)));
        Result[2]:=char(byte($80 or (u and $3f)));
      end;
    $800..$ffff:
      begin
        SetLength(Result,3);
        Result[1]:=char(byte($e0 or (u shr 12)));
        Result[2]:=char(byte((u shr 6) and $3f) or $80);
        Result[3]:=char(byte(u and $3f) or $80);
      end;
    $10000..$1fffff:
      begin
        SetLength(Result,4);
        Result[1]:=char(byte($f0 or (u shr 18)));
        Result[2]:=char(byte((u shr 12) and $3f) or $80);
        Result[3]:=char(byte((u shr 6) and $3f) or $80);
        Result[4]:=char(byte(u and $3f) or $80);
      end;
  else
    RaiseInvalidUnicode;
  end;
end;

function UTF8Encode(const source: WideString): UTF8String;
var
  sourceChar: WideChar;
  sourceCode: Cardinal;
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(source) do begin
    sourceChar := source[i];
    sourceCode := Ord(sourceChar);

    Result := Result + UnicodeToUTF8(sourceCode);
  end;
end;

function UTF8Decode(const source: UTF8String): WideString;
var
  charlen: Integer;
  sourceP: PChar;
  p: PChar;
  destCode: Cardinal;
begin
  sourceP := PChar(source);
  p := sourceP;
  Result := '';

  while Assigned(p) and (p^ <> #0) do begin
    destCode := UTF8CharacterToUnicode(p, charlen);
    assert(charlen > 0);
    Inc(p, charlen);
    Result := Result + chr(destCode);
  end;
end;

end.

