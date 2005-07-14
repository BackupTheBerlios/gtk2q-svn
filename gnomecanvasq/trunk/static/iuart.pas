unit iuart;

interface
uses uarttypes, iupointermediator;

type
  (* normal record for speed *)
  {$IFDEF NOT}
  IArtBPath = interface (* + ICloneable *)
    function GetCode: TArtPathCode;
    procedure SetCode(const value: TArtPathCode);
    
    property Code: TArtPathcode read GetCode write SetCode;

    (* hmm *)    
    property x1,y1,
    property x2,y2,
    property x3,y3: Double;
  end;
  {$ENDIF NOT}

  (* diacanvas needs that: *)
  IArtUtaItems = interface
    ['{D36F95C8-6CFB-4EFB-8BB9-E6405CD4BB9D}']
    function GetCount: Integer;
    function GetItem(const index: Integer): TArtUtaBbox;
    property Item[const index: Integer]: TArtUtaBbox read GetItem;
    property Count: Integer read GetCount;
  end;

  IArtUta = interface(IPointerMediator)
    ['{4FCB2BE7-84C0-4E62-82A6-14C80FF2A1F7}']
    function GetX0: Integer;
    function GetY0: Integer;
    function GetWidth: Integer;
    function GetHeight: Integer;
    procedure SetX0(const value: Integer);
    procedure SetY0(const value: Integer);
    procedure SetWidth(const value: Integer);
    procedure SetHeight(const value: Integer);
    function GetItemsProxy: IArtUtaItems;
    property x0: Integer read GetX0 write SetX0;
    property y0: Integer read GetY0 write SetY0;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Items: IArtUtaItems read GetItemsProxy;
  end;
  
  TTArtPointArray = array of TArtPoint; (* hmm *)

  {$IFDEF NOT}
  IArtVPathDashIndexer = interface (* + IEnumerable *)
    ['{40A6CB16-2AFA-4EDE-82E3-86B1A93C90B1}']
    
    function GetCount: Integer;
    function GetDash(const index: Integer): Double;
    procedure SetDash(const index: Integer; const value: Double);
    function Add(dash: Double): Integer;
    procedure Delete(index: Integer);
    procedure Clear;
    property Dash[Index: Integer] read GetDash write SetDash; default;
    property Count: Integer read GetCount;
  end;
  {$ENDIF NOT}

  TDashArray = array of Double;

  IArtVpathDash = interface (* + ICloneable *)
    ['{53541DF7-A592-4C85-98E3-D2920D92229B}']
    function GetOffset: Double;
    procedure SetOffset(const value: Double);
    (*function GetIndexer: IArtVPathDashIndexer;*)
    function GetDash: TDashArray;
    procedure SetDash(const value: TDashArray);
    property Offset: Double read GetOffset write SetOffset;
    (*property Dash: IArtVPathDashIndexer read GetIndexer;*)
    property Dash: TDashArray read GetDash write SetDash;
  end;
  
implementation

end.
