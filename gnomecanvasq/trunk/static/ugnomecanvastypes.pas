unit ugnomecanvastypes;

interface

const
  // WGnomeCanvasItemObjectFlags
  cifRealized = 1 shl 4;
  cifMapped = 1 shl 5;
  cifAlwaysRedraw = 1 shl 6;
  cifVisible = 1 shl 7;
  cifNeedUpdate = 1 shl 8;
  cifNeedAffine = 1 shl 9;
  cifNeedClip = 1 shl 10;
  cifNeedVis = 1 shl 11;
  cifAffineFull = 1 shl 12;
                                                                          
  // WGnomeCanvasItemUpdateFlags
  cufRequested = 1 shl 0;
  cufAffine = 1 shl 1;
  cufClip = 1 shl 2;
  cufVisibility = 1 shl 3;
  (*cufIsVisible = 1 shl 4; deprecated *)

type
  (*TAffineTransformArrayIndex = (one,two,three,four,five);*)
  TAffineTransform = array[0..5] of Double;


implementation

end.
