unit uutf8stringgobjectclasshash;

interface
uses ugtypes, ugobject, sysutils, classes;

type
  _ACHASH_KEY_ = UTF8String;
  _ACHASH_VALUE_ = TGObjectClass;
  _ACHASH_KEY_ARRAY_ = TUTF8StringArray;

{$DEFINE define_types}
{$INCLUDE anyachash.inc}
{$UNDEF define_types}
  
  TUTF8StringGObjectClassHash = _ACHASH_;
  
implementation
uses variants;

{$DEFINE define_implementation}
{$INCLUDE anyachash.inc}
{$UNDEF define_implementation}

end.
