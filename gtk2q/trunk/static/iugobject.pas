unit iugobject;

interface
uses sysutils, ugtypes;

{$M+} // RTTI type info

{$INCLUDE clinksettings.inc}

type
  EUserDataNotFound = class(Exception)
  end;
  EClassFinalError = class(Exception) (* can also be thought as EProgrammerLazyError here :) *)
  end;

  TSlot = procedure of object;

  TNotifySlot = procedure(dummy: Pointer) of object;
  ENotImplemented = class(Exception)
  end;
  EPropertyValueNotAvailable = class(Exception)
  end;
  EGError = class(Exception)
  protected
    Edomain: Cardinal;
    Ecode: Integer;
    Emessage: UTF8String;
    function GetCode: Integer;
    function GetDomain: Cardinal;
  public
    property Domain: Cardinal read GetDomain;
    property Code: Integer read GetCode;
    property Message: UTF8String read Emessage;
    constructor Create(domain: Cardinal; code: Integer; message: UTF8String); overload; (* actually pgchar *)
    constructor Create(gerror: Pointer); overload;
  end;
  EGErrorClass = class of EGError;

  (*$IFDEF FPC*)
  (*$M-*)
  (*$ENDIF FPC*)
  IGUserData = interface (* (IInvokable) triggers some weird error 'Type "Pointer" doesnt contain Type info' in delphi compiler *)
    ['{35377B66-6B1B-11D9-8827-00055DDDEA00}']
    (* userdata *)
    function GetUserData(const key: UTF8String): IInterface;
    procedure SetUserData(const key: UTF8String; const v: IInterface);

    function GetUserDataVariant(const key: UTF8String): Variant;
    procedure SetUserDataVariant(const key: UTF8String; const v: Variant);
    
    property UserData[const key: UTF8String]: IInterface read GetUserData write SetUserData;
  end;
  (*$M+*)

  (*$M-*) (* type 'Pointer' has no type information *)
  IGObject = interface (* (IGUserData) *)
    ['{74C01E0A-F4B5-4204-9229-5F0842F2362D}']
    //function getAnyProperty(name: string): TGValue;
    //procedure setAnyProperty(name: string; value: TGValue);
    function ObjectGetBoolProperty(name: string): Boolean;
    procedure ObjectSetBoolProperty(name: string; const value: Boolean);
    function ObjectGetIntProperty(name: string): Integer;
    procedure ObjectSetIntProperty(name: string; const value: Integer);
    function ObjectGetDoubleProperty(name: string): Double;
    procedure ObjectSetDoubleProperty(name: string; const value: Double);
    function ObjectGetUIntProperty(name: string): Cardinal;
    procedure ObjectSetUIntProperty(name: string; const value: Cardinal);
    function ObjectGetObjectUnwrappedProperty(name: string): Pointer; // GObject
    function ObjectGetObjectProperty(name: string): IGObject;
    procedure ObjectSetObjectUnwrappedProperty(name: string; const value: Pointer); // GObject
    procedure ObjectSetObjectProperty(name: string; const value: IGObject);
    function ObjectGetStringProperty(name: string): UTF8String;
    procedure ObjectSetStringProperty(name: string; const value: UTF8String);
    function ObjectGetFloatProperty(name: string): Single;
    procedure ObjectSetFloatProperty(name: string; const value: Single);
    //function Connect(signal: string; slot: TSlot): Integer; // fixme return value

    procedure FreezeNotify;
    procedure ThawNotify;
    procedure Notify(propertyName: string);

    function GetUnderlying: Pointer;
  end;
  (*$M+*) (* type 'Pointer' has no type information *)

(*no IFDEF need_igclosure*)
{$DEFINE define_consts}
{$INCLUDE iugclosure.inc}
{$UNDEF define_consts}
{$DEFINE define_types}
{$INCLUDE iugclosure.inc}
{$UNDEF define_types}
(*no ENDIF need_igclosure*)

implementation
uses uwrapgnames;

{ EGError }

constructor EGError.Create(gerror: Pointer);
var
  error: PWGError;
begin
  error := PWGError(gerror);
  
  Emessage := PChar(error.message);
  Edomain := error.domain;
  Ecode := error.code;
  
  inherited Create(Emessage);
end;

constructor EGError.Create(domain: Cardinal; code: Integer;
  message: UTF8String);
begin
  Emessage := message;
  inherited Create(Emessage);
  Edomain := domain;
  Ecode := code;
end;

function EGError.GetCode: Integer;
begin
  Result := Ecode;
end;

function EGError.GetDomain: Cardinal;
begin
  Result := Edomain;
end;

end.
