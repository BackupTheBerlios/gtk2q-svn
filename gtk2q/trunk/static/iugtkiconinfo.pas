unit iugtkiconinfo;

interface
uses iupointermediator, iugdk, ugdktypes, iug;

type
  IGtkIconInfo = interface(IPointerMediator)
    ['{52ABA369-8ACF-4466-A9C1-04D743F97F8D}']
    function GetDisplayName: string;
    procedure SetRawCoordinates(raw_coordinates: Boolean);
    //procedure GtkIconInfoFree;
    function GetBuiltinPixbuf: IGdkPixbuf;
    function LoadIcon: IGdkPixbuf;
    function GetFilename: String;
    function GetEmbeddedRect(var rectangle: TGdkRectangle): Boolean;
    function GetBaseSize: Integer;

    property BaseSize: Integer read GetBaseSize;
    property Filename: string read GetFilename;
    property BuiltinPixbuf: IGdkPixbuf read GetBuiltinPixbuf;
  end;

implementation

end.
