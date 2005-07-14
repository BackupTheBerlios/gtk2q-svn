unit uargv;

interface
procedure InitArgv(out argc: Integer; out argv: PPChar);
procedure CloneFlatArgv(argv: PPChar; out cloneargv: PPChar);
procedure DoneCloneFlatArgv(var cloneargv: PPChar);
procedure DoneArgv(var argc: Integer; var argv: PPChar);

implementation
uses sysutils;

function argcofargv(argv: PPChar): Integer;
var
  cnt: Integer;
begin
  cnt := 0;
  while Assigned(argv) and Assigned(argv^) do begin
    Inc(argv);
    Inc(cnt);
  end;
  Result := cnt;
end;


procedure InitArgv(out argc: Integer; out argv: PPChar);
var
  i: Integer;
  xargv: PPChar;
begin
  argc := ParamCount + 1;
  argv := AllocMem(sizeof(PChar) * (argc + 1));
  xargv := argv;

  for i := 0 to ParamCount do begin
    xargv^ := StrNew(PChar(ParamStr(i)));
    Inc(xargv);
  end;
  xargv^ := nil;
end;

procedure CloneFlatArgv(argv: PPChar; out cloneargv: PPChar);
var
  i: Integer;
  xcloneargv: PPChar;
  argc: Integer;
begin
  argc := argcofargv(argv);
  cloneargv := AllocMem(sizeof(PChar) * (argc + 1));
  xcloneargv := cloneargv;
  for i := 0 to argc { including nil } do begin
    xcloneargv^ := argv^;
    Inc(xcloneargv);
  end;
end;

procedure DoneCloneFlatArgv(var cloneargv: PPChar);
begin
  FreeMem(cloneargv);
  cloneargv := nil;
end;

procedure DoneArgv(var argc: Integer; var argv: PPChar);
var
  i: integer;
  xargv: PPChar;
begin
  xargv := argv;
  for i := argcofargv(argv) downto 0 do begin
    StrDispose(xargv^);
    Inc(xargv);
  end;
  DoneCloneFlatArgv(argv);
  argc := 0;
end;

end.
