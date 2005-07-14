unit ugtknotebookpage;

// EVIL HACK
// NO FREE FUNCTION
// DO NOT STORE
// DANGLING VOLATILE OBJECT
// SIGH
// DO NOT DEREFERENCE
// FEAR THE HACK

interface
uses iupointermediator, upointermediator, iugtknotebookpage;

type
  TGtkNotebookPage = class(DPointerMediator, IGtkNotebookPage, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  end;

implementation
uses uwrapgnames, utyperegistry, ugtypes, ugobject, uwrapgtknames;

constructor TGtkNotebookPage.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, nil); (* FIXME *)
end;

end.
