unit ugtimer;

(* still unused *)

interface

uses iugtimer, upointermediator, iupointermediator;

type
  TGTimer = class(TPointerMediator, IGTimer, IPointerMediator, IInterface)
  public
    constructor Create; reintroduce;
    constructor CreateWrapped(ptr: Pointer);

    procedure Start;
    
    procedure Stop;
    procedure Continue; (* 2.4 *)
    
    function GetElapsed: Double;
    function GetElapsedMicroseconds: Cardinal;
    
    procedure Reset;
  end;

implementation
uses uwrapgnames, ugtypes;

(*$IFDEF gtk2q_standalone*)
function g_timer_new: PGTimer; cdecl; external glib;
procedure g_timer_start(timer: PGTimer); cdecl; external glib;
procedure g_timer_stop(timer: PGTimer); cdecl; external glib;
procedure g_timer_continue(timer: PGTimer); cdecl; external glib;
function g_timer_elapsed(timer: PGTimer; microseconds: Pgulong): gdouble; cdecl; external glib;
procedure g_timer_reset(timer: PGTimer); cdecl; external glib;
procedure g_timer_destroy(timer: PGTimer); cdecl; external glib;
(*$ENDIF gtk2q_standalone*)

constructor TGTimer.Create;
begin
  inherited Create(g_timer_new, g_timer_destroy);
end;

procedure TGTimer.Start;
begin
  g_timer_start(GetUnderlying);
end;
    
procedure TGTimer.Stop;
begin
  g_timer_stop(GetUnderlying);
end;

procedure TGTimer.Continue;
begin
  g_timer_continue(GetUnderlying);
end;
     
function TGTimer.GetElapsed: Double;
begin
  Result := g_timer_elapsed(GetUnderlying, nil);
end;

function TGTimer.GetElapsedMicroseconds: Cardinal;
var
  u: gulong;
begin
  (* fractional part of seconds elapsed, in microseconds
    (that is, the total number of microseconds elapsed, modulo 1000000)
  *)
  g_timer_elapsed(GetUnderlying, @u);
  Result := u;
end;
    
procedure TGTimer.Reset;
begin
  g_timer_reset(GetUnderlying);
end;

constructor TGTimer.CreateWrapped(ptr: Pointer);
begin
  inherited Create(ptr, g_timer_destroy);
end;

end.
