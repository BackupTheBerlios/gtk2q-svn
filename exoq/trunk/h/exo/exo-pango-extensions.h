/* $Id: exo-pango-extensions.h 18995 2005-12-05 16:46:54Z benny $ */
/*-
 * Copyright (c) 2004 os-cillation e.K.
 * Copyright (c) 2000 Anders Carlsson <andersca@gnu.org>
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

#ifndef __EXO_PANGO_EXTENSIONS_H__
#define __EXO_PANGO_EXTENSIONS_H__

#include <pango/pango.h>

G_BEGIN_DECLS;

typedef enum /*< enum,prefix=EXO_PANGO_ELLIPSIZE_MODE >*/
{
  EXO_PANGO_ELLIPSIZE_NONE,
  EXO_PANGO_ELLIPSIZE_START,
  EXO_PANGO_ELLIPSIZE_MIDDLE,
  EXO_PANGO_ELLIPSIZE_END,
} ExoPangoEllipsizeMode;

gboolean  exo_pango_layout_set_text_ellipsized (PangoLayout           *layout,
                                                const char            *string,
                                                int                    width,
                                                ExoPangoEllipsizeMode  mode);

G_END_DECLS;

#endif /* !__EXO_PANGO_EXTENSIONS_H__ */
