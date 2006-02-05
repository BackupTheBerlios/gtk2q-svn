(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoLayoutIter = interface(IPointerMediator)
    ['{25EE3120-9650-11DA-8E1A-00055DDDEA00}']

    function GotoNextRun: Boolean;
    function GotoNextLine: Boolean;
    function GotoNextCluster: Boolean;
    procedure GetLineYRange(out y0, y1: Integer);
    procedure GetClusterExtents(out Ink, Logical: TPangoRectangle);
    procedure GetLineExtents(out Ink, Logical: TPangoRectangle);
    procedure GetRunExtents(out Ink, Logical: TPangoRectangle);

    function GetLine: IPangoLayoutLine;
    function GetIsAtLastLine: Boolean;
    function GetCharExtents: TPangoRectangle;
    function GetBaseline: Integer;
    function GetRun: IPangoLayoutRun;
    function GetIndex1: Integer;
    function GetLineExtentsLogical: TPangoRectangle;
    function GetRunExtentsLogical: TPangoRectangle;
    function GetClusterExtentsLogical: TPangoRectangle;
    function GetLineExtentsInk: TPangoRectangle;
    function GetRunExtentsInk: TPangoRectangle;
    function GetClusterExtentsInk: TPangoRectangle;

    property Line: IPangoLayoutLine read GetLine;
    property IsAtLastLine: Boolean read GetIsAtLastLine;
    property CharExtents: TPangoRectangle read GetCharExtents;
    property ClusterExtentsInk: TPangoRectangle read GetClusterExtentsInk;
    property ClusterExtentsLogical: TPangoRectangle read GetClusterExtentsLogical;
    property LineExtentsInk: TPangoRectangle read GetLineExtentsInk;
    property LineExtentsLogical: TPangoRectangle read GetLineExtentsLogical;
    property RunExtentsInk: TPangoRectangle read GetRunExtentsInk;
    property RunExtentsLogical: TPangoRectangle read GetRunExtentsLogical;
    property Baseline: Integer read GetBaseline;
    property Run: IPangoLayoutRun read GetRun;
    property Index1: Integer read GetIndex1;

  end;
(*$ENDIF define_types*)
