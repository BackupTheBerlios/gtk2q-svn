(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoLayoutLine = interface(IPointerMediator)
    ['{1EF1DC0A-9650-11DA-BC48-00055DDDEA00}']

    function GetInkExtents: TPangoRectangle;
    function GetLogicalExtents: TPangoRectangle;
    function GetInkPixelExtents: TPangoRectangle;
    function GetLogicalPixelExtents: TPangoRectangle;
    property InkExtents: TPangoRectangle read GetInkExtents;
    property LogicalExtents: TPangoRectangle read GetLogicalExtents;
    property InkPixelExtents: TPangoRectangle read GetInkPixelExtents;
    property LogicalPixelExtents: TPangoRectangle read GetLogicalPixelExtents;
    procedure GetExtents(out InkExtents, LogicalExtents: TPangoRectangle);
    procedure GetPixelExtents(out InkExtents, LogicalExtents: TPangoRectangle);
    function IndexToX(index: Integer; trailing: Boolean): Integer;
    function XToIndex(xPos: Integer; out index: Integer; out trailing: Boolean): Boolean;
    function GetXRanges(startindex, endindex: Integer): TPangoRangeArray;
  end;
(*$ENDIF define_types*)
