/* dia-default-tool.h
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

#ifndef __DIA_DEFAULT_TOOL_H__
#define __DIA_DEFAULT_TOOL_H__

#include <diacanvas/dia-tool.h>


G_BEGIN_DECLS


#define DIA_TYPE_DEFAULT_TOOL			(dia_default_tool_get_type ())
#define DIA_DEFAULT_TOOL(obj)			(GTK_CHECK_CAST ((obj), DIA_TYPE_DEFAULT_TOOL, DiaDefaultTool))
#define DIA_DEFAULT_TOOL_CLASS(klass)		(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_DEFAULT_TOOL, DiaDefaultToolClass))
#define DIA_IS_DEFAULT_TOOL(obj)		(GTK_CHECK_TYPE ((obj), DIA_TYPE_DEFAULT_TOOL))
#define DIA_IS_DEFAULT_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_DEFAULT_TOOL))
#define DIA_DEFAULT_TOOL_GET_CLASS(obj)		(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_DEFAULT_TOOL, DiaDefaultToolClass))

typedef struct _DiaDefaultTool DiaDefaultTool;
typedef struct _DiaDefaultToolClass DiaDefaultToolClass;

struct _DiaDefaultTool {
	DiaTool object;

	DiaTool *handle_tool;
	DiaTool *selection_tool;
	DiaTool *item_tool;

	DiaTool *current_tool;
};

struct _DiaDefaultToolClass {
	DiaToolClass parent_class;
};


GtkType dia_default_tool_get_type (void);

DiaTool* dia_default_tool_new (void);

void	dia_default_tool_set_handle_tool	(DiaDefaultTool *tool,
						 DiaTool *handle_tool);
DiaTool* dia_default_tool_get_handle_tool	(DiaDefaultTool *tool);

void	dia_default_tool_set_item_tool		(DiaDefaultTool *tool,
						 DiaTool *item_tool);
DiaTool* dia_default_tool_get_item_tool		(DiaDefaultTool *tool);

void	dia_default_tool_set_selection_tool	(DiaDefaultTool *tool,
						 DiaTool *selection_tool);
DiaTool* dia_default_tool_get_selection_tool	(DiaDefaultTool *tool);

G_END_DECLS

#endif /* __DIA_DEFAULT_TOOL_H__ */
