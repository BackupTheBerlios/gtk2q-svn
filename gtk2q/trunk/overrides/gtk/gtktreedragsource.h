struct _GtkTreeDragSourceIface
{
  GTypeInterface g_iface;

  /* VTable - not signals */

  gboolean     (* row_draggable)        (GtkTreeDragSource   *drag_source,
                                         GtkTreePath         *path);

  gboolean     (* drag_data_get)        (GtkTreeDragSource   *drag_source,
                                         GtkTreePath         *path,
                                         GtkSelectionData    *selection_data);

  gboolean     (* drag_data_delete)     (GtkTreeDragSource *drag_source,
                                         GtkTreePath       *path);
};
