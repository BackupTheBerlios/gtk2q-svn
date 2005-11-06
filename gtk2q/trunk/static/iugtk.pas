unit iugtk;

interface
uses ugtktypes, iugobject, iugdk, ugdktypes, iupango, iug,
upangotypes, ugtypes, iugtkiconinfo, iugtktreepath, ugtktreepath, uvarrectools,
iugtktextattributes, iugtkselectiondata, //iugtknotebookpage,
iuatk, uapplication,
iugsignal, ugsignal, ugobject, sgtkeditable, sgtkobject,
sgtkaccelgroup, sgtkadjustment, sgtkstyle, sgtkwidget,
sgtkcontainer, sgtkbutton, sgtklabel, sgtkmenushell,
sgtkimcontext, sgtklayout, sgtkhandlebox, sgtknotebook,
sgtkviewport, sgtkexpander, sgtkpaned, sgtkrange,
sgtkstatusbar, sgtkscale, sgtkactiongroup, sgtkaction,
sgtktoggleaction, sgtkradioaction, sgtkuimanager,
sgtkcolorbutton, sgtktogglebutton, sgtkfontbutton,
sgtkradiobutton, sgtkitem, sgtkmenu, sgtkmenuitem,
sgtkcheckmenuitem, sgtkradiomenuitem, sgtkwindow,
sgtkdialog, sgtkinputdialog,
sgtkscrolledwindow, sgtkplug, sgtksocket,
sgtkcolorselection, sgtkcalendar, sgtktoolitem,
sgtktoolbar, sgtktoolbutton, sgtkfilechooser,
sgtkcelleditable, sgtkcellrenderer, sgtktextbuffer,
sgtktexttag, sgtktextview, sgtktreemodel, sgtktreeselection,
sgtktreesortable, sgtktreeviewcolumn, sgtktreeview,
sgtktoggletoolbutton, sgtkcellrenderertext,
sgtkcellrenderertoggle, sgtktexttagtable,
sgtkentrycompletion, sgtkentry, sgtkspinbutton,
sgtkcurve, sgtkicontheme,
sgtkcombobox

(*$IFDEF USE_GTK26*), 
sgtkmenutoolbutton, sgtkfilechooserbutton,
sgtkcellrendererprogress, sgtkiconview, sgtkcellrenderercombo,
sgtkaboutdialog
(*$ENDIF USE_GTK26*)
;

(* not yet , sgtktreedragdest, sgtktreedragsource; *)

const
  GTK_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE gtkincludes.inc}
{$UNDEF define_consts}

{$DEFINE define_types}
{$INCLUDE gtkincludes.inc}
{$UNDEF define_types}

type
  {$INCLUDE objgtkcallback.inc}

implementation

{$DEFINE define_implementation}
{ $INCLUDE gtkincludes.inc}
{$UNDEF define_implementation}

end.



