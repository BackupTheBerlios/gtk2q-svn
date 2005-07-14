unit uwrapdiacanvasnames;

interface
uses ugtypes, uwrapgnames, uwrapartnames, uwrappangonames, uwrapgdkpixbufnames;

(*$INCLUDE static/clinksettings.inc*)

type
  PWDiaRectangle = ^WDiaRectangle;
  WDiaRectangle = record (* C *)
    left, top, right, bottom: gdouble;
  end;

  PWDiaHandle = PGObject;
  PWDiaVariable = PGObject;
  WDiaEventMask = gint;
  PWDiaCanvasElement = PGObject;
  PWDiaCanvasView = PGObject;
  PWDiaHandleLayer = PGObject;
  
  PWDiaCanvasGroupable = Pointer; (* interface *)
  PWDiaConstraint = Pointer;

  PWDiaCanvasViewItem = Pointer; (* ?? *)

  PWDiaSolver = PGObject;
  PWDiaTool = PGObject;

  PWDiaStackTool = PGObject;
  PWDiaDefaultTool = PGObject;
  PWDiaPlacementTool = PGObject;
  PWDiaSelectionTool = PGObject;
  PWDiaItemTool = PGObject;
  PWDiaHandleTool = PGObject;

  WDiaJoinStyle = gint;
  WDiaCapStyle = gint;

  PWDiaUndoManager = PGObject;
  PWDiaUndoAction = Pointer;
  WDiaUndoFunc = procedure(action: PWDiaUndoAction); cdecl;

  PPWDiaExpression = ^PWDiaExpression;
  PWDiaExpression = Pointer; // ?

  PWDiaPoint = ^WDiaPoint;
  WDiaPoint = record (* C *)
    x,y: gdouble;
  end;

  WDiaColor = guint32;

  PWDiaCanvasIter = Pointer;
  PWDiaCanvasItem = PGObject;
  PWDiaCanvasGroup = PGObject; (* a PWDiaCanvasItem *)
  //PWDiaCanvas = PGObject;

  (* fixme remove that! *)
  PWDiaCanvas = ^WDiaCanvas;
  WDiaCanvas = record (* C *)
    parent: TGObject;

    (*< public, read only >*)
    flags: guint32;
    (*gboolean static_extents: 1;
    gboolean snap_to_grid: 1;
    gboolean allow_undo: 1;
    gboolean allow_state_requests: 1;
    //NOT gboolean in_undo: 1;
    *)

    extents: WDiaRectangle;

    (* the root item in the canvas -- is a group *)
    root: PWDiaCanvasItem;

    (* Variables for a grid: *)
    intervalX, intervalY, offsetX, offsetY: gdouble;
    gridColor: WDiaColor; (* RGB grid color *)
    gridBg: WDiaColor; (* RGB background color. *)

    solver: PWDiaSolver;

    (*< private >*)
    idleId: guint;

    (* Undo/redo behavior *)
    undoManager: PWDiaUndoManager;
  end;

  PWDiaShapeText = Pointer; (* shape *)
  
  WDiaFillStyle = gint;
  WDiaWrapMode = gint;


 (* DiaShape:  This is a collection of properties that count for all
  * shapes. All shapes are "inherited" from DiaShape. *)

  WDiaShapeType = gint; (* none,path,bezier,ellipse,text,image,widget,clip *)
  PWDiaShape = Pointer; //^WDiaShape;
  WDiaShape = record (* C *)
     typ: WDiaShapeType;

     visupdaterefcnt: guint32; (*is:
     visibility: guint: 4;
     update_cnt: guint: 14;
     ref_cnt: guint: 14;
     *)

     color: WDiaColor;

     extra_1: gpointer;
  end;

  (**
   * DiaShapePath:
   *
   * Path like shapes are lines, polygons, rectangles, etc.
   * If the shape is cyclic, you can set the fill style to
   * DIA_FILL_SOLID and use fill_color to specify a color for the content.
   *
   * Note that one shape can only represent a line, or a surface (e.g.
   * a filled rectangle).
   **)
  PWDiaShapePath = Pointer; //^WDiaShapePath;
  WDiaShapePath = record (* C *)
    shape: WDiaShape;
    vpath: TArtVpath;
	  fillColor: WDiaColor;

    fjccc: guint32;
{	guint     fill: 8;
	guint     join: 8;
	guint     cap: 8;
	guint     cyclic: 1;
	guint     clipping: 1;
}

    lineWidth: gdouble;
    dash: TArtVpathDash;
  end;

  (**
   * DiaShapeBezier:
   *
   * Bezier path.
   **)
  PWDiaShapeBezier = Pointer; // ^WDiaShapeBezier;
  WDiaShapeBezier = record (* C *)
	  shape: WDiaShape;
  	bpath: TArtBpath;
	  fillColor: WDiaColor;
    fjccc: guint32;
  {
	guint     fill: 8;
	guint     join: 8;
	guint     cap: 8;
	guint     cyclic: 1;
	guint     clipping: 1;
  }

    lineWidth: gdouble;
    dash: TArtVpathDash;
  end;

  (**
   * DiaShapeEllipse:
   *
   * Shape for ellipses and circles. This might be extended in the
   * near future to arc (curve) like shapes.
   **)
  PWDiaShapeEllipse = Pointer;
  WDiaShapeEllipse = record (* C *)
	  shape: WDiaShape;

    center: WDiaPoint;
    width, height: gdouble;
    fillColor: WDiaColor;

    fc: guint16;
{
	guint     fill: 8;
	guint     clipping: 1;
}

    lineWidth: gdouble;
    dash: TArtVpathDash;
  end;

  (**
   * DiaShapeText:
   *
   * Text is described by a font (font_desc) and a text string.
   * The text can be clipped by setting maximum values for width and
   * height. The text_width property can be used to determine the width
   * of the text block (text can be word-wrapped at text_width).
   *
   * A special part of a #DiaShapeText object is its cursor position. A
   * #DiaCanvasItem can specify a cursor position in the text. The cursor will
   * only be drawn if the view has the focus and if the object containing the
   * shape has the focus. As a result there will only be one cursor visible
   * in all #DiaCanvasViews.
   **)
   WDiaShapeText = record (* C *)
    shape: WDiaShape;

    fontDesc: PPangoFontDescription;
    text: Pgchar;
    needFree: gboolean;
    justify: gboolean;
    markup: gboolean;
    wrapMode: WDiaWrapMode;
	  lineSpacing: gdouble;
    alignment: TPangoAlignment;
    textWidth: gdouble;

    (* Width and height for clipping text. *)
    maxWidth, maxHeight: gdouble;

    (* affine[6] unrolled *)
    affine0: gdouble;
    affine1: gdouble;
    affine2: gdouble;
    affine3: gdouble;
    affine4: gdouble;
    affine5: gdouble;

	  cursor: gint;
  end;

  (**
   * DiaShapeImage:
   *
   * A DiaShapeImage contains an image. The affine matrix can be used
   * to change the offset. Rotating and shearing can result in ugly results.
   **)
   PWDiaShapeImage = Pointer;
   WDiaShapeImage = record (* C *)
     shape: WDiaShape;

     pixbuf: PGdkPixbuf;
     (* affine[6] unrolled *)
     affine0: gdouble;
     affine1: gdouble;
     affine2: gdouble;
     affine3: gdouble;
     affine4: gdouble;
     affine5: gdouble;
   end;

  WDiaCanvasIter = record (* C *)
    data1: gpointer;
    data2: gpointer;
    data3: gpointer;
    destroyFunc: TGDestroyNotify;
    stamp: gint;
  end;

  PWDiaDashStyle = ^WDiaDashStyle;
  WDiaDashStyle = record (* C *)
    nDash: guint;
    dash: Pgdouble;
  end;

  PWDiaCanvasEditable = Pointer; (* interface ? *)

  WDiaStrength = gint;

