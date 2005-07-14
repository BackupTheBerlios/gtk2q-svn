unit ugtkiconfactory;

interface
uses iugtkiconfactory, iugobject, ugobject, iugtk, iugtkstock, ugtkobject;

(* To display an icon, always use gtk_style_lookup_icon_set() on the widget 
   that will display the icon, or the convenience function 
   gtk_widget_render_icon(). These functions take the theme into account 
   when looking up the icon to use for a given stock ID. *)

type
  TGtkIconFactory = class(TGObject, IGtkIconFactory, IGObject, IInvokable, IInterface)
  protected 
    procedure constructWrapped; override;
  public
    class procedure TypeRegister; override;
  public
    procedure Add(stockid: TStockID; iconset: IGtkIconSet);

    function Lookup(stockid: TStockID): IGtkIconSet;

    // split this up into a second object ? hmm
    procedure AddDefault; // Add self as default factory for gtk_style_lookup_icon_set
    procedure RemoveDefault; // Remove self from default factory list
    class function LookupDefault(stockid: TStockID): IGtkIconSet;    
  end;

implementation
uses uwrapgnames, uwrapgtknames, ugtypes, ugtkiconset, utyperegistry;

{$INCLUDE static/clinksettings.inc}

{$ifdef gtk2q_standalone}

procedure gtk_icon_factory_add(factory:PWGtkIconFactory; stockid: PGChar;
iconset: PWGtkIconSet); cdecl; external gtklib;

function gtk_icon_factory_get_type: TGType; cdecl; external gtklib;

procedure gtk_icon_factory_add_default(factory:PWGtkIconFactory); cdecl; external gtklib;

function gtk_icon_factory_lookup(factory:PWGtkIconFactory;
	stockid: PGChar): PWGtkIconSet; cdecl; external gtklib;
	
function gtk_icon_factory_lookup_default (const stockid: PGChar): PWGtkIconSet; cdecl; external gtklib;

function gtk_icon_factory_new: PWGtkIconFactory; cdecl; external gtklib;

procedure gtk_icon_factory_remove_default (factory: PWGtkIconFactory); cdecl; external gtklib;

{$endif gtk2q_standalone}

{ TGtkIconFactory }

procedure TGtkIconFactory.constructWrapped;
begin
  setWrapped(PWGObject(gtk_icon_factory_new()));
end;

class procedure TGtkIconFactory.TypeRegister;
begin
  inherited TypeRegister;
  DTypeRegister('TGtkIconFactory', 'gtk', TGtkIconFactory, gtk_icon_factory_get_type(), IGtkIconFactory);
end;

procedure TGtkIconFactory.Add(stockid: TStockID; iconset: IGtkIconSet);
begin
  assert(Assigned(iconset));
  gtk_icon_factory_add(PWGtkIconFactory(Fobject), PGChar(PChar(stockid)), iconset.GetUnderlying);
end;

function TGtkIconFactory.Lookup(stockid: TStockID): IGtkIconSet;
var
  native: PWGtkIconSet;
begin
  native := gtk_icon_factory_lookup(PWGtkIconFactory(Fobject), PGChar(PChar(stockid)));
  if not Assigned(native) then begin
    Result := nil;
    Exit;
  end;
  
  Result := TGtkIconSet.CreateWrapped(native);
end;

procedure TGtkIconFactory.AddDefault; // Add self as default factory for gtk_style_lookup_icon_set
begin
  gtk_icon_factory_add_default(PWGtkIconFactory(Fobject));
end;

procedure TGtkIconFactory.RemoveDefault; // Remove self from default factory list
begin
  gtk_icon_factory_remove_default(PWGtkIconFactory(Fobject));
end;

class function TGtkIconFactory.LookupDefault(stockid: TStockID): IGtkIconSet;    
var
  native: PWGtkIconSet;
begin
  native := gtk_icon_factory_lookup_default(PGChar(PChar(stockid)));
  if not Assigned(native) then begin
    Result := nil;
    Exit;
  end;
  
  Result := TGtkIconSet.CreateWrapped(native);
end;

end.
