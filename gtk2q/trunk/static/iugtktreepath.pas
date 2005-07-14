unit iugtktreepath;

interface
uses iupointermediator, iug, ugtypes;

type
  IGtkTreePath = interface(IPointerMediator)
    ['{52ABA369-8ACF-4466-A9C1-04D743F97F8D}']
    function IsDescendant(ancestor: IGtkTreePath): Boolean;
    function IsAncestor(descendant: IGtkTreePath): Boolean;
    function PrependIndex(index: Integer): IGtkTreePath;
    function AppendIndex(index: Integer): IGtkTreePath;
    //procedure Free;
    function GetDepth: Integer;
    function Compare(b: IGtkTreePath): Integer;
    function ToString: UTF8String;
    function GetIndices: TIntegerArray;
    function Up: IGtkTreePath; (* returns another or nil *)       
    function Prev: IGtkTreePath; (* returns another or nil *)
    function Down: IGtkTreePath; (* returns another *)
    function Next: IGtkTreePath; (* returns another *)
  end;

implementation

end.
