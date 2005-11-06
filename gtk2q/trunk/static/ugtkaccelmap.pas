unit ugtkaccelmap;

interface
uses iugtk, ugtypes, ugdktypes, ugtktypes, ugobject; //accelmap;

// FIXME make beautiful (derived from TGObject, with normal functions etc etc)

type
  TGtkAccelMap = class(TInterfacedObject, IGtkAccelMap, IInvokable, IInterface)
  protected
    Faccelmap: Pointer;
  public
    constructor CreateWrapped(accelmap: Pointer);
    
  class procedure Save(filename: string); // extra: fd
  class procedure Load(filename: string); // extra: fd, scanner
  
  class procedure AddEntry(const accelpath: UTF8String; const accelkey: TGdkAccelKey; 
    const accelmods: TGdkModifierType);
    
  class procedure AddFilter(const pattern: UTF8String); // see gpatternspec
  
  class function ChangeEntry(const accelpath: UTF8String; const accelkey: guint; 
    accelmods: TGdkModifierType; replace: Boolean = True): Boolean;
    
  class function LookupEntry(const accelpath: UTF8String; out accelkey: TGdkAccelKey; 
    out accelmods: TGdkModifierType): Boolean;
    
  class procedure Foreach(func: TGtkAccelMapForeach); (* TODO user data *)
  class procedure ForeachUnfiltered(func: TGtkAccelMapForeach); (* TODO user data *)
  // TODO OnChanged
  
  class function Get: IGtkAccelMap;

  class procedure LockPath(const accelpath: UTF8String);
  class procedure UnlockPath(const accelpath: UTF8String);
  end;

implementation
uses uwrapgnames, uwrapgtknames, uwrapgdknames;

{$INCLUDE clinksettings.inc}

{$ifdef gtk2q_standalone}
procedure gtk_accel_map_load(filename: PGChar); cdecl; external gtklib;
//load_fd, load_scanner
procedure gtk_accel_map_save(filename: PGChar); cdecl; external gtklib;
procedure gtk_accel_map_add_entry(const accelpath: PGChar; accelkey: guint; 
   accelmods: WGdkModifierType); cdecl; external gtklib;
   
procedure gtk_accel_map_add_filter(const filterpattern: PGChar); cdecl; external gtklib;
function gtk_accel_map_change_entry(const accelpath: PGChar; accelkey: guint; 
   accelmods: WGdkModifierType; replace: gboolean): gboolean; cdecl; external gtklib;
   
procedure gtk_accel_map_foreach(data: gpointer; foreachfunc: WGtkAccelMapForeach); cdecl; external gtklib;
procedure gtk_accel_map_foreach_unfiltered(data: gpointer; foreachfunc: WGtkAccelMapForeach); cdecl; external gtklib;
function gtk_accel_map_get(): PWGtkAccelMap; cdecl; external gtklib; // for global notifications
procedure gtk_accel_map_load_fd(fd: gint); cdecl; external gtklib;
//procedure gtk_accel_map_load_scanner(scanner: PGScanner); cdecl; external gtklib;
procedure gtk_accel_map_lock_path(const accelpath: PGChar); cdecl; external gtklib;
procedure gtk_accel_map_unlock_path(const accelpath: PGChar); cdecl; external gtklib;
function gtk_accel_map_lookup_entry(const accelpath: PGChar; keyoptional: PWGtkAccelKey{out}): gboolean; cdecl; external gtklib;
procedure gtk_accel_map_save_fd(fd: gint); cdecl; external gtklib;
                                                                                                
{$endif gtk2q_standalone}

// TGtkAccelMap

class procedure TGtkAccelMap.Load(filename: string);
begin
  gtk_accel_map_load(PGChar(filename));
end;

class procedure TGtkAccelMap.Save(filename: string);
begin
  gtk_accel_map_save(PGChar(filename));
end;

class procedure TGtkAccelMap.AddEntry(const accelpath: UTF8String; const accelkey: TGdkKeyval; const accelmods: TGdkModifierType);
begin
  gtk_accel_map_add_entry(PGChar(PChar(accelpath)), guint(accelkey), WCastSetType(accelmods));
end;

class procedure TGtkAccelMap.AddFilter(const pattern: UTF8String); // see gpatternspec
begin
  gtk_accel_map_add_filter(PGChar(PChar(pattern)));
end;

class function TGtkAccelMap.ChangeEntry(const accelpath: UTF8String; const accelkey: TGdkKeyval; 
    accelmods: TGdkModifierType; replace: Boolean = True): Boolean;
begin
  Result := gtk_accel_map_change_entry(PGChar(PChar(accelpath)), accelkey, WCastSetType(accelmods), replace);
end;
    
class function TGtkAccelMap.LookupEntry(const accelpath: UTF8String; out accelkey: TGdkKeyval; out accelmods: TGdkModifierType): Boolean;
var
  ak: WGtkAccelKeyEntry;
begin
  Result := gtk_accel_map_lookup_entry (PGChar(PChar(accelpath)), @ak);
  if Result then begin
    accelkey := ak.accelkey;
    accelmods := TGdkModifierType(ak.accelmods);
    // accelflags ?
  end else begin
    accelkey := 0;
    accelmods := [];
  end;
end;
    
class procedure TGtkAccelMap.Foreach(func: TGtkAccelMapForeach); // TODO user data
begin
  gtk_accel_map_foreach(nil, func);
end;

class procedure TGtkAccelMap.ForeachUnfiltered(func: TGtkAccelMapForeach); // TODO user data
begin
  gtk_accel_map_foreach_unfiltered(nil, func);
end;

constructor TGtkAccelMap.CreateWrapped(accelmap: Pointer);
begin
  inherited Create;
  Faccelmap := accelmap;
end;

class function TGtkAccelMap.Get: IGtkAccelMap;
begin
  Result := TGtkAccelMap.CreateWrapped(gtk_accel_map_get());
end;

class procedure TGtkAccelMap.LockPath(const accelpath: UTF8String);
begin
  gtk_accel_map_lock_path(PGChar(PChar(accelpath)));
end;

class procedure TGtkAccelMap.UnlockPath(const accelpath: UTF8String);
begin
  gtk_accel_map_unlock_path(PGChar(PChar(accelpath)));
end;

end.
