/* dia-canvas-view.h
 * Copyright (C) 2000  James Henstridge
 * Copyright (C) 2001-2003  Arjan Molenaar
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
#ifndef __DIA_CANVAS_VIEW_H__
#define __DIA_CANVAS_VIEW_H__

#include <gdk/gdktypes.h>
#include <gdk/gdkevents.h>
#include <gtk/gtktextview.h>
#include <libgnomecanvas/gnome-canvas.h>
#include <libart_lgpl/art_uta.h>
#include <diacanvas/dia-canvas.h>

G_BEGIN_DECLS

enum {
	/* Bits 0..12 are used by GnomeCanvasItem */
	DIA_CANVAS_VIEW_ITEM_UPDATE_SHAPES	= 1 << 16,
	DIA_CANVAS_VIEW_ITEM_VISIBLE		= 1 << 18
};

#define DIA_CANVAS_VIEW_ITEM_VISIBLE(obj)	((GTK_OBJECT_FLAGS (obj) & GNOME_CANVAS_ITEM_VISIBLE) != 0)
#define DIA_CANVAS_VIEW_ITEM_SELECT(obj)	(dia_canvas_view_item_is_selected (DIA_CANVAS_VIEW_ITEM (obj)))
#define DIA_CANVAS_VIEW_ITEM_FOCUS(obj)		(dia_canvas_view_item_is_focused (DIA_CANVAS_VIEW_ITEM (obj)))
#define DIA_CANVAS_VIEW_ITEM_GRAB(obj)		(GNOME_CANVAS_ITEM (obj)->canvas->grabbed_item == (GnomeCanvasItem*) (obj))

#define DIA_TYPE_CANVAS_VIEW		(dia_canvas_view_get_type ())
#define DIA_CANVAS_VIEW(obj)			(GTK_CHECK_CAST ((obj), DIA_TYPE_CANVAS_VIEW, DiaCanvasView))
#define DIA_CANVAS_VIEW_CLASS(klass)		(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_VIEW, DiaCanvasViewClass))
#define DIA_IS_CANVAS_VIEW(obj)			(GTK_CHECK_TYPE ((obj), DIA_TYPE_CANVAS_VIEW))
#define DIA_IS_CANVAS_VIEW_CLASS(klass)		(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_VIEW))

#define DIA_TYPE_CANVAS_VIEW_ITEM	(dia_canvas_view_item_get_type ())
#define DIA_CANVAS_VIEW_ITEM(obj)	(GTK_CHECK_CAST ((obj), DIA_TYPE_CANVAS_VIEW_ITEM, DiaCanvasViewItem))
#define DIA_CANVAS_VIEW_ITEM_CLASS(klass) (GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_VIEW_ITEM, DiaCanvasViewItemClass))
#define DIA_IS_CANVAS_VIEW_ITEM(obj)	(GTK_CHECK_TYPE ((obj), DIA_TYPE_CANVAS_VIEW_ITEM))
#define DIA_IS_CANVAS_VIEW_ITEM_CLASS(klass) (GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_VIEW_ITEM))

typedef struct _DiaCanvasView       DiaCanvasView;
typedef struct _DiaCanvasViewClass  DiaCanvasViewClass;

typedef struct _DiaCanvasViewItem      DiaCanvasViewItem;
typedef struct _DiaCanvasViewItemClass DiaCanvasViewItemClass;

#include <diacanvas/dia-tool.h>

/**
 * DiaCanvasView
 *
 * Visual (interactive) representation of a diagram (DiaCanvas).
 **/
struct _DiaCanvasView
{
	GnomeCanvas parent;

	/*< read-only >*/

	DiaCanvas *canvas;

	/* A DiaCanvas has the following structure (from up to down):
	 * - A layer where the handles are drawn
	 * - A series of layers containing the canvas' representation, this
	 *   is where the user actually does some interaction with the canvas
	 *   objects. The layers are actually implemented only on the DiaCanvas,
	 *   that will save the DiaCanvasView some administration.
	 * - A grid. The grid has snapping capabilities, etc.
	 */
	DiaCanvasViewItem *root_item;
	GnomeCanvasItem *handle_layer;

	/*< private >*/

	/* Tools can be used to provide other behavior than the default
	 * behavior. */
	DiaTool *tool;

	DiaTool *default_tool;
	/* We can do rubber band selection. */
	/* GnomeCanvasItem *selector; */


	/* Item that currently has the focus (this is different from
	 * GnomeCanvas::focused_item!!!) */
	DiaCanvasViewItem *focus_item;
	GList *selected_items;

	/* We can do text editing: */
	GtkTextView *text_view;
	DiaCanvasViewItem *edited_item;
	DiaShapeText *edited_shape;

	guint text_buffer_changed_id;
	/* These variables are used for sending events. */
	DiaCanvasViewItem *last_item;
	gdouble old_x, old_y; 
	/* Make sure focusing an item is done only once per event. */
	gboolean button_press_handled;
};

struct _DiaCanvasViewClass
{
	GnomeCanvasClass parent_class;

	/**
	 * focus_item:
	 * @view:
	 * @focused_item: The newly focused item, may be NULL in case no item
	 *	has the focus.
	 *
	 * This signal is emited when a new view item has got the focus.
	 * The focus signal is already in use by GtkWidget :-(.
	 **/
	void	(* focus_item)		(DiaCanvasView *view,
					 DiaCanvasViewItem *focused_item);

