unit uginit;

(* NEW *)
(* this will initialize PasWrapperQuark *)

interface
uses ugtypes;

procedure InstallQuarks;

implementation
uses uwrapgnames;

var
  PasWrapperQuarkString: UTF8String = 'p-wrapper'; // DO NOT TOUCH

procedure InstallQuarks;
begin
  PasWrapperQuark := g_quark_from_static_string(PGChar(PChar(PasWrapperQuarkString))); // sigh
end;

initialization
  InstallQuarks;
  
end.
