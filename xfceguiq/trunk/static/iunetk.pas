unit iunetk;

interface
uses snetkapplication, snetkclassgroup, snetkworkspace, snetkscreen, 
  snetkwindow;

const
  NetkDummy = 7;
{$DEFINE define_consts}
{$INCLUDE static/netkincludes.inc}
{$UNDEF define_consts}

{$DEFINE define_types}
{$INCLUDE static/netkincludes.inc}
{$UNDEF define_types}

implementation

{$DEFINE define_implementation}
{$INCLUDE static/netkincludes.inc}
{$UNDEF define_implementation}

end.
