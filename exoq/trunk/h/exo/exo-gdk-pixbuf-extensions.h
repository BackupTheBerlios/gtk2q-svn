/* $Id: exo-gdk-pixbuf-extensions.h 19036 2005-12-13 16:11:25Z benny $ */
/*-
 * Copyright (c) 2004 os-cillation e.K.
 *
 * Written by Benedikt Meurer <benny@xfce.org>.
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

#if !defined (EXO_INSIDE_EXO_H) && !defined (EXO_COMPILATION)
#error "Only <exo/exo.h> can be included directly, this file may disappear or change contents."
#endif

#ifndef __EXO_GDK_PIXBUF_EXTENSIONS_H__
#define __EXO_GDK_PIXBUF_EXTENSIONS_H__

#include <gdk-pixbuf/gdk-pixbuf.h>

G_BEGIN_DECLS;

GdkPixbuf *exo_gdk_pixbuf_scale_down  (GdkPixbuf *source,
                                       gboolean   aspect_ratio,
                                       gint       dest_width,
                                       gint       dest_height);
GdkPixbuf *exo_gdk_pixbuf_scale_ratio (GdkPixbuf *source,
                                       gint       dest_size);

G_END_DECLS;

#endif /* !__EXO_GDK_PIXBUF_EXTENSIONS_H__ */

