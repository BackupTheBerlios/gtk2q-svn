unit iugtimer;

(* still unused *)

interface

type
  IGTimer = interface
    procedure Start; (* sets elapse start mark, can be called over and over again *)
    
    procedure Stop;
    procedure Continue;
    
    function GetElapsed: Double;

  (* fractional part of seconds elapsed, in microseconds 
    (that is, the total number of microseconds elapsed, modulo 1000000)
  *)
    function GetElapsedMicroseconds: Cardinal;
    
    (*procedure Reset;*)
  end;

implementation

end.
