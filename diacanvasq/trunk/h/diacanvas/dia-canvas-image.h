/* dia-canvas-image.h
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
/*
 * DiaCanvasImage
 * ----------
 * Base class for image like objects, which includes basically everything
 * that's not a line.
 * Images have eight handles around them and can move, but handles can not
 * connect to other images. Moving an individual handle will cause the
 * image to call DiaCanvasImageClass::resize().
 */

#ifndef __DIA_CANVAS_IMAGE_H__
#define __DIA_CANVAS_IMAGE_H__

#include <diacanvas/dia-canvas-element.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

G_BEGIN_DECLS

#define DIA_TYPE_CANVAS_IMAGE        (dia_canvas_image_get_type ())
#define DIA_CANVAS_IMAGE(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CANVAS_IMAGE, DiaCanvasImage))
#define DIA_CANVAS_IMAGE_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CANVAS_IMAGE, DiaCanvasImageClass))
#define DIA_IS_CANVAS_IMAGE(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CANVAS_IMAGE))
#define DIA_IS_CANVAS_IMAGE_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CANVAS_IMAGE))
#define DIA_CANVAS_IMAGE_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CANVAS_IMAGE, DiaCanvasImageClass))

typedef struct _DiaCanvasImage DiaCanvasImage;
typedef struct _DiaCanvasImageClass DiaCanvasImageClass;

struct _DiaCanvasImage
{
	DiaCanvasElement item;
	
	GdkPixbuf *pixbuf;

	/* DiaShape *clip; */
	DiaShape *image;
};


struct _DiaCanvasImageClass
{
	DiaCanvasElementClass parent_class;
};

GType dia_canvas_image_get_type (void);

	
G_END_DECLS


#endif /* __DIA_CANVAS_IMAGE_H__ */
