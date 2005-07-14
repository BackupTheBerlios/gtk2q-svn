unit udiashape;

interface
uses iudiacanvas, upointermediator, iupointermediator, udiacanvastypes, iuart, uarttypes,
iupango, ugnomecanvastypes, upangotypes, iugdk;

// TODO

type
  TDiaShape = class(DPointerMediator, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  protected
    constructor CreateWrapped(ptr: Pointer); virtual;
  protected
    procedure SetColor(const color: TDiaColor);
  published
    (* shapetype *)
    (*
    Visibility
    UpdateCnt
    RefCnt
    *)
    property Color: TDiaColor write SetColor;
  end;
  TDiaShapePath = class(TDiaShape, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  private
    procedure SetCapStyle(const Value: TDiaCapStyle);
    procedure SetClipping(const Value: Boolean);
    procedure SetCyclic(const Value: Boolean);
    procedure SetDash(const Value: IArtVpathDash);
    procedure SetFillStyle(const Value: TDiaFillStyle);
    procedure SetJoinStyle(const Value: TDiaJoinStyle);
    procedure SetLineWidth(const Value: Double);
    procedure SetVpath(const Value: DArtVpath);
  protected
    procedure SetFillColor(const color: TDiaColor);
  published
    property ArtVpath: DArtVpath write SetVpath;
    property FillColor: TDiaColor write SetFillColor;
    property FillStyle: TDiaFillStyle write SetFillStyle;
    property JoinStyle: TDiaJoinStyle write SetJoinStyle;
    property CapStyle: TDiaCapStyle write SetCapStyle;
    property Cyclic: Boolean write SetCyclic;
    property Clipping: Boolean write SetClipping;
    property LineWidth: Double write SetLineWidth;
    property Dash: IArtVpathDash write SetDash;
  end;
  TDiaShapeBezier = class(TDiaShape, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  private
    procedure SetBpath(const Value: DArtBpath);
    procedure SetCapStyle(const Value: TDiaCapStyle);
    procedure SetClipping(const Value: Boolean);
    procedure SetCyclic(const Value: Boolean);
    procedure SetDash(const Value: IArtVpathDash);
    procedure SetFillStyle(const Value: TDiaFillStyle);
    procedure SetJoinStyle(const Value: TDiaJoinStyle);
    procedure SetLineWidth(const Value: Double);
  protected
    procedure SetFillColor(const color: TDiaColor);
  published
    property ArtBpath: DArtBpath write SetBpath;
    property FillColor: TDiaColor write SetFillColor;
    property FillStyle: TDiaFillStyle write SetFillStyle;
    property JoinStyle: TDiaJoinStyle write SetJoinStyle;
    property CapStyle: TDiaCapStyle write SetCapStyle;
    property Cyclic: Boolean write SetCyclic;
    property Clipping: Boolean write SetClipping;
    property LineWidth: Double write SetLineWidth;
    property Dash: IArtVpathDash write SetDash;
  end;
  TDiaShapeText = class(TDiaShape, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  private
    procedure SetAffine(const Value: TAffineTransform);
    procedure SetAlignment(const Value: DPangoAlignment);
    procedure SetFontDesc(const Value: IPangoFontDescription);
    procedure SetIsMarkup(const Value: Boolean);
    procedure SetJustify(const Value: Boolean);
    procedure SetLineSpacing(const Value: Double);
    procedure SetMaxHeight(const Value: Double);
    procedure SetMaxWidth(const Value: Double);
    procedure SetText(const Value: UTF8String);
    procedure SetTextWidth(const Value: Double);
    procedure SetWrapMode(const Value: TDiaWrapMode);
  published
    property FontDesc: IPangoFontDescription write SetFontDesc;
    property Text: UTF8String write SetText;
    (*NeedFree*)
    property Justify: Boolean write SetJustify;
    property Markup: Boolean write SetIsMarkup;
    property WrapMode: TDiaWrapMode write SetWrapMode;
    property LineSpacing: Double write SetLineSpacing;
    property Alignment: DPangoAlignment write SetAlignment;
    property TextWidth: Double write SetTextWidth;
    property MaxWidth: Double write SetMaxWidth;
    property MaxHeight: Double write SetMaxHeight;
  public
    property Affine: TAffineTransform write SetAffine;
    //err.. property Cursor: gint
  end;
  TDiaShapeEllipse = class(TDiaShape, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  private
    procedure SetCenter(const Value: TDiaPoint);
    procedure SetDash(const Value: IArtVpathDash);
    procedure SetFillColor(const Value: TDiaColor);
    procedure SetFillStyle(const Value: TDiaFillStyle);
    procedure SetHeight(const Value: Double);
    procedure SetLineWidth(const Value: Double);
    procedure SetWidth(const Value: Double);
  published
    property Center: TDiaPoint write SetCenter;
    property Width: Double write SetWidth;
    property Height: Double write SetHeight;
    property FillColor: TDiaColor write SetFillColor;
    property FillStyle: TDiaFillStyle write SetFillStyle;
    property LineWidth: Double write SetLineWidth;
    property Dash: IArtVpathDash write SetDash;
  end;
  TDiaShapeImage = class(TDiaShape, IDiaShapeText, IPointerMediator, IInvokable, IInterface)
  private
    procedure SetAffine(const Value: TAffineTransform);
    procedure SetPixbuf(const Value: IGdkPixbuf);
  published
    property Pixbuf: IGdkPixbuf write SetPixbuf;
  public
    property Affine: TAffineTransform write SetAffine;
  end;

implementation
uses uwrapdiacanvasnames, uwrapgnames, ugtypes, uwrappangonames;

type
  PPangoLayout = Pointer; (* sigh *)
  

(*$IFDEF gtk2q_standalone*)
procedure dia_shape_unref(shape: PWDiaShape); cdecl; external diacanvaslib;
function dia_shape_ref(shape: PWDiaShape): PWDiaShape; cdecl; external diacanvaslib;
procedure dia_shape_free(shape: PWDiaShape); cdecl; external diacanvaslib;
function dia_shape_new(typ: WDiaShapeType): PWDiaShape; cdecl; external diacanvaslib;
procedure dia_shape_request_update(shape: PWDiaShape); cdecl; external diacanvaslib;
procedure dia_shape_set_color(shape: PWDiaShape; color: WDiaColor); cdecl; external diacanvaslib;
// not implemented: dia_shape_get_bounds

(* path properties *)
procedure dia_shape_path_set_fill_color(shape: PWDiaShape; fillColor: WDiaColor); cdecl; external diacanvaslib;
procedure dia_shape_path_set_line_width(shape: PWDiaShape; lineWidth: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_path_set_join(shape: PWDiaShape; join: WDiaJoinStyle); cdecl; external diacanvaslib;
procedure dia_shape_path_set_cap(shape: PWDiaShape; cap: WDiaCapStyle); cdecl; external diacanvaslib;
procedure dia_shape_path_set_fill(shape: PWDiaShape; fill: WDiaFillStyle); cdecl; external diacanvaslib;
procedure dia_shape_path_set_cyclic(shape: PWDiaShape; cyclic: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_path_set_clipping(shape: PWDiaShape; clipping: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_path_set_dash(shape: PWDiaShape; offset: gdouble; nDash: guint; dash: array of gdouble); cdecl; external diacanvaslib;

(* bezier *)
procedure dia_shape_bezier_set_fill_color(shape: PWDiaShape; fillColor: WDiaColor); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_fill(shape: PWDiaShape; fill: WDiaFillStyle); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_line_width(shape: PWDiaShape; lineWidth: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_join(shape: PWDiaShape; join: WDiaJoinStyle); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_cap(shape: PWDiaShape; cap: WDiaCapStyle); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_cyclic(shape: PWDiaShape; cyclic: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_clipping(shape: PWDiaShape; clipping: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_bezier_set_dash(shape: PWDiaShape; offset: gdouble; nDash: guint; dash: array of gdouble); cdecl; external diacanvaslib;

(* ellipse *)
procedure dia_shape_ellipse_set_fill_color(shape: PWDiaShape; fillColor: WDiaColor); cdecl; external diacanvaslib;
procedure dia_shape_ellipse_set_fill(shape: PWDiaShape; fill: WDiaFillStyle); cdecl; external diacanvaslib;
procedure dia_shape_ellipse_set_line_width(shape: PWDiaShape; lineWidth: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_ellipse_set_clipping(shape: PWDiaShape; clipping: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_ellipse_set_dash(shape: PWDiaShape; offset: gdouble; nDash: guint; dash: array of gdouble); cdecl; external diacanvaslib;

(* text *)
procedure dia_shape_text_set_font_description(shape: PWDiaShape; desc: PPangoFontDescription); cdecl; external diacanvaslib;
procedure dia_shape_text_set_text(shape: PWDiaShape; const text: PGChar); cdecl; external diacanvaslib;
procedure dia_shape_text_set_static_text(shape: PWDiaShape; const text: PGChar); cdecl; external diacanvaslib;
procedure dia_shape_text_set_affine(shape: PWDiaShape; affine: TAffineTransform); cdecl; external diacanvaslib;
procedure dia_shape_text_set_pos(shape: PWDiaShape; pos: PWDiaPoint); cdecl; external diacanvaslib;
procedure dia_shape_text_set_text_width(shape: PWDiaShape; width: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_text_set_line_spacing(shape: PWDiaShape; lineSpacing: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_text_set_max_width(shape: PWDiaShape; maxWidth: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_text_set_max_height(shape: PWDiaShape; maxHeight: gdouble); cdecl; external diacanvaslib;
procedure dia_shape_text_set_justify(shape: PWDiaShape; justify: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_text_set_markup(shape: PWDiaShape; markup: gboolean); cdecl; external diacanvaslib;
procedure dia_shape_text_set_wrap_mode(shape: PWDiaShape; wrapMode: WDiaWrapMode); cdecl; external diacanvaslib;
procedure dia_shape_text_set_alignment(shape: PWDiaShape; alignment: TPangoAlignment); cdecl; external diacanvaslib;

function dia_shape_text_to_pango_layout(shape: PWDiaShape; fill: gboolean): PPangoLayout; cdecl; external diacanvaslib;
procedure dia_shape_text_fill_pango_layout(shape: PWDiaShape; layout: PPangoLayout); cdecl; external diacanvaslib;
procedure dia_shape_text_cursor_from_pos(shape: PWDiaShape; pos: PWDiaPoint; cursor: Pgint); cdecl; external diacanvaslib;

(* image *)
procedure dia_shape_image_set_affine(shape: PWDiaShape; affine: TAffineTransform); cdecl; external diacanvaslib;
procedure dia_shape_image_set_pos(shape: PWDiaShape; pos: PWDiaPoint); cdecl; external diacanvaslib;

(* dia_shape_clip deprecated *)

(* private dia_shape_is_updated, dia_shape_need_update *)
// todo isclippath (each)

//dia_shape_path_is_clip_path

//set_visibility
//set_color

(*$ENDIF gtk2q_standalone*)

constructor TDiaShape.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @dia_shape_unref);
end;


procedure TDiaShape.SetColor(const color: TDiaColor);
begin
  dia_shape_set_color(PWDiaShape(fPtr), color);
end;

{ TDiaShapePath }

procedure TDiaShapePath.SetCapStyle(const Value: TDiaCapStyle);
begin
  dia_shape_path_set_cap(PWDiaShapePath(fPtr), WDiaCapStyle(value));
end;

procedure TDiaShapePath.SetClipping(const Value: Boolean);
begin
  dia_shape_path_set_clipping(PWDiaShapePath(fPtr), value);
end;

procedure TDiaShapePath.SetCyclic(const Value: Boolean);
begin
  dia_shape_path_set_cyclic(PWDiaShapePath(fPtr), value);
end;

procedure TDiaShapePath.SetDash(const Value: IArtVpathDash);
begin
  //TODO  dia_shape_path_set_dash(PWDiaShapePath(fPtr), value);
end;

procedure TDiaShapePath.SetFillColor(const color: TDiaColor);
begin
  dia_shape_path_set_fill_color(PWDiaShapePath(fPtr), color);
end;

procedure TDiaShapePath.SetFillStyle(const Value: TDiaFillStyle);
begin
  dia_shape_path_set_fill(PWDiaShapePath(fPtr), WDiaFillStyle(value));
end;

procedure TDiaShapePath.SetJoinStyle(const Value: TDiaJoinStyle);
begin
  dia_shape_path_set_join(PWDiaShapePath(fPtr), WDiaJoinStyle(value));

end;

procedure TDiaShapePath.SetLineWidth(const Value: Double);
begin
  dia_shape_path_set_line_width(PWDiaShapePath(fPtr), value);

end;

procedure TDiaShapePath.SetVpath(const Value: DArtVpath);
begin
  // TODO
end;

{ TDiaShapeBezier }

procedure TDiaShapeBezier.SetBpath(const Value: DArtBpath);
begin
  // TODO dia_shape_bezier_set_bpath(PWDiaShapeBezier(fPtr), value);
end;

procedure TDiaShapeBezier.SetCapStyle(const Value: TDiaCapStyle);
begin
  dia_shape_bezier_set_cap(PWDiaShapeBezier(fPtr), WDiaCapStyle(value));
end;

procedure TDiaShapeBezier.SetClipping(const Value: Boolean);
begin
dia_shape_bezier_set_clipping(PWDiaShapeBezier(fPtr), value);
end;

procedure TDiaShapeBezier.SetCyclic(const Value: Boolean);
begin
dia_shape_bezier_set_cyclic(PWDiaShapeBezier(fPtr), value);
end;

procedure TDiaShapeBezier.SetDash(const Value: IArtVpathDash);
begin
  // TODO dia_shape_bezier_set_PWDiaShapeBezier(fPtr), value);
end;

procedure TDiaShapeBezier.SetFillColor(const color: TDiaColor);
begin
  dia_shape_bezier_set_fill_color(PWDiaShapeBezier(fPtr), WDiaColor(color));
end;

procedure TDiaShapeBezier.SetFillStyle(const Value: TDiaFillStyle);
begin
  dia_shape_bezier_set_fill(PWDiaShapeBezier(fPtr), WDiaFillStyle(value));
end;

procedure TDiaShapeBezier.SetJoinStyle(const Value: TDiaJoinStyle);
begin
  dia_shape_bezier_set_join(PWDiaShapeBezier(fPtr), WDiaJoinStyle(value));
end;

procedure TDiaShapeBezier.SetLineWidth(const Value: Double);
begin
  dia_shape_bezier_set_line_width(PWDiaShapeBezier(fPtr), value);
end;

{ TDiaShapeText }

procedure TDiaShapeText.SetAffine(const Value: TAffineTransform);
begin
  dia_shape_text_set_affine(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetAlignment(const Value: DPangoAlignment);
begin
  dia_shape_text_set_alignment(PWDiaShapeText(fPtr), TPangoAlignment(Value));
end;

procedure TDiaShapeText.SetFontDesc(const Value: IPangoFontDescription);
begin
//  dia_shape_text_set_font_desc(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetIsMarkup(const Value: Boolean);
begin
  dia_shape_text_set_markup(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetJustify(const Value: Boolean);
begin
  dia_shape_text_set_justify(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetLineSpacing(const Value: Double);
begin
  dia_shape_text_set_line_spacing(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetMaxHeight(const Value: Double);
begin
  dia_shape_text_set_max_height(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetMaxWidth(const Value: Double);
begin
  dia_shape_text_set_max_width(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetText(const Value: UTF8String);
begin
  dia_shape_text_set_text(PWDiaShapeText(fPtr), PGChar(PChar(Value)));
end;

procedure TDiaShapeText.SetTextWidth(const Value: Double);
begin
  dia_shape_text_set_text_width(PWDiaShapeText(fPtr), Value);
end;

procedure TDiaShapeText.SetWrapMode(const Value: TDiaWrapMode);
begin
  dia_shape_text_set_wrap_mode(PWDiaShapeText(fPtr), WDiaWrapMode(Value));
end;

{ TDiaShapeImage }

procedure TDiaShapeImage.SetAffine(const Value: TAffineTransform);
begin
  dia_shape_image_set_affine(PWDiaShapeImage(fPtr), value);
end;

procedure TDiaShapeImage.SetPixbuf(const Value: IGdkPixbuf);
begin
//TODO  dia_shape_image_set_pixbuf(PWDiaShapeImage(fPtr), value);
end;

{ TDiaShapeEllipse }

procedure TDiaShapeEllipse.SetCenter(const Value: TDiaPoint);
begin
//   dia_shape_ellipse_set_center(PWDiaShapeEllipse(fPtr), WDiaPoint(Value));
end;

procedure TDiaShapeEllipse.SetDash(const Value: IArtVpathDash);
begin
  // TODO
end;

procedure TDiaShapeEllipse.SetFillColor(const Value: TDiaColor);
begin
  dia_shape_ellipse_set_fill_color(PWDiaShapeEllipse(fPtr), WDiaColor(Value));
end;

procedure TDiaShapeEllipse.SetFillStyle(const Value: TDiaFillStyle);
begin
  dia_shape_ellipse_set_fill(PWDiaShapeEllipse(fPtr), WDiaFillStyle(Value));
end;

procedure TDiaShapeEllipse.SetHeight(const Value: Double);
begin
//  dia_shape_ellipse_set_height(PWDiaShapeEllipse(fPtr), value);
end;

procedure TDiaShapeEllipse.SetLineWidth(const Value: Double);
begin
  dia_shape_ellipse_set_line_width(PWDiaShapeEllipse(fPtr), value);
end;

procedure TDiaShapeEllipse.SetWidth(const Value: Double);
begin
  //dia_shape_ellipse_set_width(PWDiaShapeEllipse(fPtr), value);
end;

end.
