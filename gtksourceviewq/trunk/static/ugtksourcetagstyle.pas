unit ugtksourcetagstyle;

interface
uses iugtksourceview, iupointermediator, upointermediator, ugtypes;

type
  TGtkSourceTagStyle = class(DPointerMediator, IGtkSourceTagStyle, IPointerMediator, IInvokable, IInterface)
  published
    constructor CreateWrapped(ptr: Pointer);
  protected
    function GetIsDefault: Boolean;
    function GetMask: TGtkSourceTagStyleMask;
    function GetForeground: TGdkColor;
    function GetBackground: TGdkColor;
    function GetIsItalic: Boolean;
    function GetIsBold: Boolean;
    function GetIsUnderline: Boolean;
    function GetIsStrikethrough: Boolean;

  published
    property IsDefault: Boolean read GetIsDefault;
    property Mask: TGtkSourceTagStyleMask read GetMask;
    property Foreground: TGdkColor read GetForeground;
    property Background: TGdkColor read GetBackground; 
    property IsItalic: Boolean read GetIsItalic;
    property IsBold: Boolean read GetIsBold;
    property IsUnderline: Boolean read GetIsUnderline;
    property IsStrikethrough: Boolean read GetIsStrikethrough;
  end;

implementation
uses uwrapgnames, uwrapgtksourceviewnames;

{ TGtkSourceTagStyle }

constructor TGtkSourceTagStyle.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gtk_source_tag_style_free);
end;

function TGtkSourceTagStyle.GetIsDefault: Boolean;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.isDefault;
end;

function TGtkSourceTagStyle.GetMask: TGtkSourceTagStyleMask;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.mask;
end;

function TGtkSourceTagStyle.GetForeground: TGdkColor;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.foreground;
end;

function TGtkSourceTagStyle.GetBackground: TGdkColor;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.background;
end;

function TGtkSourceTagStyle.GetIsItalic: Boolean;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.italic;
end;

function TGtkSourceTagStyle.GetIsBold: Boolean;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.bold;
end;

function TGtkSourceTagStyle.GetIsUnderline: Boolean;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.underline;
end;

function TGtkSourceTagStyle.GetIsStrikethrough: Boolean;
begin
  Result := PWGtkSourceTagStyle(fPtr)^.strikethrough;
end;

end.