	/**
	 * select_item:
	 * @view:
	 * @selected_item: The item that is added to the selection.
	 *
	 **/
	void	(* select_item)		(DiaCanvasView *view,
					 DiaCanvasViewItem *selected_item);

	/**
	 * unselect_item:
	 * @view:
	 * @selected_item: The item that is added to the selection.
	 *
	 **/
	void	(* unselect_item)	(DiaCanvasView *view,
					 DiaCanvasViewItem *unselected_item);
};


GtkType	dia_canvas_view_get_type	(void);

GtkWidget* dia_canvas_view_new		(DiaCanvas *canvas, gboolean aa);

GtkWidget* dia_canvas_view_aa_new	(void);

void	dia_canvas_view_set_canvas	(DiaCanvasView *view,
					 DiaCanvas *canvas);
void	dia_canvas_view_unset_canvas	(DiaCanvasView *view);
DiaCanvas* dia_canvas_view_get_canvas	(DiaCanvasView *view);

/* set the zoom factor for canvas (1.0 == 1 pixel/canvas unit) */
gdouble dia_canvas_view_get_zoom	(DiaCanvasView *view);
void	dia_canvas_view_set_zoom	(DiaCanvasView *view, gdouble zoom);

DiaTool* dia_canvas_view_get_tool	(DiaCanvasView *view);
void	dia_canvas_view_set_tool	(DiaCanvasView *view, DiaTool *tool);

DiaTool* dia_canvas_view_get_default_tool (DiaCanvasView *view);
void	dia_canvas_view_set_default_tool (DiaCanvasView *view, DiaTool *tool);

void	dia_canvas_view_select		(DiaCanvasView *view,
					 DiaCanvasViewItem *item);
void	dia_canvas_view_select_rectangle (DiaCanvasView *view,
					  DiaRectangle *rect);
void	dia_canvas_view_select_all	(DiaCanvasView *view);

void	dia_canvas_view_unselect	(DiaCanvasView *view,
					 DiaCanvasViewItem *item);
void	dia_canvas_view_unselect_all	(DiaCanvasView *view);

void	dia_canvas_view_focus		(DiaCanvasView *view,
					 DiaCanvasViewItem *item);

void	dia_canvas_view_move		(DiaCanvasView *view,
					 gdouble dx, gdouble dy,
					 DiaCanvasViewItem *originator);

/* For "grab": use the gnome_canvas_[un]grab() functions. */

void	dia_canvas_view_request_update	(DiaCanvasView *view);

DiaCanvasViewItem* dia_canvas_view_find_view_item (DiaCanvasView *view,
						   DiaCanvasItem *item);

#ifndef DIACANVAS_DISABLE_DEPRECATED
void	dia_canvas_view_gdk_event_to_dia_event (DiaCanvasView *view,
						DiaCanvasViewItem *item,
						GdkEvent *gdk_event,
						gpointer dia_event);
#endif

void	dia_canvas_view_start_editing	(DiaCanvasView *view,
					 DiaCanvasViewItem *item,
					 gdouble x, gdouble y);

void	dia_canvas_view_editing_done	(DiaCanvasView *view);

DiaCanvasView* dia_canvas_view_get_active_view (void);


/**
 * DiaCanvasViewItem
 *
 * A #DiaCanvasViewItem holds information about a #DiaCanvasItem that
 * is specific for one view (e.g. a cursor position for text, an object
 * is selected, rendering information).
 *
 * Information about the #DiaShapes that have to be rendered are held in
 * #DiaCanvasItem::shapes. The shapes contain a list of #DiaShapeItemInfo
 * objects, which contain some #DiaCanvasViewItem specific rendering data
 * (like SVP's and scaled images).
 **/
struct _DiaCanvasViewItem
{
	GnomeCanvasGroup parent;
  
	DiaCanvasItem *item;

	GdkGC *gc;

	guint n_handle_pos;
	gint *handle_pos;

	GSList *view_info;

	ArtUta *redraw_area;

	guint32 event_time;
};

struct _DiaCanvasViewItemClass
{
	GnomeCanvasGroupClass parent_class;
};


GtkType dia_canvas_view_item_get_type	(void);

/*< protected >*/
typedef gint (* DiaCanvasViewItemForeachFunc) (DiaCanvasViewItem *item,
					       gpointer data);

/* Retuns as soon as a DiaCanvasViewItemForeachFunc() returns FALSE. */
gint	dia_canvas_view_item_foreach	(DiaCanvasViewItem *item,
					 DiaCanvasViewItemForeachFunc func,
					 gpointer data);

void	dia_canvas_view_item_add_items	(GnomeCanvasGroup *vitem,
					 DiaCanvasItem *item);

gboolean dia_canvas_view_item_emit_event (DiaCanvasViewItem *item,
					  gpointer event);

void	dia_canvas_view_item_request_redraw_uta (DiaCanvasViewItem *item,
						 ArtUta *uta);

gboolean dia_canvas_view_item_is_focused (DiaCanvasViewItem *item);

gboolean dia_canvas_view_item_is_selected (DiaCanvasViewItem *item);


G_END_DECLS

#endif /* __DIA_CANVAS_VIEW_H__ */
