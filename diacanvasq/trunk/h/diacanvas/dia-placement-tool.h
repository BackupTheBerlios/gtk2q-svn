/* dia-placement-tool.h
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

#ifndef __DIA_PLACEMENT_TOOL_H__
#define __DIA_PLACEMENT_TOOL_H__

#include <diacanvas/dia-tool.h>
#include <diacanvas/dia-handle-tool.h>


G_BEGIN_DECLS


#define DIA_TYPE_PLACEMENT_TOOL		(dia_placement_tool_get_type ())
#define DIA_PLACEMENT_TOOL(obj)		(GTK_CHECK_CAST ((obj), DIA_TYPE_PLACEMENT_TOOL, DiaPlacementTool))
#define DIA_PLACEMENT_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_PLACEMENT_TOOL, DiaPlacementToolClass))
#define DIA_IS_PLACEMENT_TOOL(obj)		(GTK_CHECK_TYPE ((obj), DIA_TYPE_PLACEMENT_TOOL))
#define DIA_IS_PLACEMENT_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_PLACEMENT_TOOL))
#define DIA_PLACEMENT_TOOL_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_PLACEMENT_TOOL, DiaPlacementToolClass))

typedef struct _DiaPlacementTool DiaPlacementTool;
typedef struct _DiaPlacementToolClass DiaPlacementToolClass;

struct _DiaPlacementTool {
	DiaTool object;

	GType object_type;

	DiaTool *handle_tool;

	guint n_params;
	GParameter *params;

	DiaCanvasItem *new_object;
};

struct _DiaPlacementToolClass {
	DiaToolClass parent_class;
};


GtkType dia_placement_tool_get_type (void);

DiaTool* dia_placement_tool_new (GType object_type,
				 const gchar *first_property_name,
				 ...);

DiaTool* dia_placement_tool_newv (GType object_type,
				  guint n_params,
				  GParameter *params);

G_END_DECLS

#endif /* __DIA_PLACEMENT_TOOL_H__ */
