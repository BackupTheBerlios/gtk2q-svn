/* dia-tool.h
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

#ifndef __DIA_TOOL_H__
#define __DIA_TOOL_H__

#include <glib-object.h>


G_BEGIN_DECLS


#define DIA_TYPE_TOOL		(dia_tool_get_type ())
#define DIA_TOOL(obj)		(GTK_CHECK_CAST ((obj), DIA_TYPE_TOOL, DiaTool))
#define DIA_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_TOOL, DiaToolClass))
#define DIA_IS_TOOL(obj)	(GTK_CHECK_TYPE ((obj), DIA_TYPE_TOOL))
#define DIA_IS_TOOL_CLASS(klass) (GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_TOOL))
#define DIA_TOOL_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_TOOL, DiaToolClass))

typedef struct _DiaTool DiaTool;
typedef struct _DiaToolClass DiaToolClass;

#include <diacanvas/dia-canvas-view.h>

/**
 * Base class for Tools.
 *
 * Note that the (x, y) coordinates are converted from canvas to
 * world (canvas) coordinates prior to calling one of those signals.
 **/
struct _DiaTool {
	GObject object;
};

struct _DiaToolClass {
	GObjectClass parent_class;

	gboolean (* button_press_event)		(DiaTool *tool,
						 DiaCanvasView *view,
						 GdkEventButton *button);
	gboolean (* button_release_event)	(DiaTool *tool,
						 DiaCanvasView *view,
						 GdkEventButton *button);
	gboolean (* motion_notify_event)	(DiaTool *tool,
						 DiaCanvasView *view,
						 GdkEventMotion *button);
	gboolean (* key_press_event)		(DiaTool *tool,
						 DiaCanvasView *view,
						 GdkEventKey *button);
	gboolean (* key_release_event)		(DiaTool *tool,
						 DiaCanvasView *view,
						 GdkEventKey *button);
};


GtkType dia_tool_get_type		(void);

gboolean dia_tool_button_press		(DiaTool *tool, DiaCanvasView *view,
					 GdkEventButton *event);
gboolean dia_tool_button_release	(DiaTool *tool, DiaCanvasView *view,
					  GdkEventButton *event);
gboolean dia_tool_motion_notify 	(DiaTool *tool, DiaCanvasView *view,
					 GdkEventMotion *event);
gboolean dia_tool_key_press		(DiaTool *tool, DiaCanvasView *view,
					 GdkEventKey *event);
gboolean dia_tool_key_release		(DiaTool *tool, DiaCanvasView *view,
					 GdkEventKey *event);

G_END_DECLS

#endif /* __DIA_TOOL_H__ */
