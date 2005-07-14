program testwindowbuttoncallback;

uses
  heaptrc,
  SysUtils,
  uapplication,
  iugdk,
  iugtk,
  ugtkwindow,
  ugtkbutton,
  iutyperegistry,
  utyperegistry,
  ugobject,
  //dialogs,
  iugobject;

type
  DMyWindow = class(DGtkWindow, IGtkWindow, IGObject, IInterface)
  private
    b: IGtkButton;
  public
    procedure Created; override;
    procedure FormButtonClicked(Sender: DGObject);
  end;

{ DMyWindow }

procedure DMyWindow.Created;
begin
  inherited;
  BorderWidth := 7;
  b := DCreateInstance(IGtkButton) as IGtkButton;
  b.Label1 := 'Hi';
  b.OnClicked.Add(FormButtonClicked);
  b.OnClicked.Remove(FormButtonClicked);
  b.OnClicked.Add(FormButtonClicked);
  b.Show;
  Add(b);
end;

procedure DMyWindow.FormButtonClicked(Sender: DGObject);
begin
  (*Application.Quit;*)
  //ShowMessage('test');
  Writeln('clicked');
end;

var
  w: DMyWindow;
begin
(*  Application.Init; auto. *)

  Writeln('HELPP');

  w := DMyWindow.Create;
  w.OnDestroy.Add(Application.QuitHandler);
  w.Show;

  // insert code here

  Application.Run;
end.