const
{$IFDEF WIN32}
  diacanvaslib = 'libdiacanvas2-0.dll';
{$ELSE}
  diacanvaslib = 'libdiacanvas2.so.0';
{$ENDIF WIN32}

function dia_canvas_box_new: PWDiaCanvasItem;
function dia_canvas_group_new: PWDiaCanvasItem;
function dia_canvas_image_new: PWDiaCanvasItem;
function dia_canvas_line_new: PWDiaCanvasItem;
function dia_canvas_text_new: PWDiaCanvasItem;

function dia_canvas_item_create(typ: GType; firstArg: PgChar): PWDiaCanvasItem; cdecl; external diacanvaslib; overload;
function dia_canvas_item_create(typ: GType; firstArg: PgChar; others: array of const): PWDiaCanvasItem; cdecl; external diacanvaslib;overload;

function dia_canvas_box_get_type: GType; cdecl; external diacanvaslib;
function dia_canvas_group_get_type: GType; cdecl; external diacanvaslib;
function dia_canvas_image_get_type: GType; cdecl; external diacanvaslib;
function dia_canvas_line_get_type: GType; cdecl; external diacanvaslib;
function dia_canvas_text_get_type: GType; cdecl; external diacanvaslib;

procedure dia_canvas_editable_start_editing(editable: PWDiaCanvasEditable; shape: PWDiaShapeText); cdecl; external diacanvaslib;
procedure dia_canvas_editable_text_changed(editable: PWDiaCanvasEditable; shape: PWDiaShapeText; newText: PGChar); cdecl; external diacanvaslib;
procedure dia_canvas_editable_editing_done(editable: PWDiaCanvasEditable; shape: PWDiaShapeText; newText: PGChar); cdecl; external diacanvaslib;


