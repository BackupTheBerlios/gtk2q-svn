unit iugtktreerowreference;

interface
uses iupointermediator, iug, iugtktreepath;

type
  IGtkTreeRowReference = interface(IPointerMediator)
    ['{00F580A9-C3B7-41BC-9A96-06B851EEB374}']
    function GetPath: IGtkTreePath;
    function Valid: Boolean;
    //class procedure Inserted(proxy: IGObject;path: IGtkTreePath);
    //class procedure Deleted(proxy: IGObject;path: IGtkTreePath);
    //class procedure Free(reference: ?I);
    //class procedure Reordered(proxy: IGObject;path: IGtkTreePath;var iter: TGtkTreeIter;var new_order: Integer);
  end;

implementation

end.
