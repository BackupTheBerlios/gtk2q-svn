
{$ifdef define_types}
type
  TIGtkTreePathArray = array of IGtkTreePath;
{$endif define_types}

// base interfaces
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkeditable.inc}

// non-widget objects
{$ifdef define_types}
type
  IGtkSettings = interface;
  IGtkClipboard = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkobject.inc}
{$INCLUDE output/gtk/iugtksettings.inc}
{$INCLUDE output/gtk/iugtkclipboard.inc}

// accelgroups
{$ifdef define_types}
type
  IGtkAccelGroup = interface;
  TIGtkAccelGroupArray = array of IGtkAccelGroup;
{$endif define_types}
{$INCLUDE static/iugtkaccelmap.inc}
{$INCLUDE output/gtk/iugtkaccelgroup.inc}

// simple widgets, style: style needs widget, widget needs style, widget needs adjustment
{$ifdef define_types}
type
  IGtkBin = interface;
  IGtkWidget = interface;
  TIGtkWidgetArray = array of IGtkWidget;
  IGtkContainer = interface;
  IGtkRcStyle = interface;
  IGtkStyle = interface;
  IGtkAdjustment = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkadjustment.inc}
{$INCLUDE static/iugtkiconset.inc} // needs style
{$INCLUDE output/gtk/iugtkrcstyle.inc}
{$INCLUDE output/gtk/iugtkstyle.inc} // needs iconset
{$INCLUDE output/gtk/iugtkwidget.inc}
{$INCLUDE output/gtk/iugtkmisc.inc}
{$INCLUDE output/gtk/iugtkcontainer.inc}
{$INCLUDE output/gtk/iugtkbin.inc}
{$INCLUDE output/gtk/iugtkbutton.inc}
{$INCLUDE output/gtk/iugtkimage.inc}
{$INCLUDE output/gtk/iugtklabel.inc}
{$INCLUDE output/gtk/iugtkinvisible.inc}

{$INCLUDE output/gtk/iugtkruler.inc}
{$INCLUDE output/gtk/iugtkhruler.inc}
{$INCLUDE output/gtk/iugtkvruler.inc}

// accellabel, needs label
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkaccellabel.inc}

// tooltips, needs object, widget
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtktooltips.inc}

// menushell, needs container
{$ifdef define_types}
type
  IGtkMenuShell = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkmenushell.inc}

// im context, needs menushell
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkimcontext.inc}
{$INCLUDE output/gtk/iugtkimcontextsimple.inc}
{$INCLUDE output/gtk/iugtkimmulticontext.inc}

// separator
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkseparator.inc}
{$INCLUDE output/gtk/iugtkhseparator.inc}
{$INCLUDE output/gtk/iugtkvseparator.inc}

{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkdrawingarea.inc}


// accessible
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkaccessible.inc}
{$INCLUDE output/gtk/iugtkalignment.inc}

// eventbox
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkeventbox.inc}

// boxes, containers
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkbox.inc}
{$INCLUDE output/gtk/iugtkvbox.inc}
{$INCLUDE output/gtk/iugtkhbox.inc}
{$INCLUDE output/gtk/iugtkbuttonbox.inc}
{$INCLUDE output/gtk/iugtkhbuttonbox.inc}
{$INCLUDE output/gtk/iugtkvbuttonbox.inc}
{$INCLUDE output/gtk/iugtklayout.inc}
{$INCLUDE output/gtk/iugtkhandlebox.inc}
{$INCLUDE output/gtk/iugtkfixed.inc}
{$INCLUDE output/gtk/iugtktable.inc}

// notebook
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtknotebook.inc}
{  NCLUDE output/gtk/iugtkoldeditable.inc}
{ CLUDE output/gtk/iugtkpixmap.inc}
{ .$INCLUDE output/gtk/iugtkpreview.inc}

// sizegroup
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtksizegroup.inc}

// viewport
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkviewport.inc}

{$INCLUDE output/gtk/iugtkexpander.inc}

// paned
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkpaned.inc}
{$INCLUDE output/gtk/iugtkhpaned.inc}
{$INCLUDE output/gtk/iugtkvpaned.inc}

// range
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkrange.inc}

// scrollbar, needs range
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkscrollbar.inc}
{$INCLUDE output/gtk/iugtkhscrollbar.inc}
{$INCLUDE output/gtk/iugtkvscrollbar.inc}

