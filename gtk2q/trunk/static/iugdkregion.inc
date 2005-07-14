

(*$IFDEF define_consts*)

(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  
  IGdkRegion = interface(IPointerMediator) (* + ICloneable *)
    ['{5B545EC4-FECF-458D-AF07-2E0026FF7B63}']

     function Empty(): Boolean;
    //class function Rectangle(const rectangle: TGdkRectangle): IGdkRegion;
     function RectIn(const rect: TGdkRectangle): TGdkOverlapType;
     function Equal(region2: IGdkRegion): Boolean;
     function PointIn(x: Integer;y: Integer): Boolean;
    //class function Polygon(points: TGdkPointArray;fill_rule: TGdkFillRule): IGdkRegion;
    //class function RectangleIntersect(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle): Boolean;
     procedure Intersect(source2: IGdkRegion);
     procedure Xor1(source2: IGdkRegion);
     procedure Shrink(dx: Integer;dy: Integer);
    //class procedure RectangleUnion(const src1: TGdkRectangle;const src2: TGdkRectangle;out dest: TGdkRectangle);
     procedure Offset(dx: Integer;dy: Integer);
     procedure Subtract(source2: IGdkRegion);
     procedure UnionWithRect(const rect: TGdkRectangle);
     procedure SpansIntersectForeach(spans: TGdkSpanArray;sorted: Boolean;function1: TGdkSpanFunc;userdata: Pointer);
     procedure Union(source2: IGdkRegion);
     function GetClipbox: TGdkRectangle;
  end;
(*$ENDIF define_types*)

