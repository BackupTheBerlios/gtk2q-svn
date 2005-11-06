unit uglog;

interface

type
  DGLogLevelFlags = Integer;
  DGLogLevelFlag = Integer;

const 
  llFlagRecursion = 1 shl 0;
  llFlagFatal = 1 shl 1;

  llError = 1 shl 2;
  llCritical = 1 shl 3;
  llWarning = 1 shl 4;
  llMessage = 1 shl 5;
  llInfo = 1 shl 6;
  llDebug = 1 shl 7;

  llMask = 255 and not (llFlagRecursion or llFlagFatal);

procedure InstallLogHandler;

implementation
uses uwrapgnames, ugtypes;

{$INCLUDE clinksettings.inc}

type
  TGLogLevelFlags = gint;
  TGLogFunc = procedure(domain: PGChar; level: TGLogLevelFlags; message: PGChar; userdata: gpointer); cdecl;

{$ifdef gtk2q_standalone}
function g_log_set_handler(const domain: PGChar; levels: DGLogLevelFlags; logfunc: TGLogFunc; userdata: gpointer): guint; cdecl; external glib;
procedure g_log_remove_handler(const domain: PGChar; handler_id: guint); cdecl; external glib;
procedure g_log_default_handler(domain: PGChar; levels: DGLogLevelFlags; message: PGChar; unuseddata: gpointer); cdecl; external glib;
procedure g_log(domain: PGChar; level: DGLogLevelFlag; format: PGChar; args: array of const); cdecl; external glib;
procedure g_log_set_fatal_mask(domain: PGChar; fatalmask: DGLogLevelFlags); cdecl; external glib;
function g_log_set_always_fatal(fatalmask: DGLogLevelFlags): DGLogLevelFlags; cdecl; external glib;
{$endif gtk2q_standalone}

(* this stuff is only meant as a 'help' in tracking down problems *)
var
  LastFiveLines: array of UTF8String;
  LastFiveDomains: array of UTF8String;
  LastFiveLevels: array of DGLogLevelFlags;
  (*LastFiveUserMarkers: array of set of marker;*)

procedure MyLogFunc(domain: PGChar; level: TGLogLevelFlags; message: PGChar; userdata: gpointer); cdecl;
var
  i: Integer;
begin
  if Length(LastFiveLines) > 5 then begin
    LastFiveLines := Copy(LastFiveLines, Length(LastFiveLines) - 5, 5);
    LastFiveDomains := Copy(LastFiveDomains, Length(LastFiveDomains) - 5, 5);
    LastFiveLevels := Copy(LastFiveLevels, Length(LastFiveLevels) - 5, 5);
  end;  
  SetLength(LastFiveLines, Length(LastFiveLines) + 1);
  SetLength(LastFiveDomains, Length(LastFiveDomains) + 1);
  SetLength(LastFiveLevels, Length(LastFiveLevels) + 1);
  
  LastFiveLines[High(LastFiveLines)] := PChar(message);
  LastFiveDomains[High(LastFiveDomains)] := PChar(domain);
  LastFiveLevels[High(LastFiveLevels)] := DGLogLevelFlags(level);
end;

procedure InstallLogHandler;
begin
  g_log_set_handler(nil, llMask, @MyLogFunc, nil);
end;

initialization

finalization

end.
