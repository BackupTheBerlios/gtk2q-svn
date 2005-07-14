/* dia-canvas-box.h
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
 * DiaCanvasBox
 * ----------
 * Base class for box like objects, which includes basically everything
 * that's not a line.
 * Boxs have eight handles around them and can move, but handles can not
 * connect to other boxs. Moving an individual handle will cause the
 * box to call DiaCanvasBoxClass::resize().
 */

#ifndef __DIA_CANVAS_BOX_H__
#define __DIA_CANVAS_BOX_H__

#include <diacanvas/dia-canvas-element.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_BOX        (dia_canvas_box_get_type ())
#define DIA_CANVAS_BOX(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_BOX, DiaCanvasBox))
#define DIA_CANVAS_BOX_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_BOX, DiaCanvasBoxClass))
#define DIA_IS_CANVAS_BOX(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_BOX))
#define DIA_IS_CANVAS_BOX_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_BOX))
#define DIA_CANVAS_BOX_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_BOX, DiaCanvasBoxClass))

typedef struct _DiaCanvasBox DiaCanvasBox;
typedef struct _DiaCanvasBoxClass DiaCanvasBoxClass;

struct _DiaCanvasBox
{
	DiaCanvasElement item;

	DiaColor color;
	DiaColor fill_color;
	gdouble border_width;

	DiaShape *border;
};


struct _DiaCanvasBoxClass
{
	DiaCanvasElementClass parent_class;
};

GType dia_canvas_box_get_type (void);

	
G_END_DECLS


#endif /* __DIA_CANVAS_BOX_H__ */
