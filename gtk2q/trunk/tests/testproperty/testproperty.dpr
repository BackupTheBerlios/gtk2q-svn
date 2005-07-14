program testproperty;

{$APPTYPE CONSOLE}

uses
  SysUtils, iugtk, uapplication, ugtkwindow;

var
  w: IGtkWindow;
begin
  //Application.Init;
  w := DGtkWindow.Create;
  w.Title := 'hallo';
  w.Show;

  Application.Run;
  
  { TODO -oUser -cConsole Main : Hier Code einfügen }
end.
