(*$IFDEF define_consts*)
(*$ENDIF define_consts*)

(*$IFDEF define_types*)
  IPangoAttribute = interface(IPointerMediator)
    ['{567035A8-9666-11DA-93C3-00055DDDEA00}']

    // property StartIndex: Cardinal; /// in bytes
    // property EndIndex: Cardinal; // in bytes

(*
PangoAttribute * pango_attribute_copy          (const PangoAttribute *attr); 
void             pango_attribute_destroy       (PangoAttribute       *attr); 
gboolean         pango_attribute_equal         (const PangoAttribute *attr1, 
                                                const PangoAttribute *attr2);
*)

  end;
(*$ENDIF define_types*)
