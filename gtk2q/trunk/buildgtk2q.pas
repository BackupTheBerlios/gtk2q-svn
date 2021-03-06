(*
  Unit to build all units of Free Vision
  
*)
unit buildgtk2q;

interface

uses
  drefcounter, 
  uimporttools,
  uginit,
  iuatk, 
  iugdk, 
  iugdkpixbufformat, 
  iuglade, 
  iugobject, 
  iug, 
  iugsignal, 
  iugtkaccelmap, 
  iugtkiconfactory, 
  iugtkiconinfo, 
  iugtknotebookpage, 
  iugtk, 
  iugtkselectiondata, 
  iugtktextattributes, 
  iugtktreepath, 
  iugtktreerowreference, 
  iupango, 
  iupointermediator, 
  satkimplementoriface, 
  uapplication, 
  uargv, 
  uatkobject, 
  uatomic, 
  ugcharsets, 
  ugdkbitmap, 
  ugdkcursor, 
  ugdkpixbufanimationiter, 
  ugdkpixbufformat, 
  ugdkpixbuftypes, 
  ugdkregion, 
  ugdktypes, 
  uginterface, 
  uglade, 
  uglog, 
  ugobject, 
  ugsignal, 
  ugtkaccelmap, 
  ugtkiconfactory, 
  ugtkiconinfo, 
  ugtkiconset, 
  ugtknotebookpage, 
  ugtkselectiondata, 
  ugtkstock, 
  iugtkstock, 
  ugtktextattributes, 
  ugtktextchildanchor, 
  ugtktreepath, 
  ugtktreerowreference, 
  ugtktreevar, 
  ugtktypes, 
  ugtypes, 
  ugvalue, 
  ukeyvals, 
  unicegvalue, 
  upangoattribute,
  upangoattrlist,
  upangocontext,
  upangocoverage,
  upangoengineshape,
  upangofontdescription,
  upangofontface,
  upangofontfamily,
  upangofontmap,
  upangofontmetrics,
  upangofont,
  upangofontset,
  upangolayout,
  upangolayoutiter,
  upangolayoutline,
  upangoglyphitem,
  upangotabarray,
  upangotypes,
  upointermediator, 
  iutyperegistry,
  utyperegistry, 
  uutf8stringgobjectclasshash, 
  uutf8stringigtkwidgethash, 
  uvarrectools, 
  uwrapgdknames, 
  uwrapgdkpixbufnames, 
  uwrapgladenames, 
  uwrapgnames, 
  uwrapgtknames, 
  uwrappangonames, 
  uincdec, 
  iugweakref, 
  ugweakref, 
  iugtimer, 
  ugtimer, 
  ugdkrgb, 
  udialogs, 
  sgdkpixbufanimation, 
  sgdkpixbufloader, 
  sgdkpixbuf, 
  ugdkpixbufanimation, 
  ugdkpixbufloader, 
  ugdkpixbuf, 
  sgdkcolormap, 
  sgdkdevice, 
  sgdkdisplaymanager, 
  sgdkdisplay, 
  sgdkdragcontext, 
  sgdkdrawable, 
  sgdkgc, 
  sgdkimage, 
  sgdkpixmap, 
  sgdkscreen, 
  sgdkvisual, 
  sgdkwindow, 
  ugdkcolormap, 
  ugdkdevice, 
  ugdkdisplaymanager, 
  ugdkdisplay, 
  ugdkdragcontext, 
  ugdkdrawable, 
  ugdkgc, 
  ugdkimage, 
  ugdkpixmap, 
  ugdkscreen, 
  ugdkvisual, 
  ugdkwindow, 
  sgtkaccelgroup, 
  sgtkaccellabel, 
  sgtkaccessible, 
  sgtkactiongroup, 
  sgtkaction, 
  sgtkadjustment, 
  sgtkalignment, 
  sgtkarrow, 
  sgtkaspectframe, 
  sgtkbin, 
  sgtkbox, 
  sgtkbuttonbox, 
  sgtkbutton, 
  sgtkcalendar, 
  sgtkcelleditable, 
  sgtkcelllayout, 
  sgtkcellrenderer, 
  sgtkcellrendererpixbuf, 
  sgtkcellrenderertext, 
  sgtkcellrenderertoggle, 
  sgtkcheckbutton, 
  sgtkcheckmenuitem, 
  sgtkclipboard, 
  sgtkcolorbutton, 
  sgtkcolorselectiondialog, 
  sgtkcolorselection, 
  sgtkcomboboxentry, 
  sgtkcombobox, 
  sgtkcontainer, 
  sgtkcurve, 
  sgtkdialog, 
  sgtkdrawingarea, 
  sgtkeditable, 
  sgtkentrycompletion, 
  sgtkentry, 
  sgtkeventbox, 
  sgtkexpander, 
  sgtkfilechooserdialog, 
  sgtkfilechooser, 
  sgtkfilechooserwidget, 
  sgtkfilefilter, 
  sgtkfixed, 
  sgtkfontbutton, 
  sgtkfontselectiondialog, 
  sgtkfontselection, 
  sgtkframe, 
  sgtkgammacurve, 
  sgtkhandlebox, 
  sgtkhbox, 
  sgtkhbuttonbox, 
  sgtkhpaned, 
  sgtkhruler, 
  sgtkhscale, 
  sgtkhscrollbar, 
  sgtkhseparator, 
  sgtkicontheme, 
  sgtkimagemenuitem, 
  sgtkimage, 
  sgtkimcontext, 
  sgtkimcontextsimple, 
  sgtkimmulticontext, 
  sgtkinputdialog, 
  sgtkinvisible, 
  sgtkitem, 
  sgtklabel, 
  sgtklayout, 
  sgtkliststore, 
  sgtkmenubar, 
  sgtkmenuitem, 
  sgtkmenu, 
  sgtkmenushell, 
  sgtkmessagedialog, 
  sgtkmisc, 
  sgtknotebook, 
  sgtkobject, 
  sgtkpaned, 
  sgtkplug, 
  sgtkprogressbar, 
  sgtkprogress, 
  sgtkradioaction, 
  sgtkradiobutton, 
  sgtkradiomenuitem, 
  sgtkradiotoolbutton, 
  sgtkrange, 
  sgtkrcstyle, 
  sgtkruler, 
  sgtkscale, 
  sgtkscrollbar, 
  sgtkscrolledwindow, 
  sgtkseparatormenuitem, 
  sgtkseparator, 
  sgtkseparatortoolitem, 
  sgtksettings, 
  sgtksizegroup, 
  sgtksocket, 
  sgtkspinbutton, 
  sgtkstatusbar, 
  sgtkstyle, 
  sgtktable, 
  sgtktearoffmenuitem, 
  sgtktextbuffer, 
  sgtktextmark, 
  sgtktexttag, 
  sgtktexttagtable, 
  sgtktextview, 
  sgtktoggleaction, 
  sgtktogglebutton, 
  sgtktoggletoolbutton, 
  sgtktoolbar, 
  sgtktoolbutton, 
  sgtktoolitem, 
  sgtktooltips, 
  sgtktreemodelfilter, 
  sgtktreemodel, 
  sgtktreemodelsort, 
  sgtktreeselection, 
  sgtktreesortable, 
  sgtktreestore, 
  sgtktreeviewcolumn, 
  sgtktreeview, 
  sgtkuimanager, 
  sgtkvbox, 
  sgtkvbuttonbox, 
  sgtkviewport, 
  sgtkvpaned, 
  sgtkvruler, 
  sgtkvscale, 
  sgtkvscrollbar, 
  sgtkvseparator, 
  sgtkwidget, 
  sgtkwindowgroup, 
  sgtkwindow, 
  ugtkaccelgroup, 
  ugtkaccellabel, 
  ugtkaccessible, 
  ugtkactiongroup, 
  ugtkaction, 
  ugtkadjustment, 
  ugtkalignment, 
  ugtkarrow, 
  ugtkaspectframe, 
  ugtkbin, 
  ugtkbox, 
  ugtkbuttonbox, 
  ugtkbutton, 
  ugtkcalendar, 
  ugtkcelleditable, 
  ugtkcelllayout, 
  ugtkcellrenderer, 
  ugtkcellrendererpixbuf, 
  ugtkcellrenderertext, 
  ugtkcellrenderertoggle, 
  ugtkcheckbutton, 
  ugtkcheckmenuitem, 
  ugtkclipboard, 
  ugtkcolorbutton, 
  ugtkcolorselectiondialog, 
  ugtkcolorselection, 
  ugtkcomboboxentry, 
  ugtkcombobox, 
  ugtkcontainer, 
  ugtkcurve, 
  ugtkdialog, 
  ugtkdrawingarea, 
  ugtkeditable, 
  ugtkentrycompletion, 
  ugtkentry, 
  ugtkeventbox, 
  ugtkexpander, 
  ugtkfilechooserdialog, 
  ugtkfilechooser, 
  ugtkfilechooserwidget, 
  ugtkfilefilter, 
  ugtkfixed, 
  ugtkfontbutton, 
  ugtkfontselectiondialog, 
  ugtkfontselection, 
  ugtkframe, 
  ugtkgammacurve, 
  ugtkhandlebox, 
  ugtkhbox, 
  ugtkhbuttonbox, 
  ugtkhpaned, 
  ugtkhruler, 
  ugtkhscale, 
  ugtkhscrollbar, 
  ugtkhseparator, 
  ugtkicontheme, 
  ugtkimagemenuitem, 
  ugtkimage, 
  ugtkimcontext, 
  ugtkimcontextsimple, 
  ugtkimmulticontext, 
  ugtkinputdialog, 
  ugtkinvisible, 
  ugtkitem, 
  ugtklabel, 
  ugtklayout, 
  ugtkliststore, 
  ugtkmenubar, 
  ugtkmenuitem, 
  ugtkmenu, 
  ugtkmenushell, 
  ugtkmessagedialog, 
  ugtkmisc, 
  ugtknotebook, 
  ugtkobject, 
  ugtkpaned, 
  ugtkplug, 
  ugtkprogressbar, 
  ugtkprogress, 
  ugtkradioaction, 
  ugtkradiobutton, 
  ugtkradiomenuitem, 
  ugtkradiotoolbutton, 
  ugtkrange, 
  ugtkrcstyle, 
  ugtkruler, 
  ugtkscale, 
  ugtkscrollbar, 
  ugtkscrolledwindow, 
  ugtkseparatormenuitem, 
  ugtkseparator, 
  ugtkseparatortoolitem, 
  ugtksettings, 
  ugtksizegroup, 
  ugtksocket, 
  ugtkspinbutton, 
  ugtkstatusbar, 
  ugtkstyle, 
  ugtktable, 
  ugtktearoffmenuitem, 
  ugtktextbuffer, 
  ugtktextmark, 
  ugtktexttag, 
  ugtktexttagtable, 
  ugtktextview, 
  ugtktoggleaction, 
  ugtktogglebutton, 
  ugtktoggletoolbutton, 
  ugtktoolbar, 
  ugtktoolbutton, 
  ugtktoolitem, 
  ugtktooltips, 
  ugtktreemodelfilter, 
  ugtktreemodel, 
  ugtktreemodelsort, 
  ugtktreeselection, 
  ugtktreesortable, 
  ugtktreestore, 
  ugtktreeviewcolumn, 
  ugtktreeview, 
  ugtkuimanager, 
  ugtkvbox, 
  ugtkvbuttonbox, 
  ugtkviewport, 
  ugtkvpaned, 
  ugtkvruler, 
  ugtkvscale, 
  ugtkvscrollbar, 
  ugtkvseparator, 
  ugtkwidget, 
  ugtkwindowgroup, 
  ugtkwindow
{$IFDEF USE_GTK26},
  ugtkaboutdialog,
  sgtkaboutdialog,
  ugtkcellrenderercombo,
  sgtkcellrenderercombo,
  ugtkiconview,
  sgtkiconview,
  ugtkcellrendererprogress,
  sgtkcellrendererprogress,
  ugtkfilechooserbutton,
  sgtkfilechooserbutton,
  ugtkmenutoolbutton,
  sgtkmenutoolbutton
{$ENDIF USE_GTK26}
;

implementation

end.
