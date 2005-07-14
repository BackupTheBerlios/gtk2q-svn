unit uatktypes;

interface

type
  TAtkStateType = (
  	asInvalid, asActive, asArmed, asBusy, asChecked, asDefunct, asEditable, asEnabled, 
  	asExpandable, asExpanded, asFocusable, asFocused, asHorizontal, asIconified,
  	asModal, asMultiLine, asMultiselectable, asOpaque, asPressed, asResizable, 
  	asSelectable, asSelected, asSensitive, asShowing, asSingleLine, asStale, 
  	asTransient, asVertical, asVisible, asManagesDescendants, asIndeterminate,
  	asTruncated, asLastDefined);

  TAtkStateSet = set of TAtkStateType;
  
  TAtkRelationType = (arNull, arControlledBy, arControllerFor,
    arLabelFor, arLabelledBy, arMemberOf, arNodeChildOf, arFlowsTo,
    arSubwindowOf, arEmbeds, arEmbeddedBy, arPopupFor, arParentWindowOf,
    arLastDefined (*probably unneccessary *)
  );

implementation

end.
