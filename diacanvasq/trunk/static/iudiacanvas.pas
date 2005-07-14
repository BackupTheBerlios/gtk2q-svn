unit iudiacanvas;

interface
uses iug, iugobject, udiacanvastypes, uarttypes,
ugnomecanvastypes, ugdktypes,
ugdkrgb,
iupointermediator, ugtypes, ugobject, upangotypes, iugnomecanvas,
iupango,iugdk,iuart, 
sdiacanvas, sdiacanvaseditable, sdiacanvasitem,
sdiacanvasgroupable, sdiaconstraint, sdiacanvasview,
sdiatool, sdiaundomanager, sdiavariable, iudiaundoaction,
sdiacanvasgroup, sdiacanvastext;

(* IDiaShape, IDiaShapeText *)

const
  GTK_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE static/diacanvasincludes.inc}
{$UNDEF define_consts}

type
  IDiaShapeText = interface;
  IDiaShape = interface;
  IDiaHandle = interface;
  IDiaCanvasItem = interface;
  TIDiaCanvasItemArray = array of IDiaCanvasItem;
  IDiaVariable = interface;
  IDiaCanvasViewItem = interface;
  IDiaTool = interface;
  //IDiaUndoAction = interface;
  
{$DEFINE define_types}
{$INCLUDE static/diacanvasincludes.inc}
{$UNDEF define_types}


implementation

{$DEFINE define_implementation}
{ $INCLUDE static/diacanvasincludes.inc}
{$UNDEF define_implementation}

end.
