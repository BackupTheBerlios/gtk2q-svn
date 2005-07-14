/* dia-canvas-group.h
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

#ifndef __DIA_CANVAS_GROUP_H__
#define __DIA_CANVAS_GROUP_H__

#include <diacanvas/dia-canvas-item.h>
#include <diacanvas/dia-canvas-groupable.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_GROUP		(dia_canvas_group_get_type ())
#define DIA_CANVAS_GROUP(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_GROUP, DiaCanvasGroup))
#define DIA_CANVAS_GROUP_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_GROUP, DiaCanvasGroupClass))
#define DIA_IS_CANVAS_GROUP(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_GROUP))
#define DIA_IS_CANVAS_GROUP_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_GROUP))
#define DIA_CANVAS_GROUP_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_GROUP, DiaCanvasGroupClass))

typedef struct _DiaCanvasGroup		DiaCanvasGroup;
typedef struct _DiaCanvasGroupClass	DiaCanvasGroupClass;

/**
 * DiaCanvasGroup
 *
 * DiaCanvasGroup is a special kind of #DiaCanvasItem that can hold
 * other canvas items. It implements the #DiaCanvasGroupable interface.
 **/
struct _DiaCanvasGroup
{
	DiaCanvasItem item;

	GList *children;
};

struct _DiaCanvasGroupClass
{
	DiaCanvasItemClass parent_class;
};

GType	dia_canvas_group_get_type	(void);

DiaCanvasItem* dia_canvas_group_create_item (DiaCanvasGroup *group,
					     GType type,
					     const gchar* first_arg_name, ...);

/* Raise or lower the item wrt its other items. */
void	dia_canvas_group_raise_item	(DiaCanvasGroup *group,
					 DiaCanvasItem *item, gint pos);
void	dia_canvas_group_lower_item	(DiaCanvasGroup *group,
					 DiaCanvasItem *item, gint pos);


typedef gint (* DiaCanvasItemForeachFunc) (DiaCanvasItem *item,
					   gpointer data);

/* If TRUE is returned, the children are not evaluated. */
gint	dia_canvas_group_foreach	(DiaCanvasItem *item,
					 DiaCanvasItemForeachFunc func,
					 gpointer data);

G_END_DECLS

#endif /* __DIA_CANVAS_GROUP_H__ */

