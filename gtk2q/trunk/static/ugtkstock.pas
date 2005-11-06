unit ugtkstock;

interface
uses ugdktypes, ugtypes, sysutils, iugtkstock;

{$INCLUDE clinksettings.inc}

{$ifdef unittest}
type
  gchar = Char;
  PGChar = ^gchar;
  TGdkModifierType = (X);
  guint = Cardinal;
{$endif unittest}

{
Each stock ID can be associated with a GtkStockItem, which contains the 
user-visible label, keyboard accelerator, and translation domain of the 
menu or toolbar item; and/or with an icon stored in a GtkIconFactory. See 
GtkIconFactory for more information on stock icons. The connection between 
a GtkStockItem and stock icons is purely conventional (by virtue of using 
the same stock ID); it's possible to register a stock item but no icon, 
and vice versa. Stock icons may have a RTL variant which gets used for 
right-to-left locales.

gtk_icon_factory_add Adds the given icon_set to the icon factory, under 
the name stock_id. stock_id should be namespaced for your application, 
e.g. "myapp-whatever-icon". Normally applications create a GtkIconFactory, 
then add it to the list of default factories with 
gtk_icon_factory_add_default().

}

{$ifdef convenience_stock_constants}
type 
  TGtkStock = (
    sAdd, 
    sApply, 
    sBold, 
    sCancel, 
    sCdrom, 
    sClear, 
    sClose, 
    sColorPicker, 
    sConvert, 
    sCopy, 
    sCut, 
    sDelete, 
    sDialogAuthentication, 
    sDialogError, 
    sDialogInfo, 
    sDialogQuestion, 
    sDialogWarning, 
    sDnd, 
    sDndMultiple, 
    sExecute, 
    sFind, 
    sFindAndReplace, 
    sFloppy, 
    sGotoBottom, 
    sGotoFirst, 
    sGotoLast, 
    sGotoTop, 
    sGoBack, 
    sGoDown, 
    sGoForward, 
    sGoUp, 
    sHarddisk, 
    sHelp, 
    sHome, 
    sIndent, 
    sIndex, 
    sItalic, 
    sJumpTo, 
    sJustifyCenter, 
    sJustifyFill, 
    sJustifyLeft, 
    sJustifyRight, 
    sMissingImage, 
    sNetwork, 
    sNew, 
    sNo, 
    sOk, 
    sOpen, 
    sPaste, 
    sPreferences, 
    sPrint, 
    sPrintPreview, 
    sProperties, 
    sQuit, 
    sRedo, 
    sRefresh, 
    sRemove, 
    sRevertToSaved, 
    sSave, 
    sSaveAs, 
    sSelectColor, 
    sSelectFont, 
    sSortAscending, 
    sSortDescending, 
    sSpellCheck, 
    sStop, 
    sStrikethrough, 
    sUndelete, 
    sUnderline, 
    sUndo, 
    sUnindent, 
    sYes, 
    sZoom100, 
    sZoomFit, 
    sZoomIn, 
    sZoomOut
(*$IFDEF USE_GTK26*),
    sAbout,
    sConnect,
    sDirectory,
    sDisconnect,
    sEdit,
    sFile,
    sMediaForward,
    sMediaNext,
    sMediaPause,
    sMediaPlay,
    sMediaPrevious,
    sMediaRecord,
    sMediaRewind,
    sMediaStop
(*$ENDIF USE_GTK26*)
  );
  
// keep TGtkStock and gtk in sync btw.

