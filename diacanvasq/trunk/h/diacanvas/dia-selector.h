/* dia-selector.h
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

#ifndef __DIA_SELECTOR_H__
#define __DIA_SELECTOR_H__

#include <libgnomecanvas/gnome-canvas.h>


G_BEGIN_DECLS


#define DIA_TYPE_SELECTOR        (dia_selector_get_type ())
#define DIA_SELECTOR(obj)            (GTK_CHECK_CAST ((obj), DIA_TYPE_SELECTOR, DiaSelector))
#define DIA_SELECTOR_CLASS(klass)    (GTK_CHECK_CLASS_CAST ((klass), DIA_TYPE_SELECTOR, DiaSelectorClass))
#define DIA_IS_SELECTOR(obj)         (GTK_CHECK_TYPE ((obj), DIA_TYPE_SELECTOR))
#define DIA_IS_SELECTOR_CLASS(klass) (GTK_CHECK_CLASS_TYPE ((klass), DIA_TYPE_SELECTOR))


typedef struct _DiaSelector DiaSelector;
typedef struct _DiaSelectorClass DiaSelectorClass;

/* Properties are named x1, y1, x2and y2. */
struct _DiaSelector {
	GnomeCanvasItem item;

	gdouble x1, y1, x2, y2;
};

struct _DiaSelectorClass {
	GnomeCanvasItemClass parent_class;
};


GtkType dia_selector_get_type (void);


G_END_DECLS

#endif /* __DIA_SELECTOR_H__ */
