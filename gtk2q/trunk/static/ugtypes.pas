unit ugtypes;

interface

type
  gulong = Cardinal;
  GUniChar = Cardinal;
  TGType = GULong;
  glong = Longint; // ?
  TGTypeArray = array of TGType;
  guint32 = Cardinal;
  TGQuark = guint32;
  gint64 = Int64;
  guint64 = Int64; // FIXME
  guint16 = Word;
  guint = Cardinal;
  gint16 = Smallint;
  gint8 = Shortint;
  gboolean = LongBool; // FIXME!!
  guint8 = Byte;
  gshort = guint16;
  gfloat = Single;
  gdouble = Double;
  gint = Integer;
  guchar = Byte;
  gushort = gint; (* hmm *)
  TGInt8Array = array of GInt8;
  //TStringArray = array of String;
  TUTF8StringArray = array of UTF8String;
  TIntegerArray = array of Integer;

  DGParamSpecName = UTF8String;

  gsize = gulong;

   PGBoxed = Pointer;
   PGParamSpec = Pointer;
  DGDestroyNotify = procedure(object1: Pointer); stdcall;


// this is mine:

type
  DParamFlags = set of (pReadable, pWritable, pConstruct, pConstructOnly, pLaxValidation, pPrivate);

type
  DGTimeVal = record // FIXME support all the glib functions
    tv_sec: Longint;
    tv_usec: Longint;
  end;

var
  emptyUTF8StringArray: TUTF8StringArray;
  PasWrapperQuark: TGQuark = 0;

implementation

end.
