/* dia-canvas.h
 * Copyright (C) 2000  James Henstridge, Arjan Molenaar
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
#ifndef __DIA_CANVAS_H__
#define __DIA_CANVAS_H__

#include <glib-object.h>
#include <pango/pango-layout.h>
#include <diacanvas/dia-event.h>
#include <diacanvas/dia-solver.h>
#include <diacanvas/dia-undo-manager.h>
#include <diacanvas/dia-geometry.h>
#include <diacanvas/dia-shape.h>

/*
// losing this lets us test speed
#undef g_message
static void pruntf(char const *igMe, ...) {}
#define g_message if(0);else pruntf // nada
*/

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS			(dia_canvas_get_type ())
#define DIA_CANVAS(obj)			(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS, DiaCanvas))
#define DIA_CANVAS_CLASS(klass)		(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS, DiaCanvasClass))
#define DIA_IS_CANVAS(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS))
#define DIA_IS_CANVAS_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS))
#define DIA_CANVAS_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS, DiaCanvasClass))

typedef struct _DiaCanvas		DiaCanvas;
typedef struct _DiaCanvasClass		DiaCanvasClass;

/* Object is declared in dia-canvas-item.h. */
typedef struct _DiaCanvasItem		DiaCanvasItem; 
typedef struct _DiaCanvasItemClass	DiaCanvasItemClass;


/* Object is declared in dia-handle.h. */
typedef struct _DiaHandle		DiaHandle;
typedef struct _DiaHandleClass		DiaHandleClass;


#define DIA_SET_FLAGS(obj,flag)    G_STMT_START{ ((obj)->flags |= (flag)); }G_STMT_END
#define DIA_UNSET_FLAGS(obj,flag)  G_STMT_START{ ((obj)->flags &= ~(flag)); }G_STMT_END

#include <diacanvas/dia-handle.h>
#include <diacanvas/dia-canvas-item.h>

/**
 * DiaCanvas
 *
 * DiaCanvas holds the data structure that represents the content that is
 * displayed in a #DiaCanvasView.
 * One DiaCanvas can have zero or more views.
 **/
struct _DiaCanvas
{
	GObject parent;
	
	/*< public, read only >*/
	gboolean static_extents: 1;
	gboolean snap_to_grid: 1;
	gboolean allow_undo: 1;
	gboolean allow_state_requests: 1;
	//gboolean in_undo: 1;

	DiaRectangle extents; 
	
	/* the root item in the canvas -- is a group */
	DiaCanvasItem *root;

	/* Variables for a grid: */
	gdouble interval_x;
	gdouble interval_y;
	gdouble offset_x;
	gdouble offset_y;
	DiaColor grid_color; /* RGB grid color */
	DiaColor grid_bg; /* RGB background color. */

	DiaSolver *solver;

	/*< private >*/
	guint idle_id;

	/* Undo/redo behavior */
	DiaUndoManager *undo_manager;

	/* guint stack_depth; */
	/* GSList *undo; */
	/* GSList *redo; */
	/* gpointer undo_entry; */
};

struct _DiaCanvasClass
{
	GObjectClass parent_class;

	void (* update)		(DiaCanvas *canvas);

	/* Signals go here */

	/**
	 * extents_changed:
	 * @canvas:
	 * @new_extents:
	 *
	 * If the canvas' extents are changed, this function is called.
	 **/
	void (* extents_changed) (DiaCanvas *canvas, DiaRectangle *new_extents);

	/**
	 * redraw_view:
	 * @canvas:
	 *
	 * This signal should force all its views to redraw.
	 **/
	void (* redraw_view)	(DiaCanvas *canvas);

	/**
	 * undo:
	 * @canvas:
	 *
	 * This signal is emited every time a undo/redo action is done and
	 * every time undo information is added to the undo stack. User
	 * interfaces can connect to this signal and update undo/redo buttons,
	 * etc.
	 * 
	 * DEPRICATED
	 **/
	void (* undo)		(DiaCanvas *canvas);
};

GType	dia_canvas_get_type		(void);

DiaCanvas* dia_canvas_new		(void);

void	dia_canvas_request_update	(DiaCanvas *canvas);
void	dia_canvas_update_now		(DiaCanvas *canvas);

void	dia_canvas_resolve_now		(DiaCanvas *canvas);

void	dia_canvas_set_extents		(DiaCanvas *canvas,
					 const DiaRectangle *extents);
void	dia_canvas_set_static_extents	(DiaCanvas *canvas, gboolean stat);

void	dia_canvas_snap_to_grid		(DiaCanvas *canvas,
					 gdouble *x, gdouble *y);
void	dia_canvas_set_snap_to_grid	(DiaCanvas *canvas, gboolean snap);

gdouble	dia_canvas_glue_handle		(DiaCanvas *canvas,
					 const DiaHandle *handle,
					 const gdouble dest_x,
					 const gdouble dest_y,
					 gdouble *glue_x, gdouble *glue_y,
					 DiaCanvasItem **item);

GList*	dia_canvas_find_objects_in_rectangle (DiaCanvas *canvas,
					      DiaRectangle *rect);

void	dia_canvas_add_constraint	(DiaCanvas *canvas, DiaConstraint *c);
void	dia_canvas_remove_constraint	(DiaCanvas *canvas, DiaConstraint *c);

PangoLayout* dia_canvas_get_pango_layout (void);

void	dia_canvas_redraw_views		(DiaCanvas *canvas);

/* Undo/Redo */
DiaUndoManager* dia_canvas_get_undo_manager (DiaCanvas *canvas);
void dia_canvas_set_undo_manager (DiaCanvas *canvas, DiaUndoManager *undo_manager);

/* Store a variable on the stack */
void	dia_canvas_preserve		(DiaCanvas *canvas, GObject *object,
					 const char *property_name,
					 const GValue *value, gboolean last);
void	dia_canvas_preserve_property	(DiaCanvas *canvas, GObject *object,
					 const char *property_name);
void	dia_canvas_preserve_property_last (DiaCanvas *canvas, GObject *object,
					   const char *property_name);

#ifndef DIACANVAS_DISABLE_DEPRECATED
void	dia_canvas_push_undo		(DiaCanvas *canvas,
					 const char* optional_comment);
void	dia_canvas_pop_undo		(DiaCanvas *canvas);
void	dia_canvas_clear_undo		(DiaCanvas *canvas);
guint	dia_canvas_get_undo_depth	(DiaCanvas *canvas);

/* Redo last undo change: */
void	dia_canvas_pop_redo		(DiaCanvas *canvas);
void	dia_canvas_clear_redo		(DiaCanvas *canvas);
guint	dia_canvas_get_redo_depth	(DiaCanvas *canvas);

/* Also as property stack_depth */
void	dia_canvas_set_undo_stack_depth (DiaCanvas *canvas, guint depth);
guint	dia_canvas_get_undo_stack_depth (DiaCanvas *canvas);
#endif /* DIACANVAS_USE_DEPRICATED */

G_END_DECLS

#endif /* __DIA_CANVAS_H__ */
