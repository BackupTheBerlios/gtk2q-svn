program testgvalue;

{$APPTYPE CONSOLE}

uses
  SysUtils, ugvalue, unicegvalue, uwrapgnames, uapplication;

var
  val: TGValue;
  off: PChar;
  vc: PChar;
  s: UTF8String;
begin
  Application.Init;
  assert(sizeof(val) = 20);
  vc := PChar(@val);
  off := PChar(@val.g_type); assert(off-vc = 0);

  off := PChar(@val.data0.v_int); assert(off-vc = 4);
  off := PChar(@val.data0.v_uint); assert(off-vc = 4);
  off := PChar(@val.data0.v_long); assert(off-vc = 4);
  off := PChar(@val.data0.v_ulong); assert(off-vc = 4);
  off := PChar(@val.data0.v_int64); assert(off-vc = 4);
  off := PChar(@val.data0.v_uint64); assert(off-vc = 4);
  off := PChar(@val.data0.v_float); assert(off-vc = 4);
  off := PChar(@val.data0.v_double); assert(off-vc = 4);
  off := PChar(@val.data0.v_pointer); assert(off-vc = 4);

  off := PChar(@val.data1.v_int); assert(off-vc = 12);
  off := PChar(@val.data1.v_uint); assert(off-vc = 12);
  off := PChar(@val.data1.v_long); assert(off-vc = 12);
  off := PChar(@val.data1.v_ulong); assert(off-vc = 12);
  off := PChar(@val.data1.v_int64); assert(off-vc = 12);
  off := PChar(@val.data1.v_uint64); assert(off-vc = 12);
  off := PChar(@val.data1.v_float); assert(off-vc = 12);
  off := PChar(@val.data1.v_double); assert(off-vc = 12);
  off := PChar(@val.data1.v_pointer); assert(off-vc = 12);

  val := gValueInit(G_TYPE_STRING);

  gValueSetValue(val, 'hello');
 
  gValueGetValue(val, s);

  Writeln(s);
  Readln;
end.
