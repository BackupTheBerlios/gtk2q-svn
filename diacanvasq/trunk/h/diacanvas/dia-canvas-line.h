/* dia-canvas-line.h
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
 * DiaCanvasLine
 * ----------
 * a simple line with a connectable handle on both ends.
 */
#ifndef __DIA_CANVAS_LINE_H__
#define __DIA_CANVAS_LINE_H__

#include <diacanvas/dia-canvas.h>
#include <diacanvas/dia-shape.h>


G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_LINE		(dia_canvas_line_get_type ())
#define DIA_CANVAS_LINE(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_LINE, DiaCanvasLine))
#define DIA_CANVAS_LINE_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_LINE, DiaCanvasLineClass))
#define DIA_IS_CANVAS_LINE(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_LINE))
#define DIA_IS_CANVAS_LINE_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_LINE))
#define DIA_CANVAS_LINE_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_LINE, DiaCanvasLineClass))


typedef struct _DiaCanvasLine DiaCanvasLine;
typedef struct _DiaCanvasLineClass DiaCanvasLineClass;

struct _DiaCanvasLine
{
	DiaCanvasItem item;
	
	gdouble line_width;
	DiaColor color;
	DiaCapStyle cap;
	DiaJoinStyle join;
	gboolean cyclic;

	/* Line is a orthogonal line... */
	gboolean orthogonal;
	gboolean horizontal;

	/* Dashing */
	guint n_dash;
	gdouble *dash;

	/* Arrow heads (on the line's head and tail) */
	gboolean has_head, has_tail;
	gdouble head_a, head_b, head_c, head_d;
	gdouble tail_a, tail_b, tail_c, tail_d;
	DiaColor head_color, tail_color;
	DiaColor head_fill_color, tail_fill_color;

	/* shapes: */
	DiaShape *line;
	DiaShape *head_arrow;
	DiaShape *tail_arrow;
};


struct _DiaCanvasLineClass
{
	DiaCanvasItemClass parent_class;
};

GType dia_canvas_line_get_type (void);

gint dia_canvas_line_get_closest_segment (DiaCanvasLine *line,
					  gdouble x, gdouble y);

G_END_DECLS


#endif /* __DIA_CANVAS_LINE_H__ */
