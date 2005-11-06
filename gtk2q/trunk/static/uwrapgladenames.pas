unit uwrapgladenames;

interface
uses uwrapgnames, ugtypes, uwrapgdknames, uwrapgtknames;

{$INCLUDE clinksettings.inc}

const 
(*$IFDEF WIN32*)
  gladelib = 'libglade-2.0-0.dll';
(*$ELSE*)
  gladelib = 'libglade-2.0.so';
(*$ENDIF WIN32*)

type
  PWGladeXML = PWGObject;
  
  PWGladeProperty = ^WGladeProperty;
  WGladeProperty = record
    name: PGChar;
    value: PGChar;
  end;

  PWGladeChildInfo = ^WGladeChildInfo;
  PWGladeSignalInfo = ^WGladeSignalInfo;
  PWGladeAccelInfo = ^WGladeAccelInfo;
  PWGladeAtkActionInfo = ^WGladeAtkActionInfo;
  PWGladeAtkRelationInfo = ^WGladeAtkRelationInfo;
  
  WGladeAccelInfo = record (* C *)
    key: guint;
    modifiers: WGdkModifierType;
    signal: PGChar;
  end;
  
  WGladeAtkActionInfo = record (* C *)
    actionName: PGChar;
    description: PGChar;
  end;
  
  WGladeAtkRelationInfo = record (* C *)
    target: PGChar;
    type1: PGChar;
  end;

  PWGladeWidgetInfo = ^WGladeWidgetInfo;
  WGladeWidgetInfo = record
    parent: PWGladeWidgetInfo;
    classname: PGChar;
    name: PGChar;
    properties: PWGladeProperty;
    nProperties: guint;
    atkProps: PWGladeProperty;
    nAtkProps: guint;
    signals: PWGladeSignalInfo;
    nSignals: guint;
    atkActions: PWGladeAtkActionInfo;
    nAtkActions: guint;
    atkRelations: PWGladeAtkRelationInfo;
    nAtkRelations: guint;
    accels: PWGladeAccelInfo;
    nAccels: guint;
    children: PWGladeChildInfo;
    nChildren: guint;
  end;
  
  WGladeChildInfo = record
    properties: PWGladeProperty;
    nProperites: guint;
    child: PWGladeWidgetInfo;
    internalChild: PGChar;
  end;
  
  WGladeSignalInfo = record (* TODO test *)
    name: PGChar;
    handler: PGChar;
    object1: PGChar; (* NULL if this isn't a connect_object signal *)
    after: guint; (* guint:1 *)
  end;

  WGladeNewFunc = function(xml:PWGladeXML; widgetType: TGType; info: PWGladeWidgetInfo): PWGtkWidget; cdecl;
  WGladeBuildChildrenFunc = procedure(xml:PWGladeXML; parent: PWGtkWidget; info: PWGladeWidgetInfo); cdecl;
  WGladeFindInternalChildFunc = function(xml:PWGladeXML; parent: PWGtkWidget; {const} childname: PGChar): PWGtkWidget; cdecl;

{$ifdef gtk2q_standalone}


(*
This function is used to register new construction functions for a widget
type. The child building routine would call glade_xml_build_widget() on each
child node to create the child before packing it.

This function is mainly useful for addon widget modules for libglade (it
would get called from the glade_init_module() function).
*)
procedure glade_register_widget(
  type1: TGType; newFunc: WGladeNewFunc;
  buildChildren: WGladeBuildChildrenFunc; 
findInternalChild: WGladeFindInternalChildFunc); cdecl; external gladelib;
{$endif gtk2q_standalone}
    
implementation

end.
