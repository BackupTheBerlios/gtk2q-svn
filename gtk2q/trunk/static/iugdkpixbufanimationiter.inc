
(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IGdkPixbufAnimationIter = interface(IGObject)
    ['{1589EBD3-B0FC-4481-BC15-88E7D224C9BE}']

    function Advance(const current_time: DGTimeVal): Boolean;
    function GetDelayTime: Integer; // ms
    function IsOnCurrentlyLoadingFrame: Boolean;
    function GetPixbuf: IGdkPixbuf;
  end;
(*$ENDIF define_types*)
