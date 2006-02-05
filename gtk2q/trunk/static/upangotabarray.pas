unit upangotabarray;

interface
uses iupointermediator, upointermediator, iupango;

type
  TPangoTabArray = class(TPointerMediator, IPangoTabArray, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
  protected
    function GetCount: Integer;
  published
    function Clone: ICloneable;
    
    procedure SetTab(TabIndex: Integer; Location: Integer);
    procedure GetTab(TabIndex: Integer; out Location: Integer; out TabAlignment: TPangoTabAlign);

    procedure Clear;
    
    // GetTabs
    // GetPositionsInPixels
    
    property Count: Integer read GetCount;
  end;

implementation

procedure pango_tab_array_set_tab(tabarray: PWPangoTabArray; index1: gint; alignment: WPangoTabAlign; location: gint); cdecl; external pangolib;
procedure pango_tab_array_get_tab(tabarray: PWPangoTabArray; index1: gint; alignment: PWPangoTabAlign; location: PWgint); cdecl; external pangolib;
procedure pango_tab_array_free(tabarray: PWPangoTabArray); cdecl; external pangolib;
function pango_tab_array_get_size(tabarray: PWPangoTabArray): gint; cdecl; external pangolib;
procedure pango_tab_array_resize(tabarray: PWPangoTabArray; newsize: gint); cdecl; external pangolib;

constructor TPangoTabArray.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_tab_array_free);
end;

function TPangoTabArray.Clone: ICloneable;
begin
  Result := TPangoTabArray.CreateWrapped(pango_tab_array_copy(GetUnderlying)) as ICloneable;
end;
   
procedure TPangoTabArray.SetTab(TabIndex: Integer; Location: Integer; Alignment: TPangoTabAlignment = taLeft);
begin
  pango_tab_array_set_tab(GetUnderlying, TabIndex, Location);
end;

procedure TPangoTabArray.GetTab(TabIndex: Integer; out Location: Integer; out Alignment: TPangoTabAlign);
var
  clocation: gint;
  calignment: WPangoTabAlign;
begin
  pango_tab_array_get_tab(GetUnderlying, @clocation, @calignment);
end;

procedure TPangoTabArray.Clear;
begin
  pango_tab_array_resize(GetUnderlying, 0); // TEST
end;

function TPangoTabArray.GetCount: Integer;
begin
  Result := pango_tab_array_get_size(GetUnderlying);
end;

// GetTabs

// GetPositionsInPixels

end.
