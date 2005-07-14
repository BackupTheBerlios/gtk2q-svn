/* dia-canvas-item.h
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

#ifndef __DIA_CANVAS_ITEM_H__
#define __DIA_CANVAS_ITEM_H__

#include <diacanvas/dia-canvas.h>
#include <diacanvas/dia-canvas-iter.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_ITEM		(dia_canvas_item_get_type ())
#define DIA_CANVAS_ITEM(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_ITEM, DiaCanvasItem))
#define DIA_CANVAS_ITEM_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_ITEM, DiaCanvasItemClass))
#define DIA_IS_CANVAS_ITEM(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_ITEM))
#define DIA_IS_CANVAS_ITEM_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_ITEM))
#define DIA_CANVAS_ITEM_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_ITEM, DiaCanvasItemClass))

/* Declared in dia-canvas.h:
 *	typedef struct _DiaCanvasItem		DiaCanvasItem; 
 *	typedef struct _DiaCanvasItemClass	DiaCanvasItemClass;
 */

/* Type for DiaCanvasItem::affine. */
#define DIA_TYPE_AFFINE dia_canvas_item_affine_get_type ()
GType dia_canvas_item_affine_get_type (void);

/* Type for DiaCanvasItem::handles. */
#define DIA_TYPE_CANVAS_ITEM_HANDLES dia_canvas_item_handles_get_type ()
GType dia_canvas_item_handles_get_type (void);


/**
 * DiaCanvasItemFlags
 * @DIA_VISIBLE: If true, the item is visible. (default=TRUE)
 * @DIA_INTERACTIVE: If true, the item has interactive capabilities
 *  (it can handle events). (Default=TRUE).
 * @DIA_COMPOSITE: The item is an aggregate of it's parent. This means that
 *  if the item is selected or gets the focus, the parent will act and draw
 *  as if it was selected itself. (Default=FALSE)
 * @DIA_NEED_UPDATE: The item's update method should be executed. This flag
 *  is set by dia_canvas_item_request_update(). It should not be set in the
 *  constructor.
 * @DIA_UPDATE_ALL: Tell that all child objects (if any) have been requesting
 *  an update. This flag is used to optimize update requests.
 * 
 * Flags that can be set on a #DiaCanvasItem.
 **/
typedef enum {
	DIA_VISIBLE	= 1,
	DIA_INTERACTIVE = 1 << 1,
	DIA_COMPOSITE	= 1 << 2,
	DIA_NEED_UPDATE	= 1 << 3,
	DIA_UPDATE_ALL	= 1 << 4
} DiaCanvasItemFlags;

#define DIA_CANVAS_ITEM_FLAGS(obj)	(DIA_CANVAS_ITEM (obj)->flags)

#define DIA_CANVAS_ITEM_INTERACTIVE(obj) ((DIA_CANVAS_ITEM_FLAGS (obj) & DIA_INTERACTIVE) != 0)
#define DIA_CANVAS_ITEM_COMPOSITE(obj) ((DIA_CANVAS_ITEM_FLAGS (obj) & DIA_COMPOSITE) != 0)
#define DIA_CANVAS_ITEM_VISIBLE(obj) ((DIA_CANVAS_ITEM_FLAGS (obj) & DIA_VISIBLE) != 0)
#define DIA_CANVAS_ITEM_NEED_UPDATE(obj) ((DIA_CANVAS_ITEM_FLAGS (obj) & DIA_NEED_UPDATE) != 0)
#define DIA_CANVAS_ITEM_UPDATE_ALL(obj) ((DIA_CANVAS_ITEM_FLAGS (obj) & DIA_UPDATE_ALL) != 0)


/**
 * DiaCanvasItemUIState:
 * These flags describe the state the user interface can have wrt the canvas
 * items.
 **/
typedef enum {
	DIA_UI_STATE_UNSELECTED,
	DIA_UI_STATE_SELECTED,
	DIA_UI_STATE_FOCUSED,
	DIA_UI_STATE_GRABBED,
	/* State UNCHANGED indicates that no changes have taken place. */
	DIA_UI_STATE_UNCHANGED
} DiaCanvasItemUIStateFlags;


/**
 * DiaCanvasItem:
 *
 * DiaCanvasItem is the base class for all objects that are displayed in
 * a #DiaCanvasView. DiaCanvasItems are held by a #DiaCanvas.
 * Since a #DiaCanvas can have more than one view, every view holds some
 * custom information in a #DiaCanvasViewItem.
 * If a #DiaCanvasView is provided with a #DiaHandleLayer, the canvas is
 * able to view the handle and sent events to the handles.
 **/
struct _DiaCanvasItem
{
	GObject		object;
	
	/*< public, read-only >*/
	guint32		flags;

	DiaCanvas      *canvas; /* Weak */
	DiaCanvasItem  *parent; /* Weak. Parent should support the
				 * DiaCanvasGroupable interface. */
	DiaRectangle    bounds;

