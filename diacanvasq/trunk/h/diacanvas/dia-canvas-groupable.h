/* dia-canvas-groupable.h
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

#ifndef __DIA_CANVAS_GROUPABLE_H__
#define __DIA_CANVAS_GROUPABLE_H__

#include <diacanvas/dia-canvas-item.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_GROUPABLE	(dia_canvas_groupable_get_type ())
#define DIA_CANVAS_GROUPABLE(obj)	(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_GROUPABLE, DiaCanvasGroupable))
#define DIA_IS_CANVAS_GROUPABLE(obj)	(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_GROUPABLE))
#define DIA_CANVAS_GROUPABLE_GET_IFACE(obj)  (G_TYPE_INSTANCE_GET_INTERFACE ((obj), DIA_TYPE_CANVAS_GROUPABLE, DiaCanvasGroupableIface))

typedef struct _DiaCanvasGroupable	DiaCanvasGroupable; /* Dummy typedef */
typedef struct _DiaCanvasGroupableIface	DiaCanvasGroupableIface;

/**
 * DiaCanvasGroupable:
 *
 * DiaCanvasItems supporting this interface can have child objects in them
 * which will be displayed on the #DiaCanvasView as a seperate object.
 **/
struct _DiaCanvasGroupableIface
{
	GTypeInterface g_iface;

	/* Signals */
	/**
	 * add:
	 * @group:
	 * @item:
	 *
	 * Add an item to the DiaCanvasGroupable object. This method should
	 * take care of setting item->parent and item->canvas.
	 *
	 * Return value: TRUE if the item is added, FALSE otherwise.
	 **/
	void	(* add)		(DiaCanvasGroupable *group, DiaCanvasItem *item);
	void	(* remove)	(DiaCanvasGroupable *group, DiaCanvasItem *item);
	
	/* Virtual functions */
	gboolean (* get_iter)	(DiaCanvasGroupable *group, DiaCanvasIter *iter);
	gboolean (* next)	(DiaCanvasGroupable *group, DiaCanvasIter *iter);
	DiaCanvasItem* (* value) (DiaCanvasGroupable *group, DiaCanvasIter *iter);

	/* DEPRICATED */
	gint	(* length)	(DiaCanvasGroupable *group);
	gint	(* pos)		(DiaCanvasGroupable *group,  DiaCanvasItem *item);
};

GType	dia_canvas_groupable_get_type	(void);

void	dia_canvas_groupable_add	(DiaCanvasGroupable *group,
					 DiaCanvasItem *item);
void	dia_canvas_groupable_remove	(DiaCanvasGroupable *group,
					 DiaCanvasItem *item);

/* *DEPRICATED* Those methods can be used for compound objects.
 * Do not use them anymore use dia_canvas_item_set_parent(). */
void	dia_canvas_groupable_add_construction	(DiaCanvasGroupable *group,
						 DiaCanvasItem *item);
void	dia_canvas_groupable_remove_destruction	(DiaCanvasGroupable *group,
						 DiaCanvasItem *item);

/* Z-order is adjusted by dia_canvas_item_raise/lower(). */

gboolean dia_canvas_groupable_get_iter	(DiaCanvasGroupable *group,
					 DiaCanvasIter *iter);
gboolean dia_canvas_groupable_next	(DiaCanvasGroupable *group,
					 DiaCanvasIter *iter);
DiaCanvasItem*	dia_canvas_groupable_value	(DiaCanvasGroupable *group,
						 DiaCanvasIter *iter);

gint	dia_canvas_groupable_length	(DiaCanvasGroupable *group);
gint	dia_canvas_groupable_pos	(DiaCanvasGroupable *group,
					 DiaCanvasItem *item);

G_END_DECLS

#endif /* __DIA_CANVAS_GROUPABLE_H__ */

