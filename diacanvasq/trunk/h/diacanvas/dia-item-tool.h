/* dia-item-tool.h
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

#ifndef __DIA_ITEM_TOOL_H__
#define __DIA_ITEM_TOOL_H__

#include <diacanvas/dia-tool.h>


G_BEGIN_DECLS


#define DIA_TYPE_ITEM_TOOL		(dia_item_tool_get_type ())
#define DIA_ITEM_TOOL(obj)		(GTK_CHECK_CAST ((obj), DIA_TYPE_ITEM_TOOL, DiaItemTool))
#define DIA_ITEM_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_ITEM_TOOL, DiaItemToolClass))
#define DIA_IS_ITEM_TOOL(obj)		(GTK_CHECK_TYPE ((obj), DIA_TYPE_ITEM_TOOL))
#define DIA_IS_ITEM_TOOL_CLASS(klass)	(GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_ITEM_TOOL))
#define DIA_ITEM_TOOL_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_ITEM_TOOL, DiaItemToolClass))

typedef struct _DiaItemTool DiaItemTool;
typedef struct _DiaItemToolClass DiaItemToolClass;

struct _DiaItemTool {
	DiaTool object;

	/* current_item is the item that was found on a button press event.
	 */
	DiaCanvasViewItem *current_item;

	DiaCanvasViewItem *grabbed_item;

	gdouble old_x, old_y;
};

struct _DiaItemToolClass {
	DiaToolClass parent_class;
};


GtkType dia_item_tool_get_type (void);

DiaTool* dia_item_tool_new (void);

/* TODO: Add a set_grabbed_item?? */

G_END_DECLS

#endif /* __DIA_ITEM_TOOL_H__ */