var
  gtk: array[TGtkStock] of string = (
  'gtk-add',
  'gtk-apply',
  'gtk-bold',
  'gtk-cancel',
  'gtk-cdrom',
  'gtk-clear',
  'gtk-close',
  'gtk-color-picker',
  'gtk-convert',
  'gtk-copy',
  'gtk-cut',
  'gtk-delete',
  'gtk-dialog-authentication',
  'gtk-dialog-error',
  'gtk-dialog-info',
  'gtk-dialog-question',
  'gtk-dialog-warning',
  'gtk-dnd',
  'gtk-dnd-multiple',
  'gtk-execute',
  'gtk-find',
  'gtk-find-and-replace',
  'gtk-floppy',
  'gtk-goto-bottom',
  'gtk-goto-first',
  'gtk-goto-last',
  'gtk-goto-top',
  'gtk-go-back',
  'gtk-go-down',
  'gtk-go-forward',
  'gtk-go-up',
  'gtk-harddisk',
  'gtk-help',
  'gtk-home',
  'gtk-indent',
  'gtk-index',
  'gtk-italic',
  'gtk-jump-to',
  'gtk-justify-center',
  'gtk-justify-fill',
  'gtk-justify-left',
  'gtk-justify-right',
  'gtk-missing-image',
  'gtk-network',
  'gtk-new',
  'gtk-no',
  'gtk-ok',
  'gtk-open',
  'gtk-paste',
  'gtk-preferences',
  'gtk-print',
  'gtk-print-preview',
  'gtk-properties',
  'gtk-quit',
  'gtk-redo',
  'gtk-refresh',
  'gtk-remove',
  'gtk-revert-to-saved',
  'gtk-save',
  'gtk-save-as',
  'gtk-select-color',
  'gtk-select-font',
  'gtk-sort-ascending',
  'gtk-sort-descending',
  'gtk-spell-check',
  'gtk-stop',
  'gtk-strikethrough',
  'gtk-undelete',
  'gtk-underline',
  'gtk-undo',
  'gtk-unindent',
  'gtk-yes',
  'gtk-zoom-100',
  'gtk-zoom-fit',
  'gtk-zoom-in',
  'gtk-zoom-out'
(*$IFDEF USE_GTK26*),
  'gtk-about',
  'gtk-connect',
  'gtk-directory',
  'gtk-disconnect',
  'gtk-edit',
  'gtk-file',
  'gtk-media-forward',
  'gtk-media-next',
  'gtk-media-pause',
  'gtk-media-play',
  'gtk-media-previous',
  'gtk-media-record',
  'gtk-media-rewind',
  'gtk-media-stop'
(*$ENDIF USE_GTK26*)
  );
{$endif convenience_stock_constants}
  
type
  TStockIDArray = array of TStockID;
  EStockItemNotFound = class(Exception)
  end;
  
  DStockItem = record
  Stockid: string; // useless but convenient
  Label1: string;
  Modifier: TGdkModifierType;
  Keyval: guint;
  TranslationDomain: string;
  end;
  
  DStockItems = class(TObject) //, IMap blahblah) // singleton
  protected
    function GetKeys: TStockIDArray;
    function GetValue(key: TStockID): DStockItem;
    procedure SetValue(key: TStockID; item: DStockItem);
  public
    // there are plenty of factory stock items in there btw
    property Keys: TStockIDArray read GetKeys;
    property Values[key: TStockID]: DStockItem read GetValue write SetValue;
  end;

var
  stock: DStockItems;
  
implementation
uses uwrapgnames, uwrapgtknames;

//  DStockItems = class // singleton

type
  PIntStockItem = ^IntStockItem;
  IntStockItem = record // C
  	stockid, label1: PGChar;
  	modifier: TGdkModifierType;
  	keyval: guint;
  	translationDomain: PGChar;
  end;

procedure gtk_stock_add(items: PIntStockItem; nitems: guint); cdecl; external gtklib;
function gtk_stock_list_ids(): PWGSList; cdecl; external gtklib;
function gtk_stock_lookup(stockid: PChar; item: PIntStockItem): gboolean; cdecl; external gtklib;

function IntToExt(inter: IntStockItem): DStockItem;
var 
  si: DStockItem;
begin
  si.Stockid := PChar(inter.stockid);
  si.Label1 := PChar(inter.label1);
  si.modifier := inter.modifier;
  si.keyval := inter.keyval;
  si.translationDomain := PChar(inter.translationDomain);
  Result := si;
end;  

function ExtToIntTemp(exter: DStockItem): IntStockItem;
var
  si: IntStockItem;
begin
  si.Stockid := PGChar(PChar(exter.stockid));
  si.Label1 := PGChar(PChar(exter.label1));
  si.modifier := exter.modifier;
  si.keyval := exter.keyval;
  si.translationDomain := PGChar(PChar(exter.translationDomain));
  Result := si;
end;

function DStockItems.GetKeys: TStockIDArray;
var
  sarr: TStockIDArray;
  i: Integer;
  list: PWGSList;
  item: PWGSList;
  itemstr: PGChar;
begin
  SetLength(Result, 0);
  list := gtk_stock_list_ids();
  if not Assigned(list) then Exit;
  
  SetLength(sarr, g_slist_length(list));
  item := list;
  for i := 0 to High(sarr) do begin
    itemstr := PGChar(item.data);
    sarr[i] := PChar(itemstr);
    g_free(itemstr);
    item := item.next;
  end;
  
  Result := sarr;
end;

function DStockItems.GetValue(key: TStockID): DStockItem;
var
  inter: IntStockItem;
begin
  if gtk_stock_lookup(PChar(key), @inter) then begin
    Result := IntToExt(inter);
    // free items ?
  end else raise EStockItemNotFound.Create(Format('Stock Item ''%s'' not found', [key]));
end;

procedure DStockItems.SetValue(key: TStockID; item: DStockItem);
var
  inter: IntStockItem;
begin
  inter := ExtToIntTemp(item);
  gtk_stock_add(@inter, 1);
end;

initialization
  stock := DStockItems.Create;
  
finalization
  stock.Free;
  
end.
