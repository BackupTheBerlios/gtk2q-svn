unit ugnomecanvaspathdef;

interface
uses iugnomecanvas, iupointermediator, upointermediator, iug, uarttypes, classes;

(*
 * GnomeCanvasPathDef
 *
 * (C) 1999-2000 Lauris Kaplinski <lauris@ximian.com>
 * Released under LGPL
 *
 * This is mostly like GnomeCanvasBpathDef, but with added functionality:
 * - can be constructed from scratch, from existing bpath of from static bpath
 * - Path is always terminated with ART_END
 * - Has closed flag
 * - has concat, split and copy methods
 *
 *)


type
  TGnomeCanvasPathDef = class(DPointerMediator, IGnomeCanvasPathDef, IPointerMediator, ICloneable, IInvokable, IInterface)
  public
    constructor CreateWrapped(ptr: Pointer);
    constructor CreateFromArtBPath(const bpath: TArtBPath);
    constructor CreateFromOpenParts(def: IGnomeCanvasPathDef);
    constructor CreateFromClosedParts(def: IGnomeCanvasPathDef);
    constructor CreateAllClosed(def: IGnomeCanvasPathDef);
    constructor CreateConcat(const list: IInterfaceList{IGnomeCanvasPathDef});
  published

    (* end constructors *)

    procedure Finish;

    function Split: IInterfaceList;
    
    (*EnsureSpace? *)
    
    (* methods *)

    procedure Reset;
    procedure MoveTo(x,y: Double);
    procedure LineTo(x,y: Double);
    
    (* Does not create new ArtBpath, but simply changes last lineto position *)
    procedure LineToMoving(x,y: Double);
    procedure CurveTo(x0,y0,x1,y1,x2,y2: Double);
    procedure ClosePath;

    function Clone: ICloneable;

    (* Does not draw new line to startpoint, but moves last lineto *)
    procedure ClosePathCurrent;
    
    (* GetBPath ? (s) *)
    function Count: Integer;
    function IsEmpty: Boolean;
    function HasCurrentPoint: Boolean;
    procedure SetCurrentPoint(const point: TArtPoint);
    
    (* def_first_bpath, def_last_bpath O_o *)    

  protected
    function GetAreAnyOpen: Boolean;
    function GetAreAllOpen: Boolean;
    function GetAreAnyClosed: Boolean;
    function GetAreAllClosed: Boolean;

  published
    property AreAnyOpen: Boolean read GetAreAnyOpen stored False;
    property AreAllOpen: Boolean read GetAreAllOpen stored False;
    property AreAnyClosed: Boolean read GetAreAnyClosed stored False;
    property AreAllClosed: Boolean read GetAreAllClosed stored False;
  end;

implementation
uses uwrapgnames, uwrapartnames, uwrapgnomecanvasnames, ugtypes;

(*$IFDEF gtk2q_standalone*)
(* Constructors *)

function gnome_canvas_path_def_new: PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_new_sized(len1: gint): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_new_from_bpath(bpath: PWArtBpath): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_new_from_static_bpath(bpath: PWArtBpath): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_new_from_foreign_bpath(bpath: PWArtBpath): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;

