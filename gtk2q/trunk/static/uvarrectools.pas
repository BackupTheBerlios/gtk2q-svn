unit uvarrectools;

interface

type
  TVarrecArray = array of TVarrec;

procedure ClearVarrec(var v: TVarrec);
procedure CopyVarrec(const Source: TVarRec; var Dest: TVarrec);
procedure CopyStringToVarrec(value: string; var Dest: TVarrec);

procedure FillVarrecArray(arr: array of const; var vra: TVarrecArray);
procedure FillVarrecArrayFromIntArray(arr: array of Integer; var vra: TVarrecArray; offset: integer = 0);
procedure ClearVarrecArray(var vra: TVarrecArray);
// doesnt work function VarRec(i: Integer): TVarRec; overload;
function GetIntegerFromVarrec(const vr: TVarrec): Integer;
function GetInterfaceFromVarRec(const vr: TVarRec): IInterface;
function GetClassFromVarRec(const vr: TVarRec): TClass;
function GetObjectTypeNameFromVarRec(const vr: TVarRec): string;
function CompareVarrec(const a, b: TVarrec): Integer;
procedure InitVarrec(var v: TVarrec);

implementation
uses sysutils;

{
alternative:

procedure FunctionWithVarArgs(
  const ArgsList : array of const );
  var
    ArgsListTyped :
        array[0..$FFF0 div SizeOf(TVarRec)]
              of TVarRec absolute ArgsList;
                n         : integer;
                begin
                  for n := Low( ArgsList ) to
                             High( ArgsList ) do
                               begin
                                   with ArgsListTyped[ n ] do
}

procedure InitVarrec(var v: TVarrec);
begin
  v.VType := vtInteger;
  v.VInteger := 7;
end;

procedure ClearVarrec(var v: TVarRec);
begin
  case v.VType of
    vtInteger:;
    vtBoolean:;
    vtChar:;
    vtExtended: Dispose(v.VExtended); // others said freemem
    vtString: Dispose(v.VString);
    vtPointer:;
    vtPChar: StrDispose(v.VPChar);
    vtPWideChar: FreeMem(v.VPWideChar);
    vtCurrency: Dispose(v.VCurrency);
    vtVariant: Dispose(v.VVariant);
    vtInterface: IInterface(v.VInterface) := nil;
    vtObject: TObject(v.VObject) := nil;
    vtClass: ;
    vtAnsiString: ansistring(v.VAnsiString) := '';
    vtWideString: widestring(v.VWideString) := '';
    vtInt64: Dispose(v.VInt64);
  end;
  v.VType := vtInteger;
  v.VInteger := 0;
end;

function CompareVarrec(const a, b: TVarrec): Integer;
var
  aext, bext: Extended;
  astring, bstring: string;
  aansistring, bansistring: AnsiString;
  awidestring, bwidestring: WideString;
  aint64, bint64: Int64;
begin
  assert(a.VType = b.VType);
  case a.VType of
    vtInteger: if b.Vinteger = a.VInteger then Result := 0 else if b.VInteger > a.VInteger then Result := 1 else Result := -1;
    vtBoolean: if b.VBoolean = a.VBoolean then Result := 0 else if b.VBoolean > a.VBoolean then Result := 1 else Result := -1;
    vtChar: if b.VChar = a.VChar then Result := 0 else if b.VChar > a.VChar then Result := 1 else Result := -1;
    vtExtended: begin
      aext := Extended(a.VExtended^);
      bext := Extended(b.VExtended^);

      if aext = bext then Result := 0 else if bext > aext then Result := 1 else Result := -1;
    end;
    vtString: begin
      astring := a.VString^;
      bstring := b.VString^;

      if astring = bstring then Result := 0 else if bstring > astring then Result := 1 else Result := -1;
    end;
    vtPointer: raise Exception.Create('cannot compare pointers');
    vtPChar: begin
      aansistring := a.VPChar;
      bansistring := b.VPChar;

      if aansistring = bansistring then Result := 0 else if bansistring > aansistring then Result := 1 else Result := -1;
    end;
    vtPWideChar: begin
      awidestring := a.VPChar;
      bwidestring := b.VPChar;

      if awidestring = bwidestring then Result := 0 else if bwidestring > awidestring then Result := 1 else Result := -1;
    end;
    vtCurrency: raise Exception.Create('cannot compare currency');
    vtVariant: raise Exception.Create('cannot compare variant');
    vtInterface: raise Exception.Create('cannot compare interface');
    vtObject: raise Exception.Create('cannot compare object');
    vtClass: raise Exception.Create('cannot compare class');
    vtAnsiString: begin
      aansistring := ansistring(a.VAnsiString);
      bansistring := ansistring(b.VAnsiString);

      if aansistring = bansistring then Result := 0 else if bansistring > aansistring then Result := 1 else Result := -1;
    end;
    vtWideString: begin
      awidestring := widestring(a.VwideString);
      bwidestring := widestring(b.VwideString);

      if awidestring = bwidestring then Result := 0 else if bwidestring > awidestring then Result := 1 else Result := -1;
    end;
    vtInt64: begin
      aint64 := a.VInt64^;
      bint64 := b.VInt64^;

      if aint64 = bint64 then Result := 0 else if bint64 > aint64 then Result := 1 else Result := -1;
    end;
    else raise Exception.Create('unknown types to compare in CompareVarrec');
  end;
