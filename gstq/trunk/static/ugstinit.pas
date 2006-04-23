unit ugstinit;

interface

procedure GstreamerInit;

implementation
uses uapplication;

var
 appinitok : Integer = 0;
 
procedure GstreamerInit;
var
  argc: Integer;
  argv: PPChar;
  cargv: PPChar; // flat copy
begin
  GtkApplicationInit;
  
  if InterlockedIncrement(appinitok) = 1 then begin
    InitArgv(argc, argv);
    CloneFlatArgv(argv, cargv);

    gst_init(@argc, @cargv);
 
    DoneCloneFlatArgv(cargv);
    DoneArgv(argc, argv);
  end else
    InterlockedDecrement(appinitok)
end;

initialization
  
end.