// statusbar
{$INCLUDE output/gtk/iugtkstatusbar.inc}

// scales
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkscale.inc}
{$INCLUDE output/gtk/iugtkhscale.inc}
{$INCLUDE output/gtk/iugtkvscale.inc}

// frames
{$ifdef define_types}
type
  IGtkFrame = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkframe.inc}
{$INCLUDE output/gtk/iugtkaspectframe.inc}

// progressbar
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkprogress.inc}
{$INCLUDE output/gtk/iugtkprogressbar.inc}

// actions
{$ifdef define_types}
type
  IGtkAction = interface;
  TIGtkActionArray = array of IGtkAction;
  IGtkActionGroup = interface;
  TIGtkActionGroupArray = array of IGtkActionGroup;
{$endif define_types}
{$INCLUDE output/gtk/iugtkactiongroup.inc}
{$INCLUDE output/gtk/iugtkaction.inc}

// actions, specialized
{$ifdef define_types}
type
  IGtkToggleAction = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtktoggleaction.inc}
{$INCLUDE output/gtk/iugtkradioaction.inc}

// uimanager
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkuimanager.inc}

// complex buttons
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkcolorbutton.inc}
{$INCLUDE output/gtk/iugtktogglebutton.inc}
{$INCLUDE output/gtk/iugtkfontbutton.inc}
{$INCLUDE output/gtk/iugtkcheckbutton.inc}
{$INCLUDE output/gtk/iugtkradiobutton.inc}

// item
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkitem.inc}

// menu, needs item
{$ifdef define_types}
type
  IGtkMenu = interface;
  IGtkMenuItem = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkmenubar.inc}
{$INCLUDE output/gtk/iugtkmenu.inc}
{$INCLUDE output/gtk/iugtkmenuitem.inc}
{$INCLUDE output/gtk/iugtkimagemenuitem.inc}
{$INCLUDE output/gtk/iugtkcheckmenuitem.inc}

{$INCLUDE output/gtk/iugtkradiomenuitem.inc}
{$INCLUDE output/gtk/iugtktearoffmenuitem.inc}
{$INCLUDE output/gtk/iugtkseparatormenuitem.inc}

// simple old widgets
{$ifdef define_types}
//type
{$endif define_types}
{   NOT $INCLUDE output/gtk/iugtkcombo.inc}
{   NOT $INCLUDE output/gtk/iugtkoptionmenu.inc}

// windows, dialogs
{$ifdef define_types}
type
  IGtkWindow = interface;
  TIGtkWindowArray = array of IGtkWindow;
{$endif define_types}
{$INCLUDE output/gtk/iugtkwindow.inc}
{$INCLUDE output/gtk/iugtkwindowgroup.inc}
{$INCLUDE output/gtk/iugtkdialog.inc}
{$INCLUDE output/gtk/iugtkinputdialog.inc}
{$INCLUDE output/gtk/iugtkmessagedialog.inc}
{$INCLUDE output/gtk/iugtkcolorselectiondialog.inc}
{$INCLUDE output/gtk/iugtkfontselectiondialog.inc}
{$INCLUDE output/gtk/iugtkscrolledwindow.inc}

// plug/socket, needs window
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkplug.inc}
{$INCLUDE output/gtk/iugtksocket.inc}

// finished window interfaces
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkcolorselection.inc}
{$INCLUDE output/gtk/iugtkfontselection.inc}

// finished windows
{$INCLUDE output/gtk/iugtkcalendar.inc}

// toolbar
{$ifdef define_types}
type
  IGtkToolItem = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtktoolitem.inc}
{$INCLUDE output/gtk/iugtkseparatortoolitem.inc}
{$INCLUDE output/gtk/iugtktoolbar.inc}
{$INCLUDE output/gtk/iugtktoolbutton.inc}

// toolitems, specialized
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtktoggletoolbutton.inc}
{$INCLUDE output/gtk/iugtkradiotoolbutton.inc}


// filechooser
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkfilefilter.inc}
{$INCLUDE output/gtk/iugtkfilechooserdialog.inc}
{$INCLUDE output/gtk/iugtkfilechooser.inc}
{$INCLUDE output/gtk/iugtkfilechooserwidget.inc}
{  NCLUDE output/gtk/iugtkfileselection.inc}

