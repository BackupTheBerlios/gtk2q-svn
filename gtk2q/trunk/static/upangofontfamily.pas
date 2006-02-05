unit upangofontfamily;

interface
uses iupango, iug, iugobject, ugobject, ugtypes;

type
  TPangoFontFamily = class(TGObject, IPangoFontFamily, IGObject, IInvokable, IInterface)
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)

  protected
    function GetName: string; (* utf? not utf? no idea *)
    
    function GetIsMonospace: Boolean;
    
  published
    function ListFaces(): TIPangoFontFaceArray;
    
    property Name: string read GetName;
    property IsMonospace: Boolean read GetIsMonospace;
  end;
  
implementation
uses uwrapgnames, uwrappangonames, upangofontface, utyperegistry;

{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_font_family_get_type: TGType; cdecl; external pangolib;
function pango_font_family_get_name(family: Pointer{PangoFontFamily*}): PChar; cdecl; external pangolib;
function pango_font_family_is_monospace(family: Pointer{PangoFontFamily*}): gboolean; cdecl; external pangolib;
procedure pango_font_family_list_faces(family: Pointer{PangoFontFamily*}; faces: PPPWPangoFontFace; nfaces: PWgint); cdecl; external pangolib;
{$endif gtk2q_standalone}

function TPangoFontFamily.GetName: string; (* utf? not utf? no idea *)
var
  cstring: PChar;
begin
  cstring := pango_font_family_get_name(fObject);
  assert(Assigned(cstring));
  Result := cstring;
  // DO NOT FREE
end;
    
function TPangoFontFamily.GetIsMonospace: Boolean;
begin
  Result := pango_font_family_is_monospace(fObject);
end;
    
function TPangoFontFamily.ListFaces(): TIPangoFontFaceArray;
var 
  faces: PPWPangoFontFace;
  nfaces: gint;
  i: gint;
begin
  // TODO test
  
  SetLength(Result, 0);
  pango_font_family_list_faces(fObject, @faces, @nfaces);
  if Assigned(faces) then begin
    SetLength(Result, nfaces);
    for i := 0 to nfaces - 1 do begin
      Result[i] := TPangoFontFace.CreateWrapped((faces + i)^); (* TODO: refcounting *)
    end;
    
    g_free(faces);
  end;
end;

class procedure TPangoFontFamily.TypeRegister; (* flat *)
begin
  inherited TypeRegister;
  DTypeRegister('TPangoFontFamily', 'pango', TPangoFontFamily, pango_font_family_get_type, IPangoFontFamily);
end;

class function TPangoFontFamily.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoFontFamily.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
