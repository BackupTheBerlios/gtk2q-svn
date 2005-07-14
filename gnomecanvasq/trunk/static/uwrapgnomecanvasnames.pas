unit uwrapgnomecanvasnames;

interface
uses ugtypes, uwrapartnames, uwrapgnames;

{$INCLUDE static/clinksettings.inc}

type
  Pguchar = ^guchar;

  PWGnomeCanvasBuf = ^WGnomeCanvasBuf;
  WGnomeCanvasBuf = record
    buf: Pguchar; (* 24-bit rgb buffer for rendering *)
    rect: WArtIRect;
    bufRowstride: gint;
    bgColor: guint32;
    (* invariant: at least one of the following flags is true *)

    flags: Byte;
    (*
    isBg: bit 0  Set when the render rectangle area is the solid color bg_color
    isBuf: bit 1 Set when the render rectangle area is represented by the buf
    *)
  end;

type
  PWGnomeCanvasPathDef = Pointer; (* non-gobject *)
  PWGnomeCanvasPoints = ^WGnomeCanvasPoints; (* non-gobject *)
  WGnomeCanvasPoints = record (* C *)
    coords: Pgdouble; (* actually double *)
    numPoints: gint; (* actually int *)
    refCount: gint; (* actually refCount *)
  end;

const
(*$IFDEF WIN32*)
  gnomecanvaslib = 'libgnomecanvas-2-0.dll';
(*$ELSE*)
  gnomecanvaslib = 'libgnomecanvas-2.so';
(*$ENDIF WIN32*)

type
  PWGnomeCanvasItem = PGObject;
  PWGnomeCanvas = PGObject;
  PWGnomeCanvasGroup = PGObject;
  PWGnomeCanvasShape = PGObject;
  PWGnomeCanvasPolygon = PGObject;
  PWGnomeCanvasRichText = PGObject;
  PWGnomeCanvasText = PGObject;
  PWGnomeCanvasLine = PGObject;
  PWGnomeCanvasEllipse = PGObject;
  PWGnomeCanvasRect = PGObject;
  PWGnomeCanvasRE = PGObject;
  
  PPWGnomeCanvasItem = ^PWGnomeCanvasItem;
  Pint = ^gint; (* sigh *)

function gnome_canvas_item_new(parent: PWGnomeCanvasGroup;
  typ: GType; const firstArgName: PChar): PWGnomeCanvasItem; overload; cdecl; external gnomecanvaslib;
function gnome_canvas_item_new(parent: PWGnomeCanvasGroup;
  typ: GType; const firstArgName: PChar; opts: array of const): PWGnomeCanvasItem; overload; cdecl; external gnomecanvaslib;

function gnome_canvas_group_get_type: GType; cdecl; external gnomecanvaslib;

function gnome_canvas_group_new(parent: PWGnomeCanvasItem): PWGnomeCanvasGroup;

implementation

function gnome_canvas_group_new(parent: PWGnomeCanvasItem): PWGnomeCanvasGroup;
begin
  Result := gnome_canvas_item_new(parent, gnome_canvas_group_get_type, nil);
end;

end.
