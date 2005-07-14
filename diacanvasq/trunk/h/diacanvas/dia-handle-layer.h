/* dia-handle-layer.h
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
/* dia-handle-layer.h
 * ------------------
 * The DiaHandleLayer is a special layer on a DiaCanvasView: it displays
 * the handles. The fine thing about handles is that they always are drawn
 * on top. This small class is the class that draws the handles.
 */

#ifndef __DIA_HANDLE_LAYER_H__
#define __DIA_HANDLE_LAYER_H__

#include <libgnomecanvas/gnome-canvas.h>
#include <diacanvas/dia-canvas-view.h>

G_BEGIN_DECLS

#define DIA_TYPE_HANDLE_LAYER	(dia_handle_layer_get_type ())
#define DIA_HANDLE_LAYER(obj)	(GTK_CHECK_CAST ((obj), DIA_TYPE_HANDLE_LAYER, DiaHandleLayer))
#define DIA_HANDLE_LAYER_CLASS(klass) (GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_HANDLE_LAYER, DiaHandleLayerClass))
#define DIA_IS_HANDLE_LAYER(obj)	(GTK_CHECK_TYPE ((obj), DIA_TYPE_HANDLE_LAYER))
#define DIA_IS_HANDLE_LAYER_CLASS(klass) (GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_HANDLE_LAYER))

typedef struct _DiaHandleLayer      DiaHandleLayer;
typedef struct _DiaHandleLayerClass DiaHandleLayerClass;


struct _DiaHandleLayer
{
	GnomeCanvasItem item;
};

struct _DiaHandleLayerClass
{
	GnomeCanvasItemClass parent_class;
};


GtkType dia_handle_layer_get_type	(void);

void	dia_handle_layer_update_handles	(DiaHandleLayer *layer,
					 DiaCanvasViewItem *item);

void	dia_handle_layer_get_pos_c	(DiaHandleLayer *layer,
					 DiaHandle *handle,
					 gint *x, gint *y);

void	dia_handle_layer_request_redraw	(DiaHandleLayer *layer, gint x, gint y);

void	dia_handle_layer_request_redraw_handle (DiaHandleLayer *layer,
						DiaHandle *handle);

/* DEPRICATED */
void	dia_handle_layer_grab_handle	(DiaHandleLayer *layer,
					 DiaHandle *handle);

G_END_DECLS


#endif /* __DIA_HANDLE_LAYER_H__ */
