unit ugtktextattributes;

interface
uses iupointermediator, upointermediator, iugtktextattributes, iug;

type
  TGtkTextAttributes = class(DPointerMediator, IGtkTextAttributes, IPointerMediator, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    //Clone FIXME
    //CloneValues FIXME
  end;

implementation
uses uwrapgnames, uwrapgtknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

type
  PGtkTextAttributes = Pointer;

procedure gtk_text_attributes_unref(values: PGtkTextAttributes); cdecl; external gtklib;

{$endif gtk2q_standalone}

constructor TGtkTextAttributes.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_text_attributes_unref);
end;

end.

