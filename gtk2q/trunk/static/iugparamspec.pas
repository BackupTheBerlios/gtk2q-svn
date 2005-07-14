unit iugparamspec;

interface
//     (set of (readable,writable,construct,constructonly,laxvalidation,private))

type
  IGParamSpec = interface
    function GetName: UTF8String;
    function GetNick: UTF8String;
    function GetBlurb: UTF8String;
    function GetRedirectTarget: IGParamSpec;
    function GetFlags: DGParamFlags;
    function FlagsToNative(flags: DGParamFlags): Integer;

    property Name: UTF8String read GetName;
    property Nick: UTF8String read GetNick;
    property Blurb: UTF8String read GetBlurb;
    property Flags: DGParamFlags; 
    property RedirectTarget: IGParamSpec read GetRedirectTarget; // if any

    //ValueType: GType ? FIXME
  end;

  IGParamSpecBoolean = interface(IGParamSpec)
    function GetDefaultValue: Boolean;
    
    class function Create(name, nick, blurb: UTF8String; 
      defaultValue: Boolean = False; 
      flags: DGParamFlags = [pReadable, pWritable]): IGParamSpecBoolean;

    property DefaultValue: Boolean read GetDefaultValue;    
  end;
  
  IGParamSpecBoxed = interface(IGParamSpec)
  end;
  
  IGParamSpecByte = interface(IGParamSpec)
    function GetMinimum: Byte;
    function GetMaximum: Byte;
    function GetDefaultValue: Byte;

    property Minimum: Byte read GetMinimum;
    property Maximum: Byte read GetMaximum;
    property DefaultValue: Byte read GetDefaultValue;
  end;
  
  IGParamSpecInt8 = interface(IGParamSpec)
    function GetMinimum: gint8;
    function GetMaximum: gint8;
    function GetDefaultValue: gint8;

    property Minimum: gint8 read GetMinimum;
    property Maximum: gint8 read GetMaximum;
    property DefaultValue: gint8 read GetDefaultValue;
  end;
  
  IGParamSpecDouble = interface(IGParamSpec)
    function GetMinimum: Double;
    function GetMaximum: Double;
    function GetDefaultValue: Double;
    function GetEpsilon: Double;

    property Minimum: Doubler read GetMinimum;
    property Maximum: Double read GetMaximum;
    property DefaultValue: Double read GetDefaultValue;
    property Epsilon: Double read GetEpsilon;
  end;
  
  IGParamSpecEnum = interface(IGParamSpec)
    function GetDefaultValue: Integer; (* not quite *)
    
    property DefaultValue: Integer read GetDefaultValue;
  end;

  IGParamSpecInt = interface(IGParamSpec)
    function GetMinimum: Integer;
    function GetMaximum: Integer;
    function GetDefaultValue: Integer;

    property Minimum: Integer read GetMinimum;
    property Maximum: Integer read GetMaximum;
    property DefaultValue: Integer read GetDefaultValue;
  end;

  IGParamSpecUInt = interface(IGParamSpec)
    function GetMinimum: guint;
    function GetMaximum: guint;
    function GetDefaultValue: guint;

    property Minimum: guint read GetMinimum;
    property Maximum: guint read GetMaximum;
    property DefaultValue: guint read GetDefaultValue;
  end;
  
  IGParamSpecInt64 = interface(IGParamSpec)
    function GetMinimum: Int64;
    function GetMaximum: Int64;
    function GetDefaultValue: Int64;

    property Minimum: Int64 read GetMinimum;
    property Maximum: Int64 read GetMaximum;
    property DefaultValue: Int64 read GetDefaultValue;
  end;

  IGParamSpecLong = interface(IGParamSpec)
    function GetMinimum: Longint;
    function GetMaximum: Longint;
    function GetDefaultValue: Longint;

    property Minimum: Longint read GetMinimum;
    property Maximum: Longint read GetMaximum;
    property DefaultValue: Longint read GetDefaultValue;
  end;

  IGParamSpecObject = interface(IGParamSpecBoxed)
  end;

  IGParamSpecSingle = interface(IGParamSpec)
    function GetMinimum: Single;
    function GetMaximum: Single;
    function GetDefaultValue: Single;
    function GetEpsilon: Single;

    property Minimum: Single read GetMinimum;
    property Maximum: Single read GetMaximum;
    property DefaultValue: Single read GetDefaultValue;
    property Epsilon: Single read GetEpsilon;
  end;

  IGParamSpecString = interface(IGParamSpec)
    function GetDefaultValue: UTF8String;
    function GetCSetFirst: DGParamSpecStringCSet;
    function GetCSetNth: DGParamSpecStringCSet;
    function GetSubstitutor: char;
    function GetNullFoldIfEmpty: Boolean;
    function GetEnsureNonNull: Boolean;
  end;
    
implementation

end.
