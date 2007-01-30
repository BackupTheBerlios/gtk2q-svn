unit uwrapgtksourceviewnames;

interface
uses ugtypes, uwrapgnames, uwrapgdknames;

{$INCLUDE static/clinksettings.inc}

type
  PWGtkSourceTagStyle = ^WGtkSourceTagStyle;
  WGtkSourceTagStyle = record
    isDefault: gboolean;
    mask: guint;
    foreground: WGdkColor;
    background: WGdkColor;
    italic: gboolean;
    bold: gboolean;
    underline: gboolean;
    strikethrough: gboolean;
    
    reserved1: byte;
    reserved2: byte;
    reserved3: byte;
    reserved4: byte;
    reserved5: byte;
    reserved6: byte;
    reserved7: byte;
    reserved8: byte;
    reserved9: byte;
    reserved10: byte;
    reserved11: byte;
    reserved12: byte;
    reserved13: byte;
    reserved14: byte;
    reserved15: byte;
    reserved16: byte;
  end;

const
(*$IFDEF WIN32*)
  gtksourceviewlib = 'libgtksourceview-1.0-0.dll';
(*$ELSE*)
  gtksourceviewlib = 'libgtksourceview-1.0.so.0';
(*$ENDIF WIN32*)

type
  PWGtkSourceBuffer = PGObject;
  PWGtkSourceMarker = PGObject;
  PWGtkSourceView = PGObject;
  PWGtkSourceLanguage = PGObject;
  PWGtkSourceLanguagesManager = PGObject;
  PWGtkSourceStyleScheme = PGObject;
  PWGtkSourceTag = PGObject;
  PWGtkSourceTagTable = PGObject;
  PWGtkSourceTagStyle = Pointer;
  PWGtkSourcePrintJob = PGObject;
  
  // Pint = ^gint; (* sigh *)

implementation

end.
