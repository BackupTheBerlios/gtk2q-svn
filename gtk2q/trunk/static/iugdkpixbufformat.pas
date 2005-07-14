unit iugdkpixbufformat;

interface
uses ugtypes;

type
  IGdkPixbufFormat = interface (* Readoncer *)
    ['{C6A51530-3BF9-414A-B314-BBA279121CF9}']
    function GetDescription: UTF8String;
    function GetExtensions: TUTF8StringArray;
    function GetMimeTypes: TUTF8StringArray;
    function GetName: UTF8String;
    function IsWritable: Boolean;
    
    property Description: UTF8String read GetDescription;
    property Name: UTF8String read GetName;
    property MimeTypes: TUTF8StringArray read GetMimeTypes;
    property Extensions: TUTF8StringArray read GetExtensions;
    property Writable: Boolean read IsWritable;
  end;

implementation

end.
