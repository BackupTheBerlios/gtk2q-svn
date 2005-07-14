/* dia-canvas-element.h
 * Copyright (C) 2001  Arjan Molenaar
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
/*
 * DiaCanvasElement
 * ----------
 * Base class for element like objects, which includes basically everything
 * that's not a line.
 * Elements have eight handles around them and can move, but handles can not
 * connect to other elements. Moving an individual handle will cause the
 * element to call DiaCanvasElementClass::resize().
 */

#ifndef __DIA_CANVAS_ELEMENT_H__
#define __DIA_CANVAS_ELEMENT_H__

#include <diacanvas/dia-canvas.h>

G_BEGIN_DECLS

typedef enum {
	DIA_HANDLE_N,
	DIA_HANDLE_NW,
	DIA_HANDLE_NE,
	DIA_HANDLE_S,
	DIA_HANDLE_W,
	DIA_HANDLE_E,
	DIA_HANDLE_SW,
	DIA_HANDLE_SE
} DiaCanvasElementHandle;

/* enum {
	DIA_NEED_ALIGN_HANDLES = 1 << 5
}; */

#define DIA_TYPE_CANVAS_ELEMENT        (dia_canvas_element_get_type ())
#define DIA_CANVAS_ELEMENT(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_ELEMENT, DiaCanvasElement))
#define DIA_CANVAS_ELEMENT_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_ELEMENT, DiaCanvasElementClass))
#define DIA_IS_CANVAS_ELEMENT(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_ELEMENT))
#define DIA_IS_CANVAS_ELEMENT_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_ELEMENT))
#define DIA_CANVAS_ELEMENT_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_ELEMENT, DiaCanvasElementClass))

typedef struct _DiaCanvasElement DiaCanvasElement;
typedef struct _DiaCanvasElementClass DiaCanvasElementClass;

struct _DiaCanvasElement
{
	DiaCanvasItem item;
	
	/* These two values describe the size of the element. They also
	 * tell us where the handles should be placed. */
	gdouble width, height;
	gdouble min_width, min_height;
};


struct _DiaCanvasElementClass
{
	DiaCanvasItemClass parent_class;
};

GType	dia_canvas_element_get_type (void);

DiaHandle* dia_canvas_element_get_opposite_handle (DiaCanvasItem *item,
						   DiaHandle *handle);

/*< Protected >*/
void	dia_canvas_element_align_handles (DiaCanvasElement *element);

G_END_DECLS


#endif /* __DIA_CANVAS_ELEMENT_H__ */
