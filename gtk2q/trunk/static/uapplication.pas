unit uapplication;

interface
uses ugtypes, ugobject;

// gdk_pointer_grab, _is_grabbed ?
// gdk_keyboard_grab ?
// set_double_click_time ?

type
  TObjectIdleFunc = function(UserData: TObject): Boolean of object;
  TApplication = class
  public
    constructor Create;

    procedure Init;
    procedure Run;
    procedure Quit;
    procedure QuitHandler(Sender: TGObject);
    function GetCurrentEventTime: guint32;
    procedure NotifyStartupComplete;

    procedure SetProgramClass(s: string);
    function GetProgramClass: string;
    procedure Flush;
    function ExeName: string;
    procedure IdleAdd(idlefunc: TObjectIdleFunc; userdata: TObject = nil);

    (*class*) procedure CriticalSectionEnter; // GDK
    (*class*) procedure CriticalSectionLeave; // GDK



    //property CurrentEventTime: guint32 read GetCurrentEventTime;
  end;

var
  Application: TApplication = nil;

procedure GtkApplicationInit;

implementation
uses uwrapgnames, uwrapgdknames, uwrapgtknames, uargv, uginit, uglog, 
sysutils{$IFDEF DELPHI}, windows{$ENDIF DELPHI};

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
type
  TGSourceFunc = function(ba: gpointer): gboolean; cdecl;

procedure gdk_flush; cdecl; external gdklib;
function gdk_get_program_class: PChar; cdecl; external gdklib; (* const *)
procedure gdk_notify_startup_complete; cdecl; external gdklib;
procedure gdk_set_program_class(name: PChar); cdecl; external gdklib;
procedure g_thread_init(vtable: Pointer); cdecl; external gthreadlib;
procedure g_thread_init_with_errorcheck_mutexes(vtable: Pointer); cdecl; external gthreadlib; (* what is that *)
procedure gdk_threads_init(); cdecl; external gdklib;
procedure gdk_threads_enter(); cdecl; external gdklib;
procedure gdk_threads_leave(); cdecl; external gdklib;
function g_idle_add_full(priority: gint; sfunc: TGSourceFunc; data: gpointer; notify: DGDestroyNotify): guint; cdecl; external glib;

//gtk_get_current_event
function gtk_get_current_event_time(): guint32; cdecl; external gtklib;

procedure gtk_init(argc: PWgint; argv: gpointer); cdecl; external gtklib;
procedure gtk_main; cdecl; external gtklib;
procedure gtk_main_quit; cdecl; external gtklib;

//function gtk_get_current_event(): PGdkEvent; cdecl; external gtklib; // hmm ?
//function gtk_get_current_event_state(modifier: PGdkModifierType): gboolean; cdecl; external gtklib; // hmm ?

//GDK_CURRENT_TIME = 0L

// todo make that accessible.
function g_prg_get_name(): PGChar; cdecl; external glib; // const
function g_get_application_name(): PGChar; cdecl; external glib; // const

{$endif gtk2q_standalone}

var
 appinitok : Integer = 0;

procedure TApplication.CriticalSectionEnter;
begin
  gdk_threads_enter();
end;

procedure TApplication.CriticalSectionLeave;
begin
  gdk_threads_leave();
end;

function TApplication.ExeName: string;
begin
  Result := ParamStr(0);
end;

procedure TApplication.Flush;
begin
  gdk_flush;
end;

function TApplication.GetCurrentEventTime: guint32;
begin
  Result := gtk_get_current_event_time();
end;

function TApplication.GetProgramClass: string;
begin
  Result := gdk_get_program_class();
end;

type
  DIdleData = class
  private
    Fcallback: TObjectIdleFunc;
    Fuserdata: TObject;
  public
    property UserData: TObject read Fuserdata write Fuserdata;
    property AnFunc: TObjectIdleFunc read Fcallback write Fcallback;
  end;


function MyIdleHandler(dd: gpointer): gboolean; cdecl;
var
  d: DIdleData;
begin
  d := DIdleData(dd);
  Result := d.AnFunc(d.UserData);
end;

procedure DIdleDataFree(d: gpointer); cdecl;
begin
  DIdleData(d).Free;
end;

procedure TApplication.IdleAdd(idlefunc: TObjectIdleFunc; userdata: TObject = nil);
var
  d: DIdleData;
begin
  d := DIdleData.Create;
  d.AnFunc := idlefunc;
  d.UserData := userdata;
  g_idle_add_full(50, @MyIdleHandler, d, @DIdleDataFree);
end;

constructor TApplication.Create;
begin
  inherited Create;
  Init;
end;

procedure TApplication.Init;
var
  argc: Integer;
  argv: PPChar;
  cargv: PPChar; // flat copy
begin
  if InterlockedIncrement(appinitok) = 1 then begin
    g_thread_init(nil);
    (*gdk_threads_init();*) (* seems to make problems with the main loop *)

    InitArgv(argc, argv);
    CloneFlatArgv(argv, cargv);

    gtk_init(@argc, @cargv);

    DoneCloneFlatArgv(cargv);
    DoneArgv(argc, argv);

    InstallLogHandler;
    InstallQuarks;
  end else
    InterlockedDecrement(appinitok);
end;

procedure TApplication.NotifyStartupComplete;
begin
  gdk_notify_startup_complete;
end;

procedure TApplication.Quit;
begin
  gtk_main_quit;
end;

procedure TApplication.QuitHandler(Sender: TGObject);
begin
  Quit;
end;

procedure TApplication.Run;
begin
  gtk_main;
end;

procedure TApplication.SetProgramClass(s: string);
begin
  gdk_set_program_class(PChar(s));
end;


var
  ailock: Integer = 0;

procedure GtkApplicationInit;
begin
  if InterlockedIncrement(ailock) = 1 then begin
    if not Assigned(Application) then begin
      Application := TApplication.Create;
    end;
  end else (* do once *)
    InterlockedDecrement(ailock);
end;


initialization

finalization
  if Assigned(Application) then begin
    Application.Free;
    Application := nil;
  end;

end.
