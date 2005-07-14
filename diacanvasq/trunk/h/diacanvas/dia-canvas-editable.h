/* dia-canvas-editable.h
 * Copyright (C) 2003  Arjan Molenaar
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef __DIA_CANVAS_EDITABLE_H__
#define __DIA_CANVAS_EDITABLE_H__

#include <diacanvas/dia-canvas-item.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_EDITABLE	(dia_canvas_editable_get_type ())
#define DIA_CANVAS_EDITABLE(obj)	(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_EDITABLE, DiaCanvasEditable))
#define DIA_IS_CANVAS_EDITABLE(obj)	(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_EDITABLE))
#define DIA_CANVAS_EDITABLE_GET_IFACE(obj)  (G_TYPE_INSTANCE_GET_INTERFACE ((obj), DIA_TYPE_CANVAS_EDITABLE, DiaCanvasEditableIface))

typedef struct _DiaCanvasEditable	DiaCanvasEditable; /* Dummy typedef */
typedef struct _DiaCanvasEditableIface	DiaCanvasEditableIface;

/**
 * DiaCanvasEditable:
 *
 * DiaCanvasItems that should support editable text should implement
 * this interface.
 **/
struct _DiaCanvasEditableIface
{
	GTypeInterface g_iface;

	/**
	 * is_editable:
	 * @editable:
	 *
	 * Return True if the shape is editable. Default TRUE.
	 **/
	gboolean (* is_editable) (DiaCanvasEditable *editable);

	/**
	 * get_editable_shape:
	 * @editable:
	 * @x: x position, in item coordinates
	 * @y: y position, in item coordinates
	 *
	 * Return a #DiaShapeText instance that should be edited. The
	 * point (#x, #y) can be used to determine which shape should
	 * be edited.
	 *
	 * Returns: A DiaShapeText or NULL, in case no text may be edited.
	 **/
	DiaShapeText* (* get_editable_shape) (DiaCanvasEditable *editable,
					      gdouble x, gdouble y);
	
	/*
	 * Signals
	 */

	/**
	 * start_editing:
	 * @editable: the DiaCanvasItem to be edited
	 * @text_shape: A DiaShapeText object that contains all information
	 *              about the text to be edited (such as the text, font,
	 *              alignment, etc.)
	 *
	 * Start a text-edit session. Note that @text_shape is not altered
	 * during editing.
	 **/
	void (* start_editing)	(DiaCanvasEditable *editable,
				 DiaShapeText *text_shape);

	/**
	 * editing_done:
	 *
	 * Editing is done, the new text is returned.
	 * The DiaCanvasItem should update the text.
	 **/
	void (* editing_done)	(DiaCanvasEditable *editable,
				 DiaShapeText *text_shape,
				 const gchar *new_text);

	/**
	 * text_changed:
	 * @editable:
	 * @text_shape: The text shape. The text shape is not updated.
	 * @new_text: The text after the change.
	 *
	 * The text has been changed. 
	 * The view should update the text editor to reflect the change.
	 * In case of DiaCanvasView the text area is updated based on the
	 * (new) state of @text_shape.
	 **/
	void (* text_changed)	(DiaCanvasEditable *editable,
				 DiaShapeText *text_shape,
				 const gchar *new_text);
};

GType	dia_canvas_editable_get_type	(void);

gboolean dia_canvas_editable_is_editable (DiaCanvasEditable *editable);

DiaShapeText* dia_canvas_editable_get_editable_shape (DiaCanvasEditable *editable,
						      gdouble x,
						      gdouble y);

void	dia_canvas_editable_start_editing (DiaCanvasEditable *editable,
					   DiaShapeText *text_shape);

void	dia_canvas_editable_editing_done (DiaCanvasEditable *editable,
					  DiaShapeText *text_shape,
					  const gchar *new_text);

void	dia_canvas_editable_text_changed (DiaCanvasEditable *editable,
					  DiaShapeText *text_shape,
					  const gchar *new_text);

G_END_DECLS

#endif /* __DIA_CANVAS_EDITABLE_H__ */

