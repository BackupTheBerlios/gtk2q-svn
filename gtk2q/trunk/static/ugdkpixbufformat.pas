unit ugdkpixbufformat;

interface
uses iugdkpixbufformat, ugtypes;

(* read only *)
type
  TGdkPixbufFormat = class(TInterfacedObject, IGdkPixbufFormat, IInvokable, IInterface)
  private
    Fdescription: UTF8String;
    Fextensions: TUTF8StringArray;
    FmimeTypes: TUTF8StringArray;
    Fname: UTF8String;
    Fformat: Pointer;
    Fwritable: Boolean;
  public
    constructor CreateWrapped(format: Pointer);
    function GetDescription: UTF8String;
    function GetExtensions: TUTF8StringArray;
    function GetMimeTypes: TUTF8StringArray;
    function GetName: UTF8String;
    function IsWritable: Boolean;

  published
    property Description: UTF8String read GetDescription;
    property Name: UTF8String read GetName;
    property Writable: Boolean read IsWritable;
  public
    property MimeTypes: TUTF8StringArray read GetMimeTypes;
    property Extensions: TUTF8StringArray read GetExtensions;
  end;

implementation
uses uwrapgnames, uwrapgdknames, uwrapgdkpixbufnames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
function gdk_pixbuf_format_get_description(fmt: PWGdkPixbufFormat): PGChar; cdecl; external gdkpixbuflib; // not const
function gdk_pixbuf_format_get_name(fmt: PWGdkPixbufFormat): PGChar; cdecl; external gdkpixbuflib; // not const
function gdk_pixbuf_format_get_extensions(fmt: PWGdkPixbufFormat): PPGChar; cdecl; external gdkpixbuflib; // not const
function gdk_pixbuf_format_get_mime_types(fmt: PWGdkPixbufFormat): PPGChar; cdecl; external gdkpixbuflib; // not const
function gdk_pixbuf_format_is_writable(fmt: PWGdkPixbufFormat): gboolean; cdecl; external gdkpixbuflib;
{$endif gtk2q_standalone}

(* TGdkPixbufFormat *)

constructor TGdkPixbufFormat.CreateWrapped(format: Pointer{PWGdkPixbufFormat});
var
  agstr: PGChar;
  aglist: PPGChar;
  xaglist: PPGChar;
  i: Integer;
begin
  inherited Create;
  Fformat := format; (* hmpf *)

  Fwritable := gdk_pixbuf_format_is_writable(format);

  agstr := gdk_pixbuf_format_get_name(format);
  if Assigned(agstr) then begin
    Fname := PChar(agstr);
    g_free(agstr);
  end else Fname := '';

  agstr := gdk_pixbuf_format_get_description(format);
  if Assigned(agstr) then begin
    Fdescription := PChar(agstr);
    g_free(agstr);
  end else Fdescription := '';

  SetLength(Fextensions, 0);
  aglist := gdk_pixbuf_format_get_extensions(format);
  xaglist := aglist;
  
  SetLength(Fextensions, 101);
  i := 0;
  if Assigned(xaglist) then
  for i := 0 to 100 do begin
    if not Assigned(xaglist^) then Break;
    Fextensions[i] := PChar(xaglist^);
    Inc(xaglist);
  end;
  SetLength(Fextensions, i);
  g_strfreev(aglist);


  SetLength(Fmimetypes, 0);
  aglist := gdk_pixbuf_format_get_extensions(format);
  xaglist := aglist;
  
  SetLength(Fmimetypes, 101);
  i := 0;
  if Assigned(xaglist) then
  for i := 0 to 100 do begin
    if not Assigned(xaglist^) then Break;
    Fmimetypes[i] := PChar(xaglist^);
    Inc(xaglist);
  end;
  SetLength(Fmimetypes, i);
  g_strfreev(aglist);
end;

function TGdkPixbufFormat.GetExtensions: TUTF8StringArray;
begin
  Result := Fextensions;
end;

function TGdkPixbufFormat.GetMimeTypes: TUTF8StringArray;
begin
  Result := Fmimetypes;
end;

function TGdkPixbufFormat.GetName: UTF8String;
begin
  Result := Fname;
end;

function TGdkPixbufFormat.GetDescription: UTF8String;
begin
  Result := Fdescription;
end;

function TGdkPixbufFormat.IsWritable: Boolean;
begin
  Result := Fwritable;
end;

end.
