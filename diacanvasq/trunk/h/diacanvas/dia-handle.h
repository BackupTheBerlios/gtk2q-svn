/* dia-handle.h
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

/**
 * DiaHandle:
 *
 * A handle is a special element in a Dia like canvas. Handles are used to
 * modify the object (e.g. move a point) and to connect one element to another
 * element.
 * A handle does not grow/shrink if you zoom in/out.
 *
 * A handle supports two coordinate systems: the item and the "world"
 * (root item). If the item's position is changed, the world coordinates are
 * updated immediately. If the world coordinates are changed (for example if
 * the user drags a handle), the world to item update is delayed and taken care
 * of by the DiaCanvasItem::update() function.
 **/

#ifndef __DIA_HANDLE_H__
#define __DIA_HANDLE_H__

#include <diacanvas/dia-canvas.h>

G_BEGIN_DECLS


#define DIA_TYPE_HANDLE			(dia_handle_get_type ())
#define DIA_HANDLE(obj)			(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_HANDLE, DiaHandle))
#define DIA_HANDLE_CLASS(klass)		(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_HANDLE, DiaHandleClass))
#define DIA_IS_HANDLE(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_HANDLE))
#define DIA_IS_HANDLE_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_HANDLE))
#define DIA_HANDLE_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_HANDLE, DiaHandleClass))


/* Declared in dia-canvas.h:
 *	typedef struct _DiaHandle       DiaHandle;
 *	typedef struct _DiaHandleClass  DiaHandleClass;
 */

/* Arguments	Type		Kind	Comment
 * owner	DiaCanvasItem	rw	Owner of the handle. should only be set
 * 					on creation.
 * pos_i	DiaPoint	rw	Set position in item coordinates.
 * pos_w	DiaPoint	rw	Set position in world coordinates.
 * strength	DiaStrength	rw	Set the strength of the handle.
 * connected_to	DiaCanvasItem 	r	If the handle is connected, this is the
 * 					object the handle is connected to.
 * connectable	boolean		rw	Handle can be connected to another item.
 * movable	boolean		rw	Handle can be moved by a user.
 */
struct _DiaHandle {
	GObject object;

	gint movable: 1;
	gint connectable: 1;

	gint need_update_w2i: 1;

	/* The holder of the handle */
	DiaCanvasItem *owner;
	
	/* Position relative to `owner' */
	DiaSPoint pos_i;
	
	/* position relative to canvas' root item. */
	DiaSPoint pos_w;
	
	/* The object the handle is connected to. */
	DiaCanvasItem *connected_to;
	
	/* A list of constraints, used to keep the connection
	 * between the handle and the `connected_to' item up to date.
	 * These constraints are removed once a handle is moved (removed by
	 * the DiaHandleLayer) or otherwise unconnected.
	 * Do not add custom constraints here!!! */
	GSList *constraints;
};

struct _DiaHandleClass
{
	GObjectClass parent_class;

};

GType	dia_handle_get_type		(void);

DiaHandle* dia_handle_new		(DiaCanvasItem *owner);

DiaHandle* dia_handle_new_with_pos	(DiaCanvasItem *owner,
					 gdouble x, gdouble y);

void	dia_handle_set_strength		(DiaHandle *handle,
					 DiaStrength strength);

void	dia_handle_get_pos_i		(DiaHandle *handle,
					 gdouble *x, gdouble *y);
void	dia_handle_get_pos_w		(DiaHandle *handle,
					 gdouble *x, gdouble *y);

void	dia_handle_set_pos_i		(DiaHandle *handle,
					 gdouble x, gdouble y);
void	dia_handle_set_pos_i_affine	(DiaHandle *handle,
					 gdouble x, gdouble y,
					 const gdouble affine[6]);
void	dia_handle_set_pos_w		(DiaHandle *handle,
					 gdouble x, gdouble y);

gdouble	dia_handle_distance_i		(DiaHandle *handle,
					 gdouble x, gdouble y);
gdouble	dia_handle_distance_w		(DiaHandle *handle,
					 gdouble x, gdouble y);

/* Updates. */
void	dia_handle_update_i2w_affine	(DiaHandle *handle,
					 const gdouble affine[6]);
void	dia_handle_request_update_w2i	(DiaHandle *handle);
void	dia_handle_update_w2i		(DiaHandle *handle);
void	dia_handle_update_w2i_affine	(DiaHandle *handle,
					 const gdouble affine[6]);

gint	dia_handle_size			(void);

/* Add/Remove constraints. */
void	dia_handle_add_constraint	(DiaHandle *handle, DiaConstraint *c);
void	dia_handle_add_point_constraint	(DiaHandle *handle, DiaHandle *host);
void	dia_handle_add_line_constraint	(DiaHandle *begin, DiaHandle *end,
					 DiaHandle *middle);
void	dia_handle_remove_constraint	(DiaHandle *handle, DiaConstraint *c);
void	dia_handle_remove_all_constraints (DiaHandle *handle);

/* Undo/Redo */
void	dia_handle_preserve_state	(DiaHandle *handle);

/* Connecting and disconnecting handles is done by:
 *	dia_canvas_item_connect() and dia_canvas_item_disconnect().
 */

G_END_DECLS

#endif /* __DIA_HANDLE_H__ */
