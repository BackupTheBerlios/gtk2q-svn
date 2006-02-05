unit upangofontface;

interface
uses iugobject, ugobject, iupango, upangotypes, ugtypes;

type
  TPangoFontFace = class(TGObject, IPangoFontFace, IGObject, IInvokable, IInterface)
  protected
    function GetFaceName: UTF8String; (* "suitable for displaying to users" ? *)
    function Describe: IPangoFontDescription;
  public
    class procedure TypeRegister; override; (* flat *)
    class function OverrideGType: TGType; override; (* 0: not *)

  published
    function ListSizes: TPangoFontSizeArray;
  published
    property Description: IPangoFontDescription read Describe;
    property FaceName: UTF8String read GetFaceName;
  end;
  
implementation
uses uwrapgnames, uwrappangonames, upangofontdescription, utyperegistry;

type
  PPWgint_n = ^PWgint_n;
  PWgint_n = ^gint;
  
{$INCLUDE clinksettings.inc}
{$ifdef gtk2q_standalone}
function pango_font_face_get_type: TGType; cdecl; external pangolib;
function pango_font_face_get_face_name(face: Pointer{PangoFontFace*}): PChar; cdecl; external pangolib;
function pango_font_face_describe(face: Pointer{PangoFontFace*}): PWPangoFontDescription; cdecl; external pangolib;
procedure pango_font_face_list_sizes(face: Pointer{PangoFontFace*}; sizes: PPWgint_n; nsizes: PWgint); cdecl; external pangolib;
{$endif gtk2q_standalone}

function TPangoFontFace.GetFaceName: UTF8String; (* "suitable for displaying to users" ? *)
var
  clowlevel: PChar;
begin
  clowlevel := pango_font_face_get_face_name(fObject);
  Result := clowlevel;
  // DO NOT FREE
end;

function TPangoFontFace.Describe: IPangoFontDescription;
var
  clowlevel: PWPangoFontDescription;
begin
  clowlevel := pango_font_face_describe(fObject);
  Result := TPangoFontDescription.CreateWrapped(clowlevel); (* TODO test refcounting *)
end;

function TPangoFontFace.ListSizes: TPangoFontSizeArray;
var
  csizes: PWgint;
  csizescnt: gint;
  i: gint;
begin
  SetLength(Result, 0);
  pango_font_face_list_sizes(fObject, @csizes, @csizescnt);
  if Assigned(csizes) then begin
    SetLength(Result, csizescnt);
    // TODO delphi:
    for i := 0 to csizescnt - 1 do begin 
      Result[i] := (csizes + i)^;
    end;
    g_free(csizes);
  end;
end;

class procedure TPangoFontFace.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('TPangoFontFace', 'pango', TPangoFontFace, pango_font_face_get_type, IPangoFontFace);
end;

class function TPangoFontFace.OverrideGType: TGType;
begin
  Result := 0;
end;

initialization
  DGlobalTypeRegisterLock;
  TPangoFontFace.TypeRegister;
  DGlobalTypeRegisterUnlock;

end.
