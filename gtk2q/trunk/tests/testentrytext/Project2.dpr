program Project2;

uses
  SysUtils,
  iugtk,
  ugtkwindow,
  uapplication,
  utyperegistry,
  ugtkentry,
  ugtkbutton,
  ugtkvbox,
  ugobject,
  dialogs;

var
  window: IGtkWindow;
  entry: IGtkEntry;
  button: IGtkButton;
  vbox: IGtkVBox;

type
  TDummy = class
    procedure buttonClickHandler(Sender: DGObject);
  end;

{ TDummy }

procedure TDummy.buttonClickHandler(Sender: DGObject);
begin
  ShowMessage(entry.Text);
end;

var
  dummy: TDummy;
begin
  dummy := TDummy.Create;
  window := DCreateInstance(IGtkWindow) as IGtkWindow;
  window.Show;
  // bug entry := DCreateInstance(IGtkEntry) as IGtkEntry;
  entry := DGtkEntry.Create;
  entry.Text := 'seas';
  // bug button := DCreateInstance(IGtkButton) as IGtkButton;
  button := DGtkButton.Create;
  button.OnClicked.Add(dummy.buttonClickHandler);
  button.Show;
  // bug vbox := DCreateInstance(IGtkVBox) as IGtkVBox;
  vbox := DGtkVBox.Create;
  window.Add(vbox);
  vbox.Add(entry);
  vbox.Add(button);
  entry.Show;
  vbox.Show;
  Application.Run;
  { TODO -oUser -cConsole Main : Hier Code einfügen }
end.
