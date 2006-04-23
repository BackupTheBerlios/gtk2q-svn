unit iugst;

interface
uses ugtktypes, iugobject, sgstelement;

const
  GST_DUMMY = 7;
{$DEFINE define_consts}
{$INCLUDE static/gstincludes.inc}
{$UNDEF define_consts}

{$DEFINE define_types}
{$INCLUDE static/gstincludes.inc}
{$UNDEF define_types}

type
  {$INCLUDE objgstcallback.inc}

implementation

{$DEFINE define_implementation}  
{no $INCLUDE static/gstincludes.inc}
{$UNDEF define_implementation}

end.
