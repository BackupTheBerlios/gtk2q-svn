/* dia-export-svg.h
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
 * DiaExportSVG
 * ----------
 * Produce a Scalable Vector Graphics (SVG) image based on the content of a
 * canvas.
 */

#ifndef __DIA_EXPORT_SVG_H__
#define __DIA_EXPORT_SVG_H__

#include <diacanvas/dia-canvas.h>

G_BEGIN_DECLS

#define DIA_TYPE_EXPORT_SVG     	(dia_export_svg_get_type ())
#define DIA_EXPORT_SVG(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_EXPORT_SVG, DiaExportSVG))
#define DIA_EXPORT_SVG_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_EXPORT_SVG, DiaExportSVGClass))
#define DIA_IS_EXPORT_SVG(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_EXPORT_SVG))
#define DIA_IS_EXPORT_SVG_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_EXPORT_SVG))
#define DIA_EXPORT_SVG_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_EXPORT_SVG, DiaExportSVGClass))

typedef struct _DiaExportSVG DiaExportSVG;
typedef struct _DiaExportSVGClass DiaExportSVGClass;

struct _DiaExportSVG
{
	GObject object;
	
	GString *svg;
};


struct _DiaExportSVGClass
{
	GObjectClass parent_class;
};

GType	dia_export_svg_get_type	(void);

DiaExportSVG* dia_export_svg_new (void);

void	dia_export_svg_render	(DiaExportSVG *export_svg,
				 DiaCanvas *canvas);

void	dia_export_svg_save	(DiaExportSVG *export_svg,
				 const gchar *filename,
				 GError **error);


G_END_DECLS


#endif /* __DIA_EXPORT_SVG_H__ */
