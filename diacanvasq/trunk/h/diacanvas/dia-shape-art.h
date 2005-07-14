/* dia-shape-art.h
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
/* dia-shape-art.h
 * ---------------
 * Libart specific functions for DiaShape
 */
#ifndef __DIA_SHAPE_ART_H__
#define __DIA_SHAPE_ART_H__

#include <diacanvas/dia-shape.h>
#include <diacanvas/dia-canvas-view.h>
#include <pango/pango-layout.h>
#include <libart_lgpl/art_svp.h>

G_BEGIN_DECLS

ArtSVP*	dia_shape_art_update	(DiaShape *shape, DiaCanvasViewItem *item,
				 double *affine, ArtSVP *clip, int flags);

void	dia_shape_art_render	(DiaShape *shape, DiaCanvasViewItem *item,
				 GnomeCanvasBuf *buf);

PangoLayout* dia_shape_art_get_pango_layout (void);

G_END_DECLS

#endif /* __DIA_SHAPE_ART_H__ */
