unit ugerrorquark;

(* TODO *)
// unused
interface
uses ugtypes;

function ErrorQuarkToClass(domain: TGQuark): TGObjectClass;

implementation
uses ugdkpixbuf, ugtkfilechooser, ugtkicontheme, ugtkfilesystem;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
function gdk_pixbuf_error_quark(): TGQuark; cdecl; external gdkpixbuflib;
function gtk_file_chooser_error_quark(): TGQuark; cdecl; external gtklib;
function gtk_icon_theme_error_quark(): TGQuark; cdecl; external gtklib;
function gtk_file_system_error_quark(): TGQuark; cdecl; external gtklib;
function g_convert_error_quark(): TGQuark; cdecl; external glib;
{$endif gtk2q_standalone}

function ErrorQuarkToClass(domain: TGQuark): TGObjectClass;
begin
  Result := TGObject;
  if domain = gdk_pixbuf_error_quark() then 
    Result := TGdkPixbuf
  else if domain = gtk_file_chooser_error_quark() then
    Result := TGtkFileChooser
  else if domain = gtk_icon_theme_error_quark() then
    Result := TGtkIconTheme
  else if domain = gtk_file_system_error_quark() then
    Result := TGtkFileSystem
  else if domain = g_convert_error_quark() then
    Result := nil;
end;

end.
