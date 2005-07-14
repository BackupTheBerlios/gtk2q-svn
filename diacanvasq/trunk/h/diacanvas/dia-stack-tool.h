/* dia-stack-tool.h
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

#ifndef __DIA_STACK_TOOL_H__
#define __DIA_STACK_TOOL_H__

#include <diacanvas/dia-tool.h>


G_BEGIN_DECLS


#define DIA_TYPE_STACK_TOOL		(dia_stack_tool_get_type ())
#define DIA_STACK_TOOL(obj)		(GTK_CHECK_CAST ((obj), DIA_TYPE_STACK_TOOL, DiaStackTool))
#define DIA_STACK_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_STACK_TOOL, DiaStackToolClass))
#define DIA_IS_STACK_TOOL(obj)		(GTK_CHECK_TYPE ((obj), DIA_TYPE_STACK_TOOL))
#define DIA_IS_STACK_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_STACK_TOOL))
#define DIA_STACK_TOOL_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_STACK_TOOL, DiaStackToolClass))

typedef struct _DiaStackTool DiaStackTool;
typedef struct _DiaStackToolClass DiaStackToolClass;

struct _DiaStackTool {
	DiaTool object;

	GList *stack;
};

struct _DiaStackToolClass {
	DiaToolClass parent_class;
};


GtkType dia_stack_tool_get_type (void);

DiaTool* dia_stack_tool_new (void);

void dia_stack_tool_push (DiaStackTool* stack_tool, DiaTool *tool);
void dia_stack_tool_pop (DiaStackTool* stack_tool);

G_END_DECLS

#endif /* __DIA_STACK_TOOL_H__ */
