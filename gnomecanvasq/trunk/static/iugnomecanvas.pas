unit iugnomecanvas;

interface
uses uarttypes, iupointermediator, iugtk, ugdktypes, iugdk,
iugnomecanvasbuf,
ugnomecanvastypes, ugtypes, sgnomecanvasitem, sgnomecanvas,
sgnomecanvasrichtext,
ugtktypes, upangotypes, iupango, iuart
;

type
  IGnomeCanvasPathDef = interface(IPointerMediator) (* + ICloneable *)
    ['{4D7094F2-12ED-4A21-814E-A2FB882939D4}']
    procedure Finish;
    (*EnsureSpace? *)
    
    (* methods *)

    procedure Reset;
    procedure MoveTo(x,y: Double);
    procedure LineTo(x,y: Double);
    
    (* Does not create new ArtBpath, but simply changes last lineto position *)
    procedure LineToMoving(x,y: Double);
    procedure CurveTo(x0,y0,x1,y1,x2,y2: Double);
    procedure ClosePath;

    (* Does not draw new line to startpoint, but moves last lineto *)
    procedure ClosePathCurrent;
    
    (* GetBPath ? (s) *)
    function Count: Integer;
    function IsEmpty: Boolean;
    function HasCurrentPoint: Boolean;
    procedure SetCurrentPoint(const point: TArtPoint);
    
    (* def_first_bpath, def_last_bpath O_o *)

    function GetAreAnyOpen: Boolean;
    function GetAreAllOpen: Boolean;
    function GetAreAnyClosed: Boolean;
    function GetAreAllClosed: Boolean;

    (* TODO Concat? *)

    property AreAnyOpen: Boolean read GetAreAnyOpen;
    property AreAllOpen: Boolean read GetAreAllOpen;
    property AreAnyClosed: Boolean read GetAreAnyClosed;
    property AreAllClosed: Boolean read GetAreAllClosed;
  end;

  IGnomeCanvasPoints = interface (* + IEnumerable? + ICloneable *)
    ['{EC274296-DEBC-4391-A9E7-D8E58C198240}']
    
    function GetPoints: TTArtPointArray;
    procedure SetPoints(const arr: TTArtPointArray);
    function GetCount: Integer;
    
    property Points: TTArtPointArray read GetPoints write SetPoints;
    property Count: Integer read GetCount;
  end;



const
  GTK_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE static/gnomecanvasincludes.inc}
{$UNDEF define_consts}

type
  IGnomeCanvasGroup = interface;
  
{$DEFINE define_types}
{$INCLUDE static/gnomecanvasincludes.inc}
{$UNDEF define_types}


implementation

{$DEFINE define_implementation}
{ $INCLUDE static/gnomecanvasincludes.inc}
{$UNDEF define_implementation}


end.
