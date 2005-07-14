unit uwrapartnames;

interface
uses ugtypes, uwrapgnames;

{$INCLUDE static/clinksettings.inc}

type
  WArtPathcode = gint;
  PWArtVpath = ^WArtVpath;
  (* curveto is not allowed *)
  WArtVpath = record (* C *)
    code: WArtPathcode;
    x,y: gdouble; (* actually double *)
  end;

  (*Pgdouble = ^gdouble; -> uwrapgnames *)
  PWArtVpathDash = ^WArtVPathDash;
  WArtVpathDash = record (* C *)
    offset: gdouble; (* actually double *)
    nDash: gint; (* actually int *)
    dash: Pgdouble; (* actually Pdouble *)
  end;
  PWArtBPath = ^WArtBPath;
  WArtBPath = record (* C *)
    Code: gint; (* actually int *)
    x1,y1,x2,y2,x3,y3: gdouble; (* actually double *)
  end;
  WArtWindRule = gint;
  WArtIRect = record (* C *)
    x0,y0,x1,y1: gint; (* actually int *)
  end;
  PWArtDRect = ^WArtDRect;
  WArtDRect = record (* C *)
    x0,y0,x1,y1: gdouble; (* actually double *)
  end;
  PWArtPoint = ^WArtPoint;
  WArtPoint = record (* C *)
    x,y: gdouble; (* actually double *)
  end;
  
  WGnomeCanvasItemObjectFlags = gint;
  WGnomeCanvasItemUpdateFlags = gint;

  PWArtSVPSeg = ^WArtSVPSeg;
  WArtSVPSeg = record (* C *)
    nPoints: gint; (* actually int *)
    dir: gint; (* actually int; 0 for "up", 1 for "down" *)
    bbox: WArtDRect;
    points: PWArtPoint;
  end;

  PWArtSVP = ^WArtSVP;
  WArtSVP = record (* C *)
    nSegs: gint; (* actually int *)
    segs: PWArtSVPSeg; (* array *)
  end;

  PWArtUtaBbox = ^WArtUtaBbox;
  art_u32 = guint32;
  WArtUtaBbox = art_u32; (* actually art_u32 *)

  PWArtUta = ^WArtUta;
  WArtUta = record (* C *)
    x0,y0: gint; (* actually int *)
    width, height: gint; (* actually int *)
    utiles: PWArtUtaBbox;
  end;

const
(*$IFDEF WIN32*)
  artlib = 'libart_lgpl_2-2.dll';
(*$ELSE*)
  artlib = 'libart_lgpl_2.so.2';
(*$ENDIF WIN32*)

implementation

(*
ArtVpath *art_vpath_dash (const ArtVpath *vpath, const ArtVpathDash *dash);
*)

end.
