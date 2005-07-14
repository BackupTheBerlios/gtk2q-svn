unit iugtkiconfactory;

interface
uses iugobject, iugtkstock, iugtk;

type
  // TODO exception for not found ?
  IGtkIconFactory = interface(IGObject)
    ['{D6715F13-F94B-4BAC-8945-CB6CC683FB10}']
    procedure Add(stockid: TStockID; iconset: IGtkIconSet);

    function Lookup(stockid: TStockID): IGtkIconSet;

    // split this up into a second object ? hmm
    procedure AddDefault; // Add self as default factory for gtk_style_lookup_icon_set
    procedure RemoveDefault; // Remove self from default factory list
    //class function LookupDefault(stockid: TStockID): IGtkIconSet;    
  end;

(* To display an icon, always use gtk_style_lookup_icon_set() on the widget 
   that will display the icon, or the convenience function 
   gtk_widget_render_icon(). These functions take the theme into account 
   when looking up the icon to use for a given stock ID. *)

implementation
  
end.
