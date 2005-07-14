struct _GnomeCanvasClass {
	GtkLayoutClass parent_class;

	/* Draw the background for the area given. This method is only used
	 * for non-antialiased canvases.
	 */
	void (* draw_background) (GnomeCanvas *canvas, GdkDrawable *drawable,
				  int x, int y, int width, int height);

	/* Render the background for the buffer given. The buf data structure
	 * contains both a pointer to a packed 24-bit RGB array, and the
	 * coordinates. This method is only used for antialiased canvases.
	 */
	void (* render_background) (GnomeCanvas *canvas, GnomeCanvasBuf *buf);

	/* Private Virtual methods for groping the canvas inside bonobo */
	void (* request_update) (GnomeCanvas *canvas);

	/* Reserved for future expansion */
	gpointer spare_vmethods [4];
};
