unit uarttypes;

interface
uses ugtypes;

(*$INCLUDE static/clinksettings.inc*)

type
  TArtPathcode = (apMoveTo, apMoveToOpen, apCurveTo, apLineTo, apEnd);

  TArtPoint = record (* C *)
    x,y: Double;
  end;
  
  TArtBPath = record (* C *)
    Code: TArtPathcode; (* fixme make sure that size is gint *)
    x1,y1,x2,y2,x3,y3: Double;
  end;

  TArtVpath = record (* C *)
    Code: TArtPathcode;
    x,y: Double;
  end;
  (* ArtBPath *art_bpath_affine_transform (const ArtBpath *src, const double matrix[6]); *)
  (* art_vpath_bpath.h:ArtVpath *art_bez_path_to_vec (const ArtBpath *bez, double flatness); *)
  (*GNOME_TYPE_CANVAS_BPATH *)

  TArtIRect = record (* C *)
    x0,y0,x1,y1: gint; (* actually int *)
  end;

  TArtUtaBbox = guint32; (* hmm *)

implementation

end.
