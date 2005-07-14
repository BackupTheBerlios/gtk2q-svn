unit ugdkregion;



interface
uses sysutils,ugtypes,uvarrectools
,iugdk,iugobject,ugobject, ugdktypes, upointermediator, iupointermediator
, iug;


type
  TGdkRegion = class(DPointerMediator,IGdkRegion,IPointerMediator,ICloneable,IInvokable,IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);

     function Clone: ICloneable;
     function Empty(): Boolean;
    class function CreateFromRectangle(const rectangle: TGdkRectangle): IGdkRegion;
     function RectIn(const rect: TGdkRectangle): TGdkOverlapType;
     function Equal(region2: IGdkRegion): Boolean;
     function PointIn(x: Integer;y: Integer): Boolean;
    class function CreateFromPolygon(points: TGdkPointArray;fill_rule: TGdkFillRule): IGdkRegion;
    class function RectangleIntersect(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle): Boolean;
     procedure Intersect(source2: IGdkRegion);
     procedure Xor1(source2: IGdkRegion);
     procedure Shrink(dx: Integer;dy: Integer);
    class procedure RectangleUnion(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle);
     procedure Offset(dx: Integer;dy: Integer);
     procedure Subtract(source2: IGdkRegion);
     procedure UnionWithRect(const rect: TGdkRectangle);
     procedure SpansIntersectForeach(spans: TGdkSpanArray;sorted: Boolean;function1: TGdkSpanFunc;userdata: Pointer);
     procedure Union(source2: IGdkRegion);
     function GetClipbox: TGdkRectangle;
     //procedure Destroy1();

  protected
  public
  published
  public
    
    
  end;

implementation
uses uwrapgnames, uwrapgdknames;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}
function gdk_region_new:PWGdkRegion; cdecl; external gdklib;
function gdk_region_polygon(points:WGdkPointArray; npoints:gint; fill_rule:WGdkFillRule):PWGdkRegion; cdecl; external gdklib;
function gdk_region_copy(region:PWGdkRegion):PWGdkRegion; cdecl; external gdklib;
function gdk_region_rectangle(rectangle:PWGdkRectangle):PWGdkRegion; cdecl; external gdklib;
procedure gdk_region_destroy(region:PWGdkRegion); cdecl; external gdklib;
procedure gdk_region_get_clipbox(region:PWGdkRegion; rectangle:PWGdkRectangle); cdecl; external gdklib;
procedure gdk_region_get_rectangles(region:PWGdkRegion; var rectangles:PWGdkRectangle; n_rectangles:PWgint); cdecl; external gdklib;
function gdk_region_empty(region:PWGdkRegion):gboolean; cdecl; external gdklib;
function gdk_region_equal(region1:PWGdkRegion; region2:PWGdkRegion):gboolean; cdecl; external gdklib;
function gdk_region_point_in(region:PWGdkRegion; x:longint; y:longint):gboolean; cdecl; external gdklib;
function gdk_region_rect_in(region:PWGdkRegion; rect:PWGdkRectangle):WGdkOverlapType; cdecl; external gdklib;
procedure gdk_region_offset(region:PWGdkRegion; dx:gint; dy:gint); cdecl; external gdklib;
procedure gdk_region_shrink(region:PWGdkRegion; dx:gint; dy:gint); cdecl; external gdklib;
procedure gdk_region_union_with_rect(region:PWGdkRegion; rect:PWGdkRectangle); cdecl; external gdklib;
procedure gdk_region_intersect(source1:PWGdkRegion; source2:PWGdkRegion); cdecl; external gdklib;
procedure gdk_region_union(source1:PWGdkRegion; source2:PWGdkRegion); cdecl; external gdklib;
procedure gdk_region_subtract(source1:PWGdkRegion; source2:PWGdkRegion); cdecl; external gdklib;
procedure gdk_region_xor(source1:PWGdkRegion; source2:PWGdkRegion); cdecl; external gdklib;
procedure gdk_region_spans_intersect_foreach(region:PWGdkRegion; spans:WGdkSpanArray; n_spans:longint; sorted:gboolean; _function:WGdkSpanFunc;
            data:gpointer); cdecl; external gdklib;

function gdk_rectangle_intersect(src1,src2,dest: PWGdkRectangle): gboolean; cdecl; external gdklib;
procedure gdk_rectangle_union(src1,src2,dest: PWGdkRectangle); cdecl; external gdklib;
{$endif gtk2q_standalone}

