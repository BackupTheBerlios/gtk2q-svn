unit iugnomecanvasbuf;

interface
uses ugnomecanvastypes, uarttypes, ugtypes;

type
  IGnomeCanvasBuf = interface
    ['{2FF408D1-A89E-47EB-9797-1BC3756B6E10}']
    (* TODO writable *)
    (* TODO: implementation *)

    function GetIsBackground: Boolean;
    function GetIsBuffer: Boolean;
    function GetBuffer: Pointer;
    function GetRect: TArtIRect;
    function GetRowstride: Integer;
    function GetBackgroundColor: guint32;

    property IsBackground: Boolean read GetIsBackground;
    property IsBuffer: Boolean read GetIsBuffer;
    property Buffer: Pointer read GetBuffer;
    property Rect: TArtIRect read GetRect;
    property Rowstride: Integer read GetRowstride;
    property BackgroundColor: guint32 read GetBackgroundColor; (* $rrggbb *)
  end;

implementation

end.
 