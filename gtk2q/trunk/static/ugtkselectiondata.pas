unit ugtkselectiondata;

interface
uses iupointermediator, upointermediator, iugtktreepath, iugtkselectiondata;

type
  TGtkSelectionData = class(DPointerMediator, IGtkSelectionData, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  end;

implementation
uses uwrapgnames, uwrapgtknames;

// TODO make the members accessible

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PGtkSelectionData = Pointer;

procedure gtk_selection_data_free(data:PGtkSelectionData); cdecl; external gtklib;
{$endif gtk2q_standalone}

{ TGtkIconInfo }

constructor TGtkSelectionData.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_selection_data_free);
end;

end.
 