procedure gnome_canvas_path_def_ref(pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_finish(pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_ensure_space(pathdef: PWGnomeCanvasPathDef; space: gint); cdecl; external gnomecanvaslib;

(*
 * Misc constructors
 * All these return NEW path, not unrefing old
 * Also copy and duplicate force bpath to be private (otherwise you
 * would use ref :)
 *)

procedure gnome_canvas_path_def_copy (dest: PWGnomeCanvasPathDef; const src: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_duplicate (const pathdef: PWGnomeCanvasPathDef): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_concat (const aglist: PGSList): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_split (const pathdef: PWGnomeCanvasPathDef): PGSList; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_open_parts (const pathdef: PWGnomeCanvasPathDef): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_closed_parts (const pathdef: PWGnomeCanvasPathDef): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_close_all (const pathdef: PWGnomeCanvasPathDef): PWGnomeCanvasPathDef; cdecl; external gnomecanvaslib;

(* Destructor *)

procedure gnome_canvas_path_def_unref (pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;

(* Methods *)

(* Sets GnomeCanvasPathDef to zero length *)

procedure gnome_canvas_path_def_reset (pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;

(* Drawing methods *)

procedure gnome_canvas_path_def_moveto(pathdef: PWGnomeCanvasPathDef; x, y: gdouble); cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_lineto(pathdef: PWGnomeCanvasPathDef; x, y: gdouble); cdecl; external gnomecanvaslib;

(* Does not create new ArtBpath, but simply changes last lineto position *)

procedure gnome_canvas_path_def_lineto_moving(pathdef: PWGnomeCanvasPathDef; x,y: gdouble); cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_curveto(pathdef: PWGnomeCanvasPathDef; x0, y0, x1, y1, x2, y2: gdouble); cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_closepath(pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;

(* Does not draw new line to startpoint, but moves last lineto *)

procedure gnome_canvas_path_def_closepath_current(pathdef: PWGnomeCanvasPathDef); cdecl; external gnomecanvaslib;

(* Various methods *)

function gnome_canvas_path_def_bpath (const pathdef: PWGnomeCanvasPathDef): PWArtBpath; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_length (const pathdef: PWGnomeCanvasPathDef): gint; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_is_empty (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_has_currentpoint (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
procedure gnome_canvas_path_def_currentpoint (const pathdef: PWGnomeCanvasPathDef; p: PWArtPoint); cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_last_bpath (const pathdef: PWGnomeCanvasPathDef): PWArtBpath; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_first_bpath (const pathdef: PWGnomeCanvasPathDef): PWArtBpath; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_any_open (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_all_open (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_any_closed (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
function gnome_canvas_path_def_all_closed (const pathdef: PWGnomeCanvasPathDef): gboolean; cdecl; external gnomecanvaslib;
(*$ENDIF gtk2q_standalone*)

procedure TGnomeCanvasPathDef.ClosePath;
begin
  gnome_canvas_path_def_closepath(GetUnderlying);
end;

procedure TGnomeCanvasPathDef.ClosePathCurrent;
begin
  gnome_canvas_path_def_closepath_current(GetUnderlying);
end;

function TGnomeCanvasPathDef.Count: Integer;
begin
  Result := gnome_canvas_path_def_length(GetUnderlying);
end;

constructor TGnomeCanvasPathDef.CreateAllClosed(def: IGnomeCanvasPathDef);
begin
  CreateWrapped(gnome_canvas_path_def_close_all(def.GetUnderlying));
end;

constructor TGnomeCanvasPathDef.CreateFromArtBPath(
  const bpath: TArtBPath);
var
  pbpath: PWArtBPath;
begin
  assert(sizeof(TArtBPath) >= sizeof(WArtBPath));
  pbpath := PWArtBPath(@bpath);
  CreateWrapped(gnome_canvas_path_def_new_from_foreign_bpath(pbpath));
end;

constructor TGnomeCanvasPathDef.CreateConcat(const list: IInterfaceList);
var
  aglist: PGSList;
  i: Integer;
  cobj: Pointer;
begin
  aglist := nil;

  for i := 0 to list.Count - 1 do begin
    cobj := ((list[i] as IGnomeCanvasPathDef) as IPointerMediator).GetUnderlying;
    aglist := g_slist_append(aglist, cobj);
  end;

  try
    CreateWrapped(gnome_canvas_path_def_concat(aglist));
  finally
    g_slist_free(aglist);
  end;
end;

constructor TGnomeCanvasPathDef.CreateFromClosedParts(
  def: IGnomeCanvasPathDef);
begin
  CreateWrapped(gnome_canvas_path_def_closed_parts(def.GetUnderlying));
end;

constructor TGnomeCanvasPathDef.CreateFromOpenParts(
  def: IGnomeCanvasPathDef);
begin
  CreateWrapped(gnome_canvas_path_def_open_parts(def.GetUnderlying));
end;

constructor TGnomeCanvasPathDef.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, @gnome_canvas_path_def_unref);
end;

procedure TGnomeCanvasPathDef.CurveTo(x0, y0, x1, y1, x2, y2: Double);
begin
  gnome_canvas_path_def_curveto(GetUnderlying, x0, y0, x1, y1, x2, y2);
end;

procedure TGnomeCanvasPathDef.Finish;
begin
  gnome_canvas_path_def_finish(GetUnderlying);
end;

function TGnomeCanvasPathDef.GetAreAllClosed: Boolean;
begin
  Result := gnome_canvas_path_def_all_closed(GetUnderlying);
end;

function TGnomeCanvasPathDef.GetAreAllOpen: Boolean;
begin
  Result := gnome_canvas_path_def_all_open(GetUnderlying);
end;

function TGnomeCanvasPathDef.GetAreAnyClosed: Boolean;
begin
  Result := gnome_canvas_path_def_any_closed(GetUnderlying);
end;

function TGnomeCanvasPathDef.GetAreAnyOpen: Boolean;
begin
  Result := gnome_canvas_path_def_any_open(GetUnderlying);
end;

function TGnomeCanvasPathDef.HasCurrentPoint: Boolean;
begin
  Result := gnome_canvas_path_def_has_currentpoint(GetUnderlying);
end;

function TGnomeCanvasPathDef.IsEmpty: Boolean;
begin
  Result := gnome_canvas_path_def_is_empty(GetUnderlying);
end;

procedure TGnomeCanvasPathDef.LineTo(x, y: Double);
begin
  gnome_canvas_path_def_lineto(GetUnderlying, x, y);
end;

procedure TGnomeCanvasPathDef.LineToMoving(x, y: Double);
begin
  gnome_canvas_path_def_lineto_moving(GetUnderlying, x, y);
end;

procedure TGnomeCanvasPathDef.MoveTo(x, y: Double);
begin
  gnome_canvas_path_def_moveto(GetUnderlying, x, y);
end;

procedure TGnomeCanvasPathDef.Reset;
begin
  gnome_canvas_path_def_reset(GetUnderlying);
end;

procedure TGnomeCanvasPathDef.SetCurrentPoint(const point: TArtPoint);
var
  p: PWArtPoint;
begin
  p := PWArtPoint(@point);
  assert(sizeof(p^) <= sizeof(point));
  gnome_canvas_path_def_currentpoint(GetUnderlying, p);
end;

function TGnomeCanvasPathDef.Split: IInterfaceList;
var
  aglist: PGSList;
  xaglist: PGSList;
begin
  Result := TInterfaceList.Create;
  Result.Count := 0;
  aglist := gnome_canvas_path_def_split(GetUnderlying);
  if not Assigned(aglist) then
    Exit;

  xaglist := aglist;
  while Assigned(xaglist) do begin
    Result.Add(TGnomeCanvasPathDef.CreateWrapped(xaglist^.data));
    xaglist := g_slist_next(xaglist);
  end;
  g_slist_free(aglist);
end;

function TGnomeCanvasPathDef.Clone: ICloneable;
begin
  Result := TGnomeCanvasPathDef.CreateWrapped(gnome_canvas_path_def_duplicate(GetUnderlying));
end;

end.