// cellrenderers
{$ifdef define_types}
type
  IGtkCellRenderer = interface;
  TIGtkCellRendererArray = array of IGtkCellRenderer;
  IGtkCellLayout = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkcelleditable.inc}
{$INCLUDE output/gtk/iugtkcelllayout.inc}
{$INCLUDE output/gtk/iugtkcellrenderer.inc}
{$INCLUDE output/gtk/iugtkcellrendererpixbuf.inc}
{$INCLUDE output/gtk/iugtkcellrenderertext.inc}
{$INCLUDE output/gtk/iugtkcellrenderertoggle.inc}

// text
{$ifdef define_types}
type
  IGtkTextMark = interface;
  IGtkTextChildAnchor = interface;
  IGtkTextTag = interface;
  IGtkTextTagTable = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtktextbuffer.inc}
{  CLUDE output/gtk/iugtktext.inc}
{$INCLUDE static/iugtktextchildanchor.inc}
{$INCLUDE output/gtk/iugtktextmark.inc}
{$INCLUDE output/gtk/iugtktexttag.inc}
{$INCLUDE output/gtk/iugtktexttagtable.inc}
{$INCLUDE output/gtk/iugtktextview.inc}

// tree
{$ifdef define_types}
type
  IGtkTreeModel = interface;
  IGtkTreeViewColumn = interface;
  IGtkTreeView = interface;
  TIGtkTreeViewColumnArray = array of IGtkTreeViewColumn;
{$endif define_types}
{ NOT $INCLUDE output/gtk/iugtktree.inc}
{ NOT $INCLUDE output/gtk/iugtktreeitem.inc}
{$INCLUDE output/gtk/iugtktreemodel.inc}
{$INCLUDE output/gtk/iugtktreemodelfilter.inc}
{$INCLUDE output/gtk/iugtktreemodelsort.inc}
{$INCLUDE output/gtk/iugtktreedragsource.inc}
{$INCLUDE output/gtk/iugtktreedragdest.inc}
{$INCLUDE output/gtk/iugtktreeselection.inc}
{$INCLUDE output/gtk/iugtktreesortable.inc}
{$INCLUDE output/gtk/iugtktreestore.inc}
{$INCLUDE output/gtk/iugtktreeviewcolumn.inc}
{$INCLUDE output/gtk/iugtktreeview.inc}
{  CLUDE output/gtk/iugtklist.inc}
{  CLUDE output/gtk/iugtklistitem.inc}
{$INCLUDE output/gtk/iugtkliststore.inc}

// entry, needs treemodel, widget
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkentrycompletion.inc}
{$INCLUDE output/gtk/iugtkentry.inc}

// spinbutton, needs entry
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkspinbutton.inc}

// combobox, needs treemodel, entry, widget
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkcombobox.inc}
{$INCLUDE output/gtk/iugtkcomboboxentry.inc}

// special widgets
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkarrow.inc}
{$INCLUDE output/gtk/iugtkgammacurve.inc}
{$INCLUDE output/gtk/iugtkcurve.inc}

// icontheme
{$ifdef define_types}
type
  //IGtkIconInfo = interface;
{$endif define_types}
{$INCLUDE output/gtk/iugtkicontheme.inc}

{$IFDEF USE_GTK26}
{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkaboutdialog.inc}
{$INCLUDE output/gtk/iugtkcellrenderercombo.inc}

{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkiconview.inc}
{$INCLUDE output/gtk/iugtkcellrendererprogress.inc}

{$ifdef define_types}
type
{$endif define_types}
{$INCLUDE output/gtk/iugtkfilechooserbutton.inc}
{$INCLUDE output/gtk/iugtkmenutoolbutton.inc}

{$ENDIF USE_GTK26}

{$ifdef define_types}
type
  (* convenience interface that can be used to see if a particular widget supports models *)
  IGtkTreeModelUser = interface
    ['{162892C9-50D3-41A3-8DD2-BE03EA406AE9}']
    function GetModel: IGtkTreeModel;
    procedure SetModel(model: IGtkTreeModel);
    property Model: IGtkTreeModel read GetModel write SetModel;
  end;

{$endif define_types}
{NOT  $INCLUDE output/gtk/iugtktipsquery.inc}

