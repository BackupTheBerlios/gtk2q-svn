unit iupango;

interface
uses iugobject, upangotypes, iupointermediator;

type
  IPangoFontDescription = interface;
  
  IPangoLayout = interface(IGObject)
    ['{FFFC31D9-C2CF-4F41-856F-7B41459D28DD}']

    // TODO
  end;
  
  IPangoContext = interface;
  
  IPangoFont = interface;
  IPangoFontset = interface;
  IPangoFontFamily = interface;
  TIPangoFontFamilyArray = array of IPangoFontFamily;
  IPangoFontMap = interface(IGObject)
    ['{C0517D5C-95E3-11DA-97ED-00055DDDEA00}']
    
    function GetShapeEngineType: string;

    function ListFamilies: TIPangoFontFamilyArray;
    function LoadFont(context: IPangoContext; description: IPangoFontDescription): IPangoFont;
    function LoadFontset(context: IPangoContext; description: IPangoFontDescription; language: TPangoLanguage): IPangoFontset;
    
    property ShapeEngineType: string read GetShapeEngineType;
  end;
  
  IPangoFontMetrics = interface(IPointerMediator)
    ['{AE676D80-95E4-11DA-85EB-00055DDDEA00}']

    function GetAscent: Integer;
    function GetDescent: Integer;
    function GetApproximateCharWidth: Integer;
    function GetApproximateDigitWidth: Integer;
    function GetUnderlinePosition: Integer;
    function GetUnderlineThickness: Integer;
    function GetStrikethroughPosition: Integer;
    function GetStrikethroughThickness: Integer;

    property Ascent: Integer read GetAscent;
    property Descent: Integer read GetDescent;
    property ApproximateCharWidth: Integer read GetApproximateCharWidth;
    property ApproximateDigitWidth: Integer read GetApproximateDigitWidth;
    property UnderlinePosition: Integer read GetUnderlinePosition;
    property UnderlineThickness: Integer read GetUnderlineThickness;
    property StrikethroughPosition: Integer read GetStrikethroughPosition;
    property StrikethroughThickness: Integer read GetStrikethroughThickness;
  end;
  
  IPangoFontset = interface(IPointerMediator)
    ['{7AF33EE8-95E9-11DA-BE80-00055DDDEA00}']
    
    // TODO generate? (there are class functions, derived classes, ... so it would be really better to generate it)
    
    // foreach
    function GetFont(unicodeCharacter: Cardinal): IPangoFont;
    function GetMetrics: IPangoFontMetrics;
    
    property Metrics: IPangoFontMetrics read GetMetrics;
  end;
  
  IPangoFontFace = interface(IGObject)
    ['{F851520C-95EA-11DA-A416-00055DDDEA00}']
    
    function GetFaceName: UTF8String; (* "suitable for displaying to users" ? *)
    
    function Describe: IPangoFontDescription;
    
    property FaceName: UTF8String read GetFaceName;
    
    function ListSizes: TPangoFontSizeArray;

    property Description: IPangoFontDescription read Describe;
  end;
  
  TIPangoFontFaceArray = array of IPangoFontFace;
  IPangoFontFamily = interface(IGObject)
    ['{8BB09A7C-95EA-11DA-8106-00055DDDEA00}']
    
    function GetName: string; (* utf? not utf? no idea *)
    
    function GetIsMonospace: Boolean;
    
    function ListFaces(): TIPangoFontFaceArray;
    
    property Name: string read GetName;
    property IsMonospace: Boolean read GetIsMonospace;
  end;
  
  IPangoEngine = interface(IGObject)
  end;
  
  IPangoEngineShape = interface(IPangoEngine)
    ['{A11A589E-95EF-11DA-B79C-00055DDDEA00}']
    
    // TODO
  end;
  
  IPangoCoverage = interface(IPointerMediator)
    ['{2668E94C-95F1-11DA-84DE-00055DDDEA00}']
    
    function GetLevel(aindex: Integer): TPangoCoverageLevel;
    procedure Max(other: IPangoCoverage);
    procedure SetLevel(aindex: Integer; level: TPangoCoverageLevel);
  end;
  
  (* this can probably be generated too? *)
  IPangoFont = interface(IGObject)
    ['{9653BBEA-95E9-11DA-BA3E-00055DDDEA00}']

    function Describe: IPangoFontDescription;
    
    function FindShaper(language: TPangoLanguage; CharacterCode: Cardinal): IPangoEngineShape;
    
    function GetCoverage(language: TPangoLanguage = nil): IPangoCoverage;
    
    procedure GetGlyphExtents(glyph: TPangoGlyph; out InkRectangle: TPangoRectangle; out LogicalRectangle: TPangoRectangle);
    
    function GetMetrics(language: TPangoLanguage = nil): IPangoFontMetrics;
    
    function GetFontMap: IPangoFontMap;
    
    property FontMap: IPangoFontMap read GetFontMap;
  end;
  
  IPangoContext = interface(IGObject)
    ['{84FF60D1-6DCC-430A-B7FD-6C8B0908AE6D}']

    function GetMetrics(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontMetrics;

    function GetLanguage: TPangoLanguage;
    procedure SetLanguage(value: TPangoLanguage);
    
    function GetBaseDirection: TPangoDirection;
    procedure SetBaseDirection(value: TPangoDirection);
    
    function GetFontDescription: IPangoFontDescription; // do not modify result!
    procedure SetFontDescription(value: IPangoFontDescription);
    
    function GetMatrix: TPangoMatrix;
    procedure SetMatrix(value: TPangoMatrix);
    
    function ListFamilies: TIPangoFontFamilyArray;
    function LoadFont(description: IPangoFontDescription): IPangoFont;
    function LoadFontset(description: IPangoFontDescription; language: TPangoLanguage = nil): IPangoFontset;
    
    // internal use ! function GetFontMap: IPangoFontMap;
    
    property Language: TPangoLanguage read GetLanguage write SetLanguage;
    property BaseDirection: TPangoDirection read GetBaseDirection write SetBaseDirection;
    property FontDescription: IPangoFontDescription read GetFontDescription write SetFontDescription;
    property Matrix: TPangoMatrix read GetMatrix write SetMatrix;
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

// TODO pango_language_to_string

// TODO pango_language_from_string

// TODO PangoDirection pango_unichar_direction      (gunichar ch);

implementation

end.
