 // cdecl ?
  TGtkAccelMapForeach = procedure(data: Pointer; const accelpath: PChar; accelkey: guint; changed: gboolean); cdecl; (* fixme *)
  TGtkTranslateFunc = function(path:PChar; data: Pointer): PChar; cdecl; // FIXME cdecl ?
  TGtkDestroyNotify = procedure(data: Pointer); cdecl; // FIXME cdecl ?
  TGtkCallback = procedure(widget:Pointer; data: Pointer); cdecl; // GtkWidget
  TGtkCellLayoutDataFunc = procedure(layout, renderer, treemodel, treeiter, userdata: Pointer); cdecl;
  TGtkTreeCellDataFunc = TGtkCellLayoutDataFunc;
  TGtkEntryCompletionMatchFunc = function(completion:Pointer; key: PChar; treeiter, userdata: Pointer): LongBool; cdecl;
  TGtkFileFilterFunc = function(filefilterinfo: Pointer; userdata: Pointer): gboolean; cdecl; // PFileFilterInfo
  TGtkIconViewForeachFunc = procedure(iconview: Pointer; treepath: Pointer; userdata: Pointer);  cdecl;
  TGtkMenuDetachFunc = procedure(widget: Pointer; menu: Pointer); cdecl; // GtkWidget*, GtkMenu*
  TGtkMenuPositionFunc = procedure(menu: Pointer; var x,y: GInt; var push_in: gboolean; userdata: Pointer); cdecl;
  TGtkTextTagTableForeach = procedure(texttag: Pointer; userdata: Pointer); cdecl;
  TGtkTreeModelFilterVisibleFunc = function(model, iter: Pointer; userdata: Pointer): gboolean; cdecl;
  TGtkTreeModelFilterModifyFunc = procedure(model, iter: Pointer; value: Pointer; column: GInt; userdata: Pointer); cdecl; // value = GValue *
  TGtkTreeModelForeachFunc = function(model, path, iter: Pointer; userdata: Pointer): gboolean; cdecl;
  TGtkTreeSelectionFunc = function(selection, model, path: Pointer; path_currently_selected: gboolean; userdata: Pointer): gboolean; cdecl;
  TGtkTreeSelectionForeachFunc = procedure(model, path, iter: Pointer; userdata: Pointer); cdecl;
  TGtkTreeIterCompareFunc = function(model: Pointer; a,b: Pointer; userdata: Pointer): Gint; cdecl; // model, gtktreeiter, gtktreeiter
  TGtkTreeViewColumnDropFunc = function(treeview,column,prevcolumn,nextcolumn:Pointer; userdata: Pointer): gboolean; cdecl;
  TGtkTreeViewSearchEqualFunc = procedure(treemodel: Pointer; column: GInt; key: PChar; iter: Pointer; searchdata: Pointer); cdecl;
  TGtkTreeViewMappingFunc = procedure(treeview: Pointer; treepath: Pointer; userdata: Pointer); cdecl;
  TGtkAccelGroupActivate = function(accelgroup: Pointer; acceleratable: Pointer; keyval: GUint; modifier: TGdkModifierType): gboolean; cdecl;
  TGtkAccelGroupFindFunc = function(accelkey: Pointer; closure: Pointer; data: Pointer): gboolean; cdecl;
  TGtkClipboardReceivedFunc = procedure(clipboard: Pointer; selectionddata: Pointer; userdata: Pointer); cdecl;
  TGtkClipboardTextReceivedFunc = procedure(clipboard: Pointer; txt: PChar{PGChar}; userdata: Pointer); cdecl;
  TGtkClipboardTargetsReceivedFunc = procedure(clipboard: Pointer; atoms: array of TGdkAtom; natoms: GInt; userdata: Pointer); cdecl; // TODO test
  TGtkClipboardGetFunc = procedure(clipboard: Pointer; selectiondata: Pointer; info: GUInt; userdataorowner: Pointer); cdecl;
  TGtkClipboardClearFunc = procedure(clipboard: Pointer; userdataorowner: Pointer); cdecl;
  TGtkColorSelectionChangePaletteWithScreenFunc = procedure(screen: Pointer; colors: Pointer; ncolors: GInt); cdecl; // colors = list // PGdkScreen, PGdkColor
  TGtkAboutDialogActivateLinkFunc = procedure(about: Pointer{GtkAboutDialog}; link: PChar{PGChar}; data: Pointer); cdecl;
  