constructor TGdkRegion.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gdk_region_destroy) (*as IGdkRegion*);
end;

function TGdkRegion.Clone: ICloneable;
begin // withoutgerror
  Result := (*$IFDEF FPC*)TGdkRegion.(*$ENDIF FPC*)CreateWrapped(gdk_region_copy(PWGdkRegion(GetUnderlying)));
end;
 function TGdkRegion.Empty(): Boolean;
begin // withoutgerror
  Result := Boolean(gdk_region_empty(PWGdkRegion(GetUnderlying)));
end;
class function TGdkRegion.CreateFromRectangle(const rectangle: TGdkRectangle): IGdkRegion;
begin // withoutgerror
  Result := CreateWrapped(gdk_region_rectangle(PWGdkRectangle(@rectangle)));
end;
 function TGdkRegion.RectIn(const rect: TGdkRectangle): TGdkOverlapType;
begin // withoutgerror
  Result := TGdkOverlapType(gdk_region_rect_in(PWGdkRegion(GetUnderlying),PWGdkRectangle(@rect)));
end;
 function TGdkRegion.Equal(region2: IGdkRegion): Boolean;
begin // withoutgerror
  Result := Boolean(gdk_region_equal(PWGdkRegion(GetUnderlying),region2.GetUnderlying));
end;
 function TGdkRegion.PointIn(x: Integer;y: Integer): Boolean;
begin // withoutgerror
  Result := Boolean(gdk_region_point_in(PWGdkRegion(GetUnderlying),Integer(x),Integer(y)));
end;
class function TGdkRegion.CreateFromPolygon(points: TGdkPointArray;fill_rule: TGdkFillRule): IGdkRegion;
begin // withoutgerror
  Result := CreateWrapped(gdk_region_polygon(WGdkPointArray(points),Length(points),WGdkFillRule(fill_rule)));
end;
class function TGdkRegion.RectangleIntersect(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle): Boolean;
begin // withoutgerror
  Result := Boolean(gdk_rectangle_intersect(PWGdkRectangle(@src1),PWGdkRectangle(@src2),PWGdkRectangle(@dest)));
end;
 procedure TGdkRegion.Intersect(source2: IGdkRegion);
begin // withouterror
  gdk_region_intersect(PWGdkRegion(GetUnderlying),source2.GetUnderlying);
end;
 procedure TGdkRegion.Xor1(source2: IGdkRegion);
begin // withouterror
  gdk_region_xor(PWGdkRegion(GetUnderlying),source2.GetUnderlying);
end;
 procedure TGdkRegion.Shrink(dx: Integer;dy: Integer);
begin // withouterror
  gdk_region_shrink(PWGdkRegion(GetUnderlying),Integer(dx),Integer(dy));
end;
class procedure TGdkRegion.RectangleUnion(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle);
begin // withouterror
  gdk_rectangle_union(PWGdkRectangle(@src1),PWGdkRectangle(@src2),PWGdkRectangle(@dest));
end;
 procedure TGdkRegion.Offset(dx: Integer;dy: Integer);
begin // withouterror
  gdk_region_offset(PWGdkRegion(GetUnderlying),Integer(dx),Integer(dy));
end;
 procedure TGdkRegion.Subtract(source2: IGdkRegion);
begin // withouterror
  gdk_region_subtract(PWGdkRegion(GetUnderlying),source2.GetUnderlying);
end;
 procedure TGdkRegion.UnionWithRect(const rect: TGdkRectangle);
begin // withouterror
  gdk_region_union_with_rect(PWGdkRegion(GetUnderlying),PWGdkRectangle(@rect));
end;
 procedure TGdkRegion.SpansIntersectForeach(spans: TGdkSpanArray;sorted: Boolean;function1: TGdkSpanFunc;userdata: Pointer);
begin // withouterror
  gdk_region_spans_intersect_foreach(PWGdkRegion(GetUnderlying),WGdkSpanArray(spans),Length(spans),gboolean(sorted),WGdkSpanFunc(@function1),gpointer(userdata));
end;
 procedure TGdkRegion.Union(source2: IGdkRegion);
begin // withouterror
  gdk_region_union(PWGdkRegion(GetUnderlying),source2.GetUnderlying);
end;
function TGdkRegion.GetClipbox(): TGdkRectangle;
begin // withouterror
  gdk_region_get_clipbox(PWGdkRegion(GetUnderlying),PWGdkRectangle(@Result));
end;
//  gdk_region_destroy(PWGdkRegion(Fobject));

initialization

end.

