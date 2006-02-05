unit upangofontdescription;

interface
uses iupointermediator, upointermediator, iupango, upangotypes, iug;

type
  TPangoFontDescription = class(TPointerMediator, IPangoFontDescription, IPointerMediator, ICloneable, IInterface)
  protected
    procedure SetFamily(value: string);
    function GetFamily: string;
    procedure SetStyle(const value: TPangoStyle);
    function GetStyle: TPangoStyle;
    procedure SetVariant(const value: TPangoVariant);
    function GetVariant: TPangoVariant;
    procedure SetWeight(const value: TPangoWeight);
    function GetWeight: TPangoWeight;
    procedure SetStretch(const value: TPangoStretch);
    function GetStretch: TPangoStretch;
    procedure SetSize(const value: Integer);
    function GetSize: Integer;
    // unset_fields(which)
    // get_set_fields: which

  public
    constructor CreateWrapped(ptr: Pointer);
    constructor Create; reintroduce;
    constructor CreateFromString(data: string);

    function Clone: ICloneable;

    procedure MergeFrom(fd: IPangoFontDescription; replaceExistingFields: Boolean = False);

    // is self a better match than old, or a match that fits ideal at all?
    function BetterMatchOf(ideal: IPangoFontDescription; oldmatch: IPangoFontDescription = nil): Boolean;
    function ToString: string;

  published
    property Family: string read GetFamily write SetFamily;
    property Style: TPangoStyle read GetStyle write SetStyle;
    property Variant: TPangoVariant read GetVariant write SetVariant;
    property Weight: TPangoWeight read GetWeight write SetWeight;
    property Stretch: TPangoStretch read GetStretch write SetStretch;
    property Size: Integer read GetSize write SetSize;
  end;

implementation
uses uwrappangonames, ugtypes, uwrapgnames;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
// TODO? wrap
function pango_font_description_equal(a,b: PWPangoFontDescription): gboolean; cdecl; external pangolib;
procedure pango_font_description_free(descr: PWPangoFontDescription); cdecl; external pangolib;
function pango_font_description_better_match(desc, oldmatch, newmatch: PWPangoFontDescription): gboolean; cdecl; external pangolib;
procedure pango_font_description_merge(desc, tomerge: PWPangoFontDescription; replaceExistingFields: gboolean); cdecl; external pangolib;
//pango_font_description_unset_fields(desc: PWPangoFontDescription; tounset: WPangoFontMask); cdecl; external pangolib;
function pango_font_description_new: PWPangoFontDescription; cdecl; external pangolib;
procedure pango_font_description_set_family(desc: PWPangoFontDescription; family: PChar); cdecl; external pangolib;
function pango_font_description_get_family(desc: PWPangoFontDescription): PChar; cdecl; external pangolib; // returns const
procedure pango_font_description_set_style(desc: PWPangoFontDescription; style: WPangoStyle); cdecl; external pangolib;
function pango_font_description_get_style(desc: PWPangoFontDescription): WPangoStyle; cdecl; external pangolib;
procedure pango_font_description_set_variant(desc: PWPangoFontDescription; value: WPangoVariant); cdecl; external pangolib;
function pango_font_description_get_variant(desc: PWPangoFontDescription): WPangoVariant; cdecl; external pangolib;
procedure pango_font_description_set_weight(desc: PWPangoFontDescription; value: WPangoWeight); cdecl; external pangolib;
function pango_font_description_get_weight(desc: PWPangoFontDescription): WPangoWeight; cdecl; external pangolib;
procedure pango_font_description_set_stretch(desc: PWPangoFontDescription; value: WPangoStretch); cdecl; external pangolib;
function pango_font_description_get_stretch(desc: PWPangoFontDescription): WPangoStretch; cdecl; external pangolib;
procedure pango_font_description_set_size(desc: PWPangoFontDescription; value: gint); cdecl; external pangolib;
function pango_font_description_get_size(desc: PWPangoFontDescription): gint; cdecl; external pangolib;
function pango_font_description_get_set_fields(desc: PWPangoFontDescription):WPangoFontMask; cdecl; external pangolib;
procedure pango_font_description_unset_fields(desc: PWPangoFontDescription; which: WPangoFontMask); cdecl; external pangolib;
function pango_font_description_to_string(desc: PWPangoFontDescription): PChar; cdecl; external pangolib; // new
function pango_font_description_from_string(data: PChar): PWPangoFontDescription; cdecl; external pangolib;
{$endif gtk2q_standalone}
{ TPangoFontDescription }

function TPangoFontDescription.BetterMatchOf(ideal,
  oldmatch: IPangoFontDescription): Boolean;
begin
  Result := pango_font_description_better_match(GetUnderlying, oldmatch.GetUnderlying, ideal.GetUnderlying); // fixme
end;

function TPangoFontDescription.Clone: ICloneable;
begin
  Result := (*$IFDEF FPC*)TPangoFontDescription.(*$ENDIF FPC*)CreateWrapped(pango_font_description_copy(GetUnderlying));
end;

constructor TPangoFontDescription.Create;
begin
  CreateWrapped(pango_font_description_new());
end;

constructor TPangoFontDescription.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @pango_font_description_free);
end;

function TPangoFontDescription.ToString: string;
var
  native: PChar;
begin
  native := pango_font_description_to_string(GetUnderlying);
  Result := native;
  g_free(native);
end;

constructor TPangoFontDescription.CreateFromString(data: string);
begin
  CreateWrapped(pango_font_description_from_string(PChar(data)));
end;


function TPangoFontDescription.GetFamily: string;
begin
  Result := pango_font_description_get_family(GetUnderlying);
end;

function TPangoFontDescription.GetSize: Integer;
begin
  Result := pango_font_description_get_size(GetUnderlying);
end;

function TPangoFontDescription.GetStretch: TPangoStretch;
begin
  Result := TPangoStretch(pango_font_description_get_stretch(GetUnderlying));
end;

function TPangoFontDescription.GetStyle: TPangoStyle;
begin
  Result := TPangoStyle(pango_font_description_get_style(GetUnderlying));
end;

function TPangoFontDescription.GetVariant: TPangoVariant;
begin
  Result := TPangoVariant(pango_font_description_get_variant(GetUnderlying));
end;

function TPangoFontDescription.GetWeight: TPangoWeight;
begin
  Result := TPangoWeight(pango_font_description_get_weight(GetUnderlying));
end;

procedure TPangoFontDescription.MergeFrom(fd: IPangoFontDescription;
  replaceExistingFields: Boolean);
begin
  assert(Assigned(fd));
  pango_font_description_merge(GetUnderlying, fd.GetUnderlying, replaceExistingFields);
end;

procedure TPangoFontDescription.SetFamily(value: string);
begin
  pango_font_description_set_family(GetUnderlying, PChar(value));
end;

procedure TPangoFontDescription.SetSize(const value: Integer);
begin
  pango_font_description_set_size(GetUnderlying, value);
end;

procedure TPangoFontDescription.SetStretch(const value: TPangoStretch);
begin
  pango_font_description_set_stretch(GetUnderlying, WPangoStretch(value));
end;

procedure TPangoFontDescription.SetStyle(const value: TPangoStyle);
begin
  pango_font_description_set_style(GetUnderlying, WPangoStyle(value));
end;

procedure TPangoFontDescription.SetVariant(const value: TPangoVariant);
begin
  pango_font_description_set_variant(GetUnderlying, WPangoVariant(value));
end;

procedure TPangoFontDescription.SetWeight(const value: TPangoWeight);
begin
  pango_font_description_set_weight(GetUnderlying, value);
end;

end.
