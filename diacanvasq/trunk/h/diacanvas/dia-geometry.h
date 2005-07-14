/* dia-geometry.h
 * Copyright (C) 2000  James Henstridge, Alexander Larsson
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

#ifndef __DIA_GEOMETRY_H__
#define __DIA_GEOMETRY_H__

#include <diacanvas/dia-variable.h>

G_BEGIN_DECLS

#define DIA_TYPE_COLOR G_TYPE_UINT32
typedef guint32 DiaColor;

/* Simple wrapper for color creation (Colors are the same type as the
 * GnomeCanvas colors):
 * 
 * DIA_COLOR(r, g, b)      == ((DiaColor) GNOME_CANVAS_COLOR(r, g, b))
 * DIA_COLOR_A(r, g, b, a) == ((DiaColor) GNOME_CANVAS_COLOR_A(r, g, b, a))
 */
#define DIA_COLOR(r, g, b)	((((int) (r) & 0xff) << 24)	\
				 | (((int) (g) & 0xff) << 16)	\
				 | (((int) (b) & 0xff) << 8)	\
				 | 0xff)

#define DIA_COLOR_A(r, g, b, a)	((((int) (r) & 0xff) << 24)	\
				 | (((int) (g) & 0xff) << 16)	\
				 | (((int) (b) & 0xff) << 8)	\
				 | ((int) (a) & 0xff))

#define DIA_COLOR_RED(c)	((int) (((DiaColor) (c)) >> 24) & 0xFF)
#define DIA_COLOR_GREEN(c)	((int) (((DiaColor) (c)) >> 16) & 0xFF)
#define DIA_COLOR_BLUE(c)	((int) (((DiaColor) (c)) >> 8) & 0xFF)
#define DIA_COLOR_ALPHA(c)	((int) ((DiaColor) (c)) & 0xFF)

typedef gdouble DiaAffine[6];

typedef struct _DiaPoint DiaPoint;
typedef struct _DiaSPoint DiaSPoint;
typedef struct _DiaRectangle DiaRectangle;

/* Structure is identical to the LibArt counterparts. */
struct _DiaPoint
{
	gdouble x, y;
};


struct _DiaSPoint
{
	DiaVariable *x;
	DiaVariable *y;
};

struct _DiaRectangle
{
	gdouble left, top, right, bottom;
};

typedef enum
{
	DIA_JOIN_MITER,
	DIA_JOIN_ROUND,
	DIA_JOIN_BEVEL
} DiaJoinStyle;

typedef enum
{
	DIA_CAP_BUTT,
	DIA_CAP_ROUND,
	DIA_CAP_SQUARE
} DiaCapStyle;


#define DIA_TYPE_POINT dia_point_get_type ()
GType	dia_point_get_type		(void);

#define DIA_TYPE_RECTANGLE dia_rectangle_get_type ()
GType	dia_rectangle_get_type		(void);


void	dia_rectangle_add_point		(DiaRectangle *rect, DiaPoint *p);

/*
 * Distances
 */
gdouble dia_distance_point_point	(DiaPoint *p1, DiaPoint *p2);

gdouble dia_distance_point_point_manhattan (DiaPoint *p1, DiaPoint *p2);
	
gdouble dia_distance_rectangle_point	(DiaRectangle *rect, DiaPoint *point);

gdouble dia_distance_line_point		(DiaPoint *line_start,
					 DiaPoint *line_end,
					 DiaPoint *point, gdouble line_width,
					 DiaCapStyle style,
					 DiaPoint *point_on_line);

/*
 * Intersections
 */
gboolean dia_intersection_line_line (DiaPoint *start1, DiaPoint *end1,
				     DiaPoint *start2, DiaPoint *end2,
				     DiaPoint *intersect);

gint	dia_intersection_line_rectangle (DiaPoint *start, DiaPoint *end,
					 DiaRectangle *rect,
					 DiaPoint intersect[2]);

gboolean dia_intersection_rectangle_rectangle (DiaRectangle *r1,
					       DiaRectangle *r2);

G_END_DECLS

#endif /* __DIA_GEOMETRY_H__ */