end;

procedure CopyVarrec(const Source: TVarRec; var Dest: TVarRec);
var
  W:WideString;
begin
  clearVarrec(dest);
  Dest.VType := vtInteger;
  Dest.VInteger := 0;
  Dest.VType := Source.VType;
  case Source.VType of
  vtInteger: Dest.VInteger := Source.VInteger;
  vtBoolean: Dest.VBoolean := Source.VBoolean;
  vtChar: Dest.VChar := Source.VChar;
  vtExtended: begin 
      New(Dest.VExtended);
      Dest.VExtended^ := Source.VExtended^;
    end;
  vtString: Dest.VString^ := Source.VString^;
  vtPointer: raise Exception.Create('You tried to Copy a Pointer to a record. You dont want this to work. Trust me.'); //Dest.VPointer := Source.VPointer;
  vtPChar: Dest.VPChar := StrNew(Source.VPChar); //raise Exception.Create('PChar are evil. Dont be.');
  vtPWideChar:  begin
            W := Source.VPWideChar;
            GetMem(Dest.VPWideChar, 
              (Length(W) + 1) * SizeOf(WideChar));
              Move(PWideChar(W)^, Dest.VPWideChar^, 
             (Length(W) + 1) * SizeOf(WideChar));
            end;
  vtCurrency: begin
    New(Dest.VCurrency);
    Dest.VCurrency^ := Source.VCurrency^;
  end;
  vtVariant: begin
    New(Dest.VVariant);
    Dest.VVariant^ := Source.VVariant^;
  end;
  vtInterface: begin
    Dest.VInterface := nil;
    IInterface(Dest.VInterface) := IInterface(Source.VInterface);
  end;

  vtObject: TObject(Dest.VObject) := TObject(Source.VObject);
  vtClass: raise Exception.Create('cannot copy classes');
  vtAnsiString: begin
    Dest.VAnsiString := nil;
    ansistring(Dest.VAnsiString) := ansistring(Source.VAnsiString); // or string()
    end;
  vtWideString: begin
    Dest.VWideString := nil;
    widestring(Dest.VWideString) := widestring(Source.VWideString);
    end;
  vtInt64: begin
    New(Dest.VInt64);
    Dest.VInt64^ := Source.VInt64^;
    end;
  end;
end;

procedure ClearVarrecArray(var vra: TVarrecArray);
var
  i: Integer;
begin
  if Length(vra) = 0 then Exit;

  for i := High(vra) downto Low(vra) do begin
    ClearVarrec(vra[i]);
  end;
  SetLength(vra, 0);
end;

procedure FillVarrecArrayFromIntArray(arr: array of Integer; var vra: TVarrecArray; offset: integer = 0);
var
  i: Integer;
begin
  ClearVarrecArray(vra);
  SetLength(vra, Length(arr) - offset);
  for i := Low(arr) + offset to High(arr) do begin
    InitVarrec(vra[i]);
    vra[i - offset].VType := vtInteger;
    vra[i - offset].VInteger := arr[i];
    (*CopyVarRec(arr[i], vra[i]);*)
  end;
end;

procedure FillVarrecArray(arr: array of const; var vra: TVarRecArray);
var
  i: Integer;
begin
  ClearVarrecArray(vra);
  SetLength(vra, Length(arr));
  for i := Low(arr) to High(arr) do begin
    InitVarrec(vra[i]);
    CopyVarRec(arr[i], vra[i]);
  end;
end;

{function VarRec(i: Integer): TVarRec; overload;
var
  vr : TVarRec;
begin
  vr.VType := vtInteger;
  vr.VInteger := i;
end;}

function GetIntegerFromVarRec(const vr: TVarRec): Integer;
begin
  assert(vr.VType = vtInteger);
  Result := vr.VInteger;
end;

function GetInterfaceFromVarRec(const vr: TVarRec): IInterface;
begin
  assert(vr.VType = vtInterface);
  Result := IInterface(vr.VInterface);
end;

function GetClassFromVarRec(const vr: TVarRec): TClass;
begin
  assert(vr.VType = vtClass);
  Result := TClass(vr.VClass);
end;

function GetObjectTypeNameFromVarRec(const vr: TVarRec): string;
begin
  assert(vr.VType = vtObject);
  Result := vr.VObject.ClassName;
end;

procedure CopyStringToVarrec(value: string; var Dest: TVarrec);
begin
  ClearVarrec(Dest);
  Dest.VType := vtAnsiString;
  Dest.VAnsiString := Pointer(value); //  FIXME test
end;


end.
