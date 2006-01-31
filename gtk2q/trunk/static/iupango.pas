unit iupango;

interface
uses iugobject, upangotypes, iupointermediator;

type
  IPangoLayout = interface(IGObject)
    ['{FFFC31D9-C2CF-4F41-856F-7B41459D28DD}']
    // TODO
  end;
  
  IPangoContext = interface(IGObject)
    ['{84FF60D1-6DCC-430A-B7FD-6C8B0908AE6D}']
  end;

  IPangoFont = interface(IGObject)
    ['{758911D8-6FE4-48E9-8017-A793063A8E24}']
  end;

  IPangoAttrList = interface(IGObject)
    ['{E446E54B-CD69-421C-843F-5A07DD90FC72}']
  end;

  IPangoTabArray = interface(IGObject)
    ['{C5EF37A4-3D24-42CD-9016-43B96FE5F95D}']
  end;

  IPangoFontDescription = interface(IPointerMediator)
    ['{AF9CACF7-CCEC-4CE8-ABA1-526A5EF46208}']

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
    // get_set_fields(which)

    function ToString: string;

    procedure MergeFrom(fd: IPangoFontDescription; replaceExistingFields: Boolean = False);

    // is self a better match than old, or a match that fits ideal at all?
    function BetterMatchOf(ideal: IPangoFontDescription; oldmatch: IPangoFontDescription = nil): Boolean;

    property Family: string read GetFamily write SetFamily;
    property Style: TPangoStyle read GetStyle write SetStyle;
    property Variant: TPangoVariant read GetVariant write SetVariant;
    property Weight: TPangoWeight read GetWeight write SetWeight;
    property Stretch: TPangoStretch read GetStretch write SetStretch;
    property Size: Integer read GetSize write SetSize;
  end;

implementation

end.
