unit ugvalue;

// standalone only

interface
uses ugtypes;

{$INCLUDE clinksettings.inc}

type
   PWGValue = ^WGValue;
   WGValue = record
        g_type : TGType;
        data0 : record
            case longint of
               0 : ( v_int : gint );
               1 : ( v_uint : guint );
               2 : ( v_long : glong );
               3 : ( v_ulong : gulong );
               4 : ( v_int64 : gint64 );
               5 : ( v_uint64 : guint64 );
               6 : ( v_float : gfloat );
               7 : ( v_double : gdouble );
               8 : ( v_pointer : pointer );
            end;
        data1 : record
            case longint of
               0 : ( v_int : gint );
               1 : ( v_uint : guint );
               2 : ( v_long : glong );
               3 : ( v_ulong : gulong );
               4 : ( v_int64 : gint64 );
               5 : ( v_uint64 : guint64 );
               6 : ( v_float : gfloat );
               7 : ( v_double : gdouble );
               8 : ( v_pointer : pointer );
            end;
     end;


implementation

initialization

(* sizeof(TGValue): *)
(* win32: 24 *)
(* linux/i386: 20 *)
(* linux/ppc: ? *)
(* linux/x86_64: ? *)

end.
