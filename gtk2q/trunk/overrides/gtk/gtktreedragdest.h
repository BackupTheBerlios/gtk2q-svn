struct _GtkTreeDragDestIface
{
  GTypeInterface g_iface;

  /* VTable - not signals */

  gboolean     (* drag_data_received) (GtkTreeDragDest   *drag_dest,
                                       GtkTreePath       *dest,
                                       GtkSelectionData  *selection_data);

  gboolean     (* row_drop_possible)  (GtkTreeDragDest   *drag_dest,
                                       GtkTreePath       *dest_path,
				       GtkSelectionData  *selection_data);
};