	/* The items collection of handles. */
	GList *handles;

	/* Handles from other items that are connected. */
	GList *connected_handles;

	/* Affine transformation matrix (zoom, rotation, offset):
	 * x' = x*a[0] + y*a[2] + a[4]
	 * y' = x*a[1] + y*a[3] + a[5]
	 */
	gdouble affine[6];
};

struct _DiaCanvasItemClass
{
	GObjectClass parent_class;

	/**
	 * update: 
	 * @item: 
	 *
	 * Update the internal state of the canvas item. This includes:
	 * - recreating shapes
	 * - updating the bounding box
	 **/
	void	(* update)	(DiaCanvasItem *item, gdouble affine[6]);
	
	/**
	 * get_shape_iter:
	 * @item:
	 * @iter:
	 *
	 * Get a shape iterator.
	 **/
	gboolean (* get_shape_iter) (DiaCanvasItem *item, DiaCanvasIter *iter);

	/**
	 * next_shape:
	 * @item:
	 * @shape: previous shape
	 *
	 **/
	gboolean (* shape_next) (DiaCanvasItem *item, DiaCanvasIter *iter);

	/**
	 * shape_value:
	 * @item: 
	 * @iter: 
	 *
	 * Get the DiaShape that belongs to the iter
	 **/
	DiaShape* (* shape_value) (DiaCanvasItem *item, DiaCanvasIter *iter);

	/**
	 * point:
	 * @item:
	 * @x: Point, in item coordinates
	 * @y: 
	 *
	 * Return the distance from an item to a specific point.
	 * @x and @y are the coordinates relative to the item.
	 **/
	gdouble	(* point)	(DiaCanvasItem *item, gdouble x, gdouble y);
	
	/**
	 * handle_motion:
	 * @item:
	 * @handle: Handle to be moved.
	 * @wx: Point where the handle will be moved to, in world coordinates!
	 * @wy:
	 * @mask: modifiers pressed (like shift or control)
	 *
	 * If a handles moves, the #DiaCanvasItem is notified by this function.
	 * This function is called before #DiaHandle's attributes are updated.
	 * This function is used to adjust the item's movement where nessesary.
	 * @wx and @wy are in world coordinates.
	 **/
	void	(* handle_motion) (DiaCanvasItem *item, DiaHandle *handle,
				   gdouble *wx, gdouble *wy,
				   DiaEventMask mask);

	/**
	 * glue:
	 * @item:
	 * @handle:
	 * @x:
	 * @y:
	 *
	 * If a handle is near an object, that object is asked if it wants
	 * to connect the handle. Glueing is the first step: the item
	 * calculates the point where the handle should connect and the
	 * distance between the handles current position and the connection
	 * point is returned.
	 *
	 * Once the handle is released (the mouse button is released) the
	 * handle will request a connection to the item by calling the
	 * connect() function (see below).
	 *
	 * Returns: Distance from (@wx, @wy) to @item's closest connection
	 *	    point.
	 **/
	gdouble (* glue)	(DiaCanvasItem *item, DiaHandle *handle,
				 gdouble *wx, gdouble *wy);

	/*
	 * Signals
	 */

	/* Event is given in coordinates relative to the canvas item.
	 *
	 * DEPRICATED: This handler is no longer used.
	 */
	gboolean (* event)	(DiaCanvasItem *item, gpointer event);

	/* The item is moved. 
	 */
	void	(* move)	(DiaCanvasItem *item,
				 gdouble dx, gdouble dy, gboolean interactive);

	/* A handle may connect to another object.
	 * The position is calculated here. This function may move the handle
	 * in order to place it on a nice point for connection.
	 */
	gboolean (* connect)	(DiaCanvasItem *item, DiaHandle *handle);

	/* A handle can be disconnected if it is no longer attached to an
	 * object or if it is to be connected to another object. If the hanlde
	 * is just placed at some other place on the same object no disconnect()
	 * is send.
	 */
	gboolean (* disconnect)	(DiaCanvasItem *item, DiaHandle *handle);

	/*
	 * The following signals are used to keep the views up to date
	 * with the canvas model.
	 */

	/* Fire this one if an object needs updating.
	 */
	void	(* need_update)	(DiaCanvasItem *item);
	
	/* The z-order of the object changed by `positions' places.
	 * Positive values indicate raising to the top, negative values
	 * tell you the item is lowered.
	 */
	void	(* z_order)	(DiaCanvasItem *item, gint positions);

	/* The state of the object has changed. View items should act
	 * by setting the state of the object. Note that the state can only
	 * change when the item is handling an event through the event()
	 * callback. So in the end only the active view will be updated.
	 */
	void	(* state_changed) (DiaCanvasItem *item, gint new_state);

