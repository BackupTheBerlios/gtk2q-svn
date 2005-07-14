/* dia-canvas-text.h
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
 * DiaCanvasText
 * ----------
 * Base class for text like objects, which includes basically everything
 * that's not a line.
 * Texts have eight handles around them and can move, but handles can not
 * connect to other texts. Moving an individual handle will cause the
 * text to call DiaCanvasTextClass::resize().
 */

#ifndef __DIA_CANVAS_TEXT_H__
#define __DIA_CANVAS_TEXT_H__

#include <diacanvas/dia-canvas.h>
#include <pango/pangoft2.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_TEXT        (dia_canvas_text_get_type ())
#define DIA_CANVAS_TEXT(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_TEXT, DiaCanvasText))
#define DIA_CANVAS_TEXT_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_TEXT, DiaCanvasTextClass))
#define DIA_IS_CANVAS_TEXT(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_TEXT))
#define DIA_IS_CANVAS_TEXT_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_TEXT))
#define DIA_CANVAS_TEXT_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_TEXT, DiaCanvasTextClass))

typedef struct _DiaCanvasText DiaCanvasText;
typedef struct _DiaCanvasTextClass DiaCanvasTextClass;

struct _DiaCanvasText
{
	DiaCanvasItem item;
	
	GString *text;

	gdouble width, height;

	gint cursor;

	gboolean wrap_word;
	gboolean multiline;
	gboolean editable;
	gboolean markup;

	DiaShape *text_shape;
};


struct _DiaCanvasTextClass
{
	DiaCanvasItemClass parent_class;
};

GType dia_canvas_text_get_type (void);

	
G_END_DECLS


#endif /* __DIA_CANVAS_TEXT_H__ */
