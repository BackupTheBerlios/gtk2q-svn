/* dia-canvas-iter.h
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

#ifndef __DIA_CANVAS_ITER_H__
#define __DIA_CANVAS_ITER_H__

#include <glib-object.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_ITER dia_canvas_iter_get_type ()

typedef struct _DiaCanvasIter		DiaCanvasIter;

struct _DiaCanvasIter
{
	gpointer data[3];
	GDestroyNotify destroy_func;
	gint stamp;
};

GType	dia_canvas_iter_get_type (void);

void	dia_canvas_iter_init		(DiaCanvasIter *iter);
void	dia_canvas_iter_destroy		(DiaCanvasIter *iter);


G_END_DECLS

#endif /* __DIA_CANVAS_ITER_H__ */
