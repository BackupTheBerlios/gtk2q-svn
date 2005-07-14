program a;

// needs fpc >= 1.1 or delphi >= 4

uses sysutils;

// guids are TGuid: ['{HHHHHHHH-HHHH-HHHH-HHHH-HHHHHHHHHHHH}'] (hex 0-9,A-F)

// fpc: $INTERFACES ?

type
  IBla = interface
    procedure Blo; stdcall;
    procedure setP(value: string); stdcall;
    function getP: string; stdcall;
    property P: string read getP write setP;
  end;
  TA = class(TInterfacedObject, IBla)
  protected
    FP: string;
  public
    class function CreateInstance: TA;
    procedure Blo; stdcall;
    procedure setP(value: string); stdcall;
    function getP: string; stdcall;
  public
    constructor Create; virtual;
  end;
  TB = class(TA)
  public
    constructor Create; override;
  end;

class function TA.CreateInstance: TA;
begin
  Result := Create;
end;

constructor TA.Create;
begin
  inherited;
end;

procedure TA.Blo;
begin
  Writeln('Blo');
end;

procedure TA.setP(value: string);
begin
  FP := value;
end;

function TA.getP: string;
begin
  Result := FP;
end;

constructor TB.Create;
begin
  Writeln('B');
  inherited;
end;

type
  TVarRecArray = array of TVarRec;
  TTest = record
    //FRefCount
    Fargs: TVarRecArray;
  end;

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

procedure ClearVarRec(var v: TVarRec);
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

procedure TestOut(out a: Integer);
begin
  a := 7;
end;

procedure CopyVarRec(const Source: TVarRec; var Dest: TVarRec);
var
  W:WideString;
begin
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

procedure bleh(const test: TTest);
var
  i: Integer;
  vr: TVarRec;
  e: Extended;
begin
  for i := Low(test.Fargs) to High(test.Fargs) do begin
    //Writeln(test.FArgs[i]);
    vr := test.FArgs[i];
    
    if vr.VType = vtInteger then begin
      Writeln(IntToStr(vr.VInteger));
    end else if vr.VType = vtExtended then begin
      e := extended(vr.VExtended^);
      Writeln(FloatToStr(e));
    end else if vr.VType = vtString then begin
      Writeln(vr.VString^);
    end else if vr.VType = vtWideString then begin
      Writeln(widestring(vr.VWideString));
    end else if vr.VType = vtAnsiString then begin
      Writeln(ansistring(vr.VAnsiString));
    end else if vr.VType = vtVariant then begin
      Writeln('some variant');
    end else if vr.VType = vtPChar then begin
      Writeln('some pchar');
    end else if vr.VType = vtChar then begin  
      Writeln(vr.VChar);
    end else begin
      Writeln('vr vtype unknown');
    end;
  end;
end;

procedure blubb(arr: array of const);
var
  test: TTest;
  i: Integer;
begin
  SetLength(test.Fargs, Length(arr));
  for i := Low(arr) to High(arr) do begin
    CopyVarRec(arr[i], test.Fargs[i]);
  end;
  
  bleh(test);
end;


var
  aa: TA;
  bla: IBla;
  z: Integer;
begin
  aa := TB.CreateInstance;
  bla := aa;
  Writeln(bla.P);
  assert(bla.P = '');
  bla.P := 'hi';
  Writeln(bla.P);
  assert(bla.P = 'hi');
  
  
  bla.blo;
  Writeln(Format('%s', ['hello']));
  blubb(['aa', 5, 3.7]);
  
  Testout(z);
  Writeln(z);
  
  assert(aa <> nil);
  assert(bla <> nil);
  assert(z = 7);
end.

