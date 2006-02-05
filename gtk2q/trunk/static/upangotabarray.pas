unit upangotabarray;

interface
uses iupointermediator, upointermediator, iupango, iug, upangotypes;

// EEEK!

{$M+}

type
  TPangoTabArray = class(TPointerMediator, IPangoTabArray, IPointerMediator, ICloneable, IInvokable, IInterface)
  protected
    fPinnedTo: IInterface;
  public
    constructor CreateWrapped(ptr: Pointer);
    constructor CreateWrappedPinned(ptr: Pointer; pinnedTo: IInterface);
    constructor Create(positionsInPixels: Boolean = True); reintroduce; // EEEK!
  protected
    function GetCapacity: Integer;
    procedure SetCapacity(value: Integer);
    function GetPositionsInPixels: Boolean;
  published
    function Clone: ICloneable;
    
    procedure SetTab(TabIndex: Integer; Location: Integer; Alignment: TPangoTabAlign = taLeft);
    procedure GetTab(TabIndex: Integer; out Location: Integer; out Alignment: TPangoTabAlign);

    procedure Clear;
    
    // GetTabs
    
    property Capacity: Integer read GetCapacity write SetCapacity;
    property PositionsInPixels: Boolean read GetPositionsInPixels; // EEEK!
  end;

implementation
uses ugtypes, uwrapgnames, uwrappangonames;

procedure pango_tab_array_set_tab(tabarray: PWPangoTabArray; index1: gint; alignment: WPangoTabAlign; location: gint); cdecl; external pangolib;
procedure pango_tab_array_get_tab(tabarray: PWPangoTabArray; index1: gint; alignment: PWPangoTabAlign; location: PWgint); cdecl; external pangolib;
procedure pango_tab_array_free(tabarray: PWPangoTabArray); cdecl; external pangolib;
function pango_tab_array_get_size(tabarray: PWPangoTabArray): gint; cdecl; external pangolib;
procedure pango_tab_array_resize(tabarray: PWPangoTabArray; newsize: gint); cdecl; external pangolib;
function pango_tab_array_new(initial_size: gint; positions_in_pixels: gboolean): PWPangoTabArray; cdecl; external pangolib;
function pango_tab_array_get_positions_in_pixels(tabarray: PWPangoTabArray): gboolean; cdecl; external pangolib;

constructor TPangoTabArray.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_tab_array_free);
end;

constructor TPangoTabArray.Create(positionsInPixels: Boolean = True); // EEEK!
begin  
  CreateWrapped(pango_tab_array_new(10, positionsInPixels));
end;

constructor TPangoTabArray.CreateWrappedPinned(ptr: Pointer; pinnedTo: IInterface);
begin
  assert(Assigned(pinnedTo));
  fPinnedTo := pinnedTo;
  inherited Create(ptr, nil);
end;

function TPangoTabArray.Clone: ICloneable;
begin
  Result := TPangoTabArray.CreateWrapped(pango_tab_array_copy(GetUnderlying)) as ICloneable;
end;
   
procedure TPangoTabArray.SetTab(TabIndex: Integer; Location: Integer; Alignment: TPangoTabAlignment = taLeft);
begin
  pango_tab_array_set_tab(GetUnderlying, TabIndex, WPangoTabAlign(Alignment), Location);
end;

procedure TPangoTabArray.GetTab(TabIndex: Integer; out Location: Integer; out Alignment: TPangoTabAlign);
var
  clocation: gint;
  calignment: WPangoTabAlign;
begin
  pango_tab_array_get_tab(GetUnderlying, TabIndex, @calignment, @clocation);
end;

procedure TPangoTabArray.Clear;
var
  OldCapacity: Integer;
begin
  OldCapacity := Capacity;
  Capacity := 0; // TODO test
  Capacity := OldCapacity;
end;

function TPangoTabArray.GetCapacity: Integer;
begin
  Result := pango_tab_array_get_size(GetUnderlying);
end;

function TPangoTabArray.GetPositionsInPixels: Boolean;
begin
  Result := pango_tab_array_get_positions_in_pixels(GetUnderlying);
end;

procedure TPangoTabArray.SetCapacity(value: Integer);
begin
  pango_tab_array_resize(GetUnderlying, value);
end;

end.
