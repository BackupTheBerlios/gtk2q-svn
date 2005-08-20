unit ugcharsets;

interface
uses iugobject;

type
  TGConvertErrorCode = (ecNoConversion, ecIllegalSequence, ecFailed, ecPartialInput, ecBadURI, ecNotAbsolutePath);
  EGConvertError = class(EGError)
  public
    function GetCode: TGConvertErrorCode; reintroduce;
  public
    property Code: TGConvertErrorCode read GetCode; 
  end;

(* TODO Stream Proxy that converts any/locale <-> UTF8 *)

(* g_uri_list_extract_uris ? *)

function FilenameToUTF8(const filename: string): UTF8String; (* exception *)
function UTF8ToFilename(const s: UTF8String): string; (* exception *)

function FilenameToURI(const filename: string; const hostname: string): string;  (* exception *)
function URIToFilename(const uri: string; out hostname: string): string; (* exception *)

function LocaleToUTF8(const s: string): UTF8String; (* exception *)
function UTF8ToLocale(const s: UTF8String): string; (* exception *)

(* 2.6
function FilenameToDisplayName(const filename: string): UTF8String;
function FilenameToDisplayBasename(const filename: string): UTF8String; // need full absolute path
*)

function IsLocaleCharsetUTF8: Boolean;
function LocaleCharset: string; 

implementation
uses uwrapgnames, ugtypes;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

function g_convert(const str: PGChar; len: gssize; const toCodeSet, fromCodeSet: PGChar; 
  bytesRead, bytesWritten: PWgsize; 
  error: PPWGError): PGChar; cdecl; external glib;

function g_convert_with_fallback (const str: PGChar; len: gssize; const toCodeSet, fromCodeSet: PGChar;
  fallback: PGChar;
  bytesRead, bytesWritten: PWgsize;
  error: PPWGError): PGChar; cdecl; external glib;

(*
GIConv;
gchar *g_convert_with_iconv (const gchar * str,
			     gssize len,
			     GIConv converter,
			     gsize * bytes_read,
			     gsize * bytes_written, GError ** error);
#define     G_CONVERT_ERROR
GIConv g_iconv_open (const gchar * to_codeset, const gchar * from_codeset);
size_t g_iconv (GIConv converter,
		gchar ** inbuf,
		gsize * inbytes_left, gchar ** outbuf, gsize * outbytes_left);
gint g_iconv_close (GIConv converter);
*)

function g_locale_to_utf8 (const opsysstring: PGChar;
			 len: gssize;
			 bytesRead, bytesWritten: PWgsize; 
			 error: PPWGError): PGChar; cdecl; external glib;
			 
function g_filename_to_utf8 (const opsysstring: PGChar;
			 len: gssize;
			 bytesRead, bytesWritten: PWgsize; 
			 error: PPWGError): PGChar; cdecl; external glib;
function g_filename_from_utf8 (const utf8string: PGChar;
			 len: gssize;
			 bytesRead, bytesWritten: PWgsize; 
			 error: PPWGError): PGChar; cdecl; external glib;
function g_filename_from_uri (const uri: PGChar; hostname: PPgchar; 
	error: PPWGError): PGChar; cdecl; external glib;
	
function g_filename_to_uri (const filename, hostname: PGChar;
	error: PPWGError): PGchar; cdecl; external glib;
			  
(*gboolean g_get_filename_charsets (G_CONST_RETURN gchar *** charsets);*)
function g_filename_display_name(const filename: PGChar): PGChar; cdecl; external glib;
function g_filename_display_basename (const filename: PGChar): PGChar; cdecl; external glib;
(* gchar **g_uri_list_extract_uris (const gchar * uri_list); *)
function g_locale_from_utf8 (const utf8string: PGChar;
			 len: gssize;
			 bytesRead, bytesWritten: PWgsize; 
			 error: PPWGError): PGChar; cdecl; external glib;

function g_get_charset ({constreturn} charset: PPGChar): gboolean; cdecl; external glib;

{$endif gtk2q_standalone}

function FilenameToUTF8(const filename: string): UTF8String; (* exception *)
var
  error: PWGError;
  aglist: PGChar;
begin
  error := nil;
  aglist := g_filename_to_utf8(PGChar(PChar(filename)), -1, nil, nil, @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)
    
  Result := PChar(aglist);
  g_free(aglist);
end;

function UTF8ToFilename(const s: UTF8String): string; (* exception *)
var
  error: PWGError;
  aglist: PGChar;
begin
  error := nil;
  aglist := g_filename_from_utf8(PGChar(PChar(s)), -1, nil, nil, @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)
    
  Result := PChar(aglist);
  g_free(aglist);
end;

function FilenameToURI(const filename: string; const hostname: string): string;  (* exception *)
var
  error: PWGError;
  aglist: PGChar;
begin
  error := nil;
  (* TODO NULL for no hostname *)
  aglist := g_filename_to_uri(PGChar(PChar(filename)), PGChar(PChar(hostname)), @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)
    
  Result := PChar(aglist);
  g_free(aglist);
end;

function URIToFilename(const uri: string; out hostname: string): string; (* exception *)
var
  error: PWGError;
  chostname: PGChar;
  aglist: PGChar;
begin
  error := nil;
  aglist := g_filename_from_uri(PGChar(PChar(uri)), @chostname, @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)
    
  Result := PChar(aglist);
  g_free(aglist);

  (* always non-null? *)
  hostname := PChar(chostname);
  g_free(chostname);
end;

function LocaleToUTF8(const s: string): UTF8String; (* exception *)
var
  error: PWGError;
  aglist: PGChar;
begin
  error := nil;
  aglist := g_locale_to_utf8(PGChar(PChar(s)), -1, nil, nil, @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)

  Result := PChar(aglist);
  g_free(aglist);
end;

function UTF8ToLocale(const s: UTF8String): string; (* exception *)
var
  error: PWGError;
  aglist: PGChar;
begin
  error := nil;

  aglist := g_locale_from_utf8(PGChar(PChar(s)), -1, nil, nil, @error);
  if not Assigned(aglist) then
    HandleAndFreeGError(error, EGConvertError); (* raises *)
    
  Result := PChar(aglist);
  g_free(aglist);
end;

(* 2.6
function FilenameToDisplayName(const filename: string): UTF8String;
var
  aglist: PGChar;
begin
  aglist := g_filename_display_name(PGChar(PChar(filename)));
  // guaranteed to be non-null
  Result := aglist;
  g_free(aglist);
end;

function FilenameToDisplayBasename(const filename: string): UTF8String;
var
  aglist: PGChar;
begin
  aglist := g_filename_display_basename(PGChar(PChar(filename)));
  Result := aglist;
  g_free(aglist);
end;

*)

function IsLocaleCharsetUTF8: Boolean;
var
  ccharset: PGChar;
begin
  Result := g_get_charset(@ccharset);
  (* not free *)
end;

function LocaleCharset: string; 
var
  ccharset: PGChar;
begin
  g_get_charset(@ccharset);
  
  Result := PChar(ccharset);
  (* not free *)
end;

{ EGConvertError }

function EGConvertError.GetCode: TGConvertErrorCode;
begin
  Result := TGConvertErrorCode(inherited GetCode);
end;

end.
