(*$IFDEF define_types*)
//uses iupointermediator, ugtktypes, iugdk;
  IGtkIconSet = interface //(IPointerMediator)
    ['{8A65A9D5-E7CA-4651-9BEC-FBEFCF7BEB0B}']
    function GetUnderlying: Pointer; 

    function RenderIcon(style: IGtkStyle; direction: TGtkTextDirection; 
    	state: TGtkStateType; iconsize: TGtkIconSize = TGtkIconSize(-1); 
    	widget: IGtkWidget = nil; detail: string = ''): IGdkPixbuf;
    	
    // TODO add_source
    // TODO get_sizes
  end;
(*$ENDIF define_types*)