	/* Return TRUE if the active view item has a specific state
	 * (one of DIA_STATE_SELECTED, DIA_STATE_FOCUSED or DIA_STATE_GRABBED).
	 * The state is returned by the active view.
	 */
	gboolean (* has_state)	(DiaCanvasItem *item, gint state);
};


GType	dia_canvas_item_get_type	(void);

DiaCanvasItem* dia_canvas_item_create	(GType type,
					 const gchar *first_arg_name, ...);

void	dia_canvas_item_set_parent	(DiaCanvasItem *item,
					 DiaCanvasItem *new_parent);

void	dia_canvas_item_request_update	(DiaCanvasItem *item);

void	dia_canvas_item_update_now	(DiaCanvasItem *item);

void	dia_canvas_item_update_child	(DiaCanvasItem *item,
					 DiaCanvasItem *child,
					 gdouble affine[6]);

void	dia_canvas_item_affine_w2i	(DiaCanvasItem *item,
					 gdouble affine[6]);
void	dia_canvas_item_affine_i2w	(DiaCanvasItem *item,
					 gdouble affine[6]);

void	dia_canvas_item_affine_point_w2i (DiaCanvasItem *item,
					  gdouble *x, gdouble *y);
void	dia_canvas_item_affine_point_i2w (DiaCanvasItem *item,
					  gdouble *x, gdouble *y);

void	dia_canvas_item_update_handles_i2w (DiaCanvasItem *item);

void	dia_canvas_item_update_handles_w2i (DiaCanvasItem *item);

gboolean dia_canvas_item_connect	(DiaCanvasItem *item,
					 DiaHandle *handle);
gboolean dia_canvas_item_disconnect	(DiaCanvasItem *item,
					 DiaHandle *handle);

gboolean dia_canvas_item_disconnect_handles (DiaCanvasItem *item);

/* Change the object's state (the state of the active canvas view item): */
void	dia_canvas_item_select		(DiaCanvasItem *item);
void	dia_canvas_item_unselect	(DiaCanvasItem *item);
gboolean dia_canvas_item_is_selected	(DiaCanvasItem *item);
void	dia_canvas_item_focus		(DiaCanvasItem *item);
void	dia_canvas_item_unfocus		(DiaCanvasItem *item);
gboolean dia_canvas_item_is_focused	(DiaCanvasItem *item);
void	dia_canvas_item_grab		(DiaCanvasItem *item);
void	dia_canvas_item_ungrab		(DiaCanvasItem *item);
gboolean dia_canvas_item_is_grabbed	(DiaCanvasItem *item);

void	dia_canvas_item_visible		(DiaCanvasItem *item);
void	dia_canvas_item_invisible	(DiaCanvasItem *item);
gboolean dia_canvas_item_is_visible	(DiaCanvasItem *item);

/* Transforming the item: */
void	dia_canvas_item_identity	(DiaCanvasItem *item);

void	dia_canvas_item_scale		(DiaCanvasItem *item,
					 gdouble sx, gdouble sy);

void	dia_canvas_item_rotate		(DiaCanvasItem *item, gdouble degrees);

void	dia_canvas_item_shear_x		(DiaCanvasItem *item,
					 gdouble dx, gdouble dy);
void	dia_canvas_item_shear_y		(DiaCanvasItem *item,
					 gdouble dx, gdouble dy);

void	dia_canvas_item_move		(DiaCanvasItem *item,
					 gdouble dx, gdouble dy);

void	dia_canvas_item_flip		(DiaCanvasItem *item,
					 gboolean horz, gboolean vert);

/* Use this one in events handlers: */
void	dia_canvas_item_move_interactive (DiaCanvasItem *item,
					  gdouble dx, gdouble dy);

void	dia_canvas_item_expand_bounds	(DiaCanvasItem *item, gdouble d);

void	dia_canvas_item_bb_affine	(DiaCanvasItem* item, gdouble affine[6],
					 gdouble *x1, gdouble *y1,
					 gdouble *x2, gdouble *y2);

/* Iterate over shapes: */
gboolean dia_canvas_item_get_shape_iter (DiaCanvasItem *item,
					 DiaCanvasIter *iter);
gboolean dia_canvas_item_shape_next	(DiaCanvasItem *item,
					 DiaCanvasIter *iter);
DiaShape* dia_canvas_item_shape_value	(DiaCanvasItem *item,
					 DiaCanvasIter *iter);

/* Storing undo information the easy way: */
void	dia_canvas_item_preserve_property (DiaCanvasItem *item,
					   const gchar *property_name);

/*< protected >*/
/* Set the low-level parent and canvas settings for the canvas item. */
void	dia_canvas_item_set_child_of	(DiaCanvasItem *item,
					 DiaCanvasItem *new_parent);

G_END_DECLS

#endif /* __DIA_CANVAS_ITEM_H__ */
