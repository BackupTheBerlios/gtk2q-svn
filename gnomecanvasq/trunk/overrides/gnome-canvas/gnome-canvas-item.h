struct _GnomeCanvasItemClass {
	GtkObjectClass parent_class;

	/* Tell the item to update itself.  The flags are from the update flags
	 * defined above.  The item should update its internal state from its
	 * queued state, and recompute and request its repaint area.  The
	 * affine, if used, is a pointer to a 6-element array of doubles.  The
	 * update method also recomputes the bounding box of the item.
	 */
	void (* update) (GnomeCanvasItem *item, double *affine, ArtSVP *clip_path, int flags);

	/* Realize an item -- create GCs, etc. */
	void (* realize) (GnomeCanvasItem *item);

	/* Unrealize an item */
	void (* unrealize) (GnomeCanvasItem *item);

	/* Map an item - normally only need by items with their own GdkWindows */
	void (* map) (GnomeCanvasItem *item);

	/* Unmap an item */
	void (* unmap) (GnomeCanvasItem *item);

	/* Return the microtile coverage of the item */
	ArtUta *(* coverage) (GnomeCanvasItem *item);

	/* Draw an item of this type.  (x, y) are the upper-left canvas pixel
	 * coordinates of the drawable, a temporary pixmap, where things get
	 * drawn.  (width, height) are the dimensions of the drawable.
	 */
	void (* draw) (GnomeCanvasItem *item, GdkDrawable *drawable,
		       int x, int y, int width, int height);

	/* Render the item over the buffer given.  The buf data structure
	 * contains both a pointer to a packed 24-bit RGB array, and the
	 * coordinates.  This method is only used for antialiased canvases.
	 *
	 * TODO: figure out where clip paths fit into the rendering framework.
	 */
	void (* render) (GnomeCanvasItem *item, GnomeCanvasBuf *buf);

	/* Calculate the distance from an item to the specified point.  It also
         * returns a canvas item which is the item itself in the case of the
         * object being an actual leaf item, or a child in case of the object
         * being a canvas group.  (cx, cy) are the canvas pixel coordinates that
         * correspond to the item-relative coordinates (x, y).
	 */
	double (* point) (GnomeCanvasItem *item, double x, double y, int cx, int cy,
			  GnomeCanvasItem **actual_item);

	/* Fetch the item's bounding box (need not be exactly tight).  This
	 * should be in item-relative coordinates.
	 */
	void (* bounds) (GnomeCanvasItem *item, double *x1, double *y1, double *x2, double *y2);

	/* Signal: an event ocurred for an item of this type.  The (x, y)
	 * coordinates are in the canvas world coordinate system.
	 */
	gboolean (* event)                (GnomeCanvasItem *item, GdkEvent *event);

	/* Reserved for future expansion */
	gpointer spare_vmethods [4];
};
