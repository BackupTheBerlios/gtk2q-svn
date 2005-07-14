unit iuglade;

interface
uses utyperegistry, iugtk, ugtypes, sysutils, ugobject;

type
  EGladeFraud = class(Exception)
  end;
  
  IGladeWidgets = interface
    ['{92EB9280-8AE8-4DD8-B5E2-9CCAAA0A019D}']
    procedure RegisterClass(widgetName: string; myclass: TGObjectClass);
    function GetWidget(widgetName: string): IGtkWidget;
    function GetWidgetNames: TUTF8StringArray;

    property Names: TUTF8StringArray read GetWidgetNames;

    // autoconnect ?
    // my extensions for any objects ?
  end;

implementation

end.