function dia_canvas_groupable_length(groupable: PWDiaCanvasGroupable): gint; cdecl; external diacanvaslib;
function dia_canvas_groupable_next(groupable: PWDiaCanvasGroupable; iter: PWDiaCanvasIter): gboolean; cdecl; external diacanvaslib;
function dia_canvas_groupable_get_iter(groupable: PWDiaCanvasGroupable; iter: PWDiaCanvasIter): gboolean; cdecl; external diacanvaslib;
function dia_canvas_groupable_value(groupable: PWDiaCanvasGroupable; iter: PWDiaCanvasIter): PWDiaCanvasItem; cdecl; external diacanvaslib;
procedure dia_canvas_groupable_remove(groupable: PWDiaCanvasGroupable; item: PWDiaCanvasItem); cdecl; external diacanvaslib;
procedure dia_canvas_groupable_add(groupable: PWDiaCanvasGroupable; item: PWDiaCanvasItem); cdecl; external diacanvaslib;
function dia_canvas_groupable_pos(groupable: PWDiaCanvasGroupable; item: PWDiaCanvasItem): gint; cdecl; external diacanvaslib;

(* TODO: move to diacanvas C itself *)
function dia_canvas_root(canvas: PWDiaCanvas): PWDiaCanvasGroup; cdecl;

implementation


procedure DiaCheckRecords;
begin
  (*
  dia_shape_path_get_type
  dia_shape_bezier_get_type
  dia_shape_ellipse_get_type
  dia_shape_text_get_type
  dia_shape_image_get_type
  *)
end;

function dia_canvas_box_new: PWDiaCanvasItem;
begin
  Result := dia_canvas_item_create(dia_canvas_box_get_type, nil); (* normal _new + request_update *)
end;

function dia_canvas_group_new: PWDiaCanvasItem;
begin
  Result := dia_canvas_item_create(dia_canvas_group_get_type, nil); (* normal _new + request_update *)
end;

function dia_canvas_image_new: PWDiaCanvasItem;
begin
  Result := dia_canvas_item_create(dia_canvas_image_get_type, nil); (* normal _new + request_update *)
end;

function dia_canvas_line_new: PWDiaCanvasItem;
begin
  Result := dia_canvas_item_create(dia_canvas_line_get_type, nil); (* normal _new + request_update *)
end;

function dia_canvas_text_new: PWDiaCanvasItem;
begin
  Result := dia_canvas_item_create(dia_canvas_text_get_type, nil); (* normal _new + request_update *)
end;

function dia_canvas_root(canvas: PWDiaCanvas): PWDiaCanvasGroup; cdecl;
begin
  Result := canvas^.root;
end;

initialization
  DiaCheckRecords;

end.
