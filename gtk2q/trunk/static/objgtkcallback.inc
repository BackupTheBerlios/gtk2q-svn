  TObjectGtkTranslateFunc = function(path: string{;data}): string of object;
  //TObjectGtkDestroyNotify = procedure(data: Pointer); stdcall; // FIXME cdecl ?
  TObjectGtkCallback = procedure(widget: IGtkWidget{;data}) of object; // GtkWidget
  TObjectGtkCellLayoutDataFunc = procedure(layout: IGtkCellLayout; renderer: IGtkCellRenderer; treemodel: IGtkTreeModel; const treeiter: TGtkTreeIter{;data}) of object;
  TObjectGtkEntryCompletionMatchFunc = function(completion: IGtkEntryCompletion; key: string; const treeiter: TGtkTreeIter{; data}): Boolean of object;
  TObjectGtkFileFilterFunc = function(const filefilterinfo: TGtkFileFilterInfo{;data}): Boolean of object;
  //TObjectGtkIconViewForeachFunc = procedure(iconview: IGtkIconView; treepath: IGtkTreePath{;data}) of object;
  TObjectGtkMenuDetachFunc = procedure(widget: IGtkWidget; menu: IGtkMenu) of object;
  TObjectGtkMenuPositionFunc = procedure(menu: IGtkMenu; var x,y: GInt; var push_in: Boolean{;data}) of object;
  TObjectGtkTextTagTableForeach = procedure(texttag: IGtkTextTag{;data}) of object;
  TObjectGtkTreeModelFilterVisibleFunc = function(model: IGtkTreeModel; const iter: TGtkTreeIter{;data}): Boolean of object;
  TObjectGtkTreeModelFilterModifyFunc = procedure(model: IGtkTreeModel; const iter: TGtkTreeIter; value: Pointer; column: Integer{;data}) of object; // value = GValue *
  TObjectGtkTreeModelForeachFunc = function(model: IGtkTreeModel; path: IGtkTreePath; const iter: TGtkTreeIter{;data}): Boolean of object;
  TObjectGtkTreeSelectionFunc = function(selection: IGtkTreeSelection; model: IGtkTreeModel; path: IGtkTreePath; pathCurrentlySelected: Boolean{;data}): Boolean of object;
  TObjectGtkTreeSelectionForeachFunc = procedure(model: IGtkTreeModel; path: IGtkTreePath; const iter: TGtkTreeIter{;data}) of object;
  TObjectGtkTreeIterCompareFunc = function(model: IGtkTreeModel; const a,b: TGtkTreeIter{;data}): Integer of object;
  TObjectGtkTreeCellDataFunc = procedure(column: IGtkTreeViewColumn; cellrenderer: IGtkCellRenderer; model: IGtkTreeModel; const iter: TGtkTreeIter{;data}) of object;
  TObjectGtkTreeViewColumnDropFunc = function(treeview: IGtkTreeView; column, prevcolumn, nextcolumn: IGtkTreeViewColumn{;data}): Boolean of object;
  TObjectGtkTreeViewSearchEqualFunc = procedure(treemodel: IGtkTreeModel; column: Integer; key: string; const iter: TGtkTreeIter{;data}) of object;
  TObjectGtkTreeViewMappingFunc = procedure(treeview: IGtkTreeView; treepath: IGtkTreePath{;data}) of object;
  TObjectGtkAccelGroupActivate = function(accelgroup: IGtkAccelGroup; acceleratable: IGObject; keyval: GUint; modifier: TGdkModifierType): Boolean of object;
  TObjectGtkAccelGroupFindFunc = function(const accelkey: TGtkAccelKey{; closure: Pointer; data: Pointer}): Boolean of object;
  TObjectGtkClipboardReceivedFunc = procedure(clipboard: IGtkClipboard; selectiondata: IGtkSelectionData{; data}) of object;
  TObjectGtkClipboardTextReceivedFunc = procedure(clipboard: IGtkClipboard; txt: string{;data}) of object;
  TObjectGtkClipboardTargetsReceivedFunc = procedure(clipboard: IGtkClipboard; atoms: array of TGdkAtom{;data}) of object;
  TObjectGtkClipboardGetFunc = procedure(clipboard: IGtkClipboard; selectiondata: IGtkSelectionData; info: GUInt{; userdataorowner: Pointer}) of object;