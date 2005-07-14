/* dia-handle-tool.h
 * Copyright (C) 2004  Arjan Molenaar
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

#ifndef __DIA_HANDLE_TOOL_H__
#define __DIA_HANDLE_TOOL_H__

#include <diacanvas/dia-tool.h>


G_BEGIN_DECLS


#define DIA_TYPE_HANDLE_TOOL		(dia_handle_tool_get_type ())
#define DIA_HANDLE_TOOL(obj)		(GTK_CHECK_CAST ((obj), DIA_TYPE_HANDLE_TOOL, DiaHandleTool))
#define DIA_HANDLE_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_HANDLE_TOOL, DiaHandleToolClass))
#define DIA_IS_HANDLE_TOOL(obj)		(GTK_CHECK_TYPE ((obj), DIA_TYPE_HANDLE_TOOL))
#define DIA_IS_HANDLE_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_HANDLE_TOOL))
#define DIA_HANDLE_TOOL_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_HANDLE_TOOL, DiaHandleToolClass))

typedef struct _DiaHandleTool DiaHandleTool;
typedef struct _DiaHandleToolClass DiaHandleToolClass;

struct _DiaHandleTool {
	DiaTool object;

	/* Amount of pixels that should maximal be used when glue()-ing */
	gint glue_distance;
	
	DiaHandle *grabbed_handle;

	/* This is the item the handle will connect to on a BUTTON_RELEASE. */
	DiaCanvasItem *connect_to;

	DiaEventMask event_mask;
};

struct _DiaHandleToolClass {
	DiaToolClass parent_class;
};


GtkType dia_handle_tool_get_type (void);

DiaTool* dia_handle_tool_new (void);

void	dia_handle_tool_set_grabbed_handle (DiaHandleTool *tool, DiaHandle *handle);

G_END_DECLS

#endif /* __DIA_HANDLE_TOOL_H__ */
