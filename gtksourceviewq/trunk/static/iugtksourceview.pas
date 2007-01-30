unit iugtksourceview;

interface
uses iupointermediator, iugtk, ugtksourceviewtypes, ugtypes,
  sgtksourcebuffer,
  sgtksourcemarker,
  sgtksourceview,
  sgtksourcelanguage,
  sgtksourcelanguagesmanager,
  sgtksourcestylescheme,
  sgtksourcetag,
  sgtksourcetagtable,
  sgtksourcetagstyle,
  sgtksourceprintjob,
  ugtktypes, upangotypes, iupango;

const
  GTK_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE static/gtksourceviewincludes.inc}
{$UNDEF define_consts}

type
  IGnomeCanvasGroup = interface;
  
{$DEFINE define_types}
{$INCLUDE static/gtksourceviewincludes.inc}
{$UNDEF define_types}


implementation

{$DEFINE define_implementation}
{ $INCLUDE static/gtksourceviewincludes.inc}
{$UNDEF define_implementation}


end.
