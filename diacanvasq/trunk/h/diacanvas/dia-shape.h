/* dia-shape.h
 *
 * Copyright (C) 2000  Arjan Molenaar
 * Copyright (C) 2004  Martin Willemoes Hansen <mwh@sysrq.dk>
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
/* dia-shape.h
 * -----------
 * DiaShapes are preformatted, renderer independant shapes.
 *
 * Since calculating shapes can take up a lot of time, these functions
 * provide a way to produce half-fabricates.
 * The real content of the shape should not be the consern of the CanvasItem
 * creator, it only has to know when to update a shape:
 * - if some of the variables used to create the shape were changed;
 * - if the affine of the object has changed.
 */
#ifndef __DIA_SHAPE_H__
#define __DIA_SHAPE_H__

#include <glib.h>
#include <libart_lgpl/art_vpath.h>
#include <libart_lgpl/art_vpath_dash.h>
#include <libart_lgpl/art_bpath.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <pango/pango.h>
#include <diacanvas/dia-geometry.h>

G_BEGIN_DECLS

#define DIA_SHAPE(sh) ((DiaShape*)(sh))

/* Several different kinds of shapes to be used by the renderers
 */
typedef enum
{
	DIA_SHAPE_NONE,
	DIA_SHAPE_PATH, /* Line, polygon, rectangle */
	DIA_SHAPE_BEZIER,
	DIA_SHAPE_ELLIPSE, /* ellipse, circle */
	DIA_SHAPE_TEXT,
	DIA_SHAPE_IMAGE,
	DIA_SHAPE_WIDGET, /* Only widgets w/ a model/view architecture? */
	DIA_SHAPE_CLIP /* Set a clip path for the following shapes. */
} DiaShapeType;

typedef enum
{
	DIA_FILL_NONE,
	DIA_FILL_SOLID
} DiaFillStyle;

typedef enum
{
	DIA_WRAP_NONE,
	DIA_WRAP_CHAR,
	DIA_WRAP_WORD
} DiaWrapMode;

/**
 * DiaShapeVisibility:
 *
 * DEPRICATED.
 **/
typedef enum
{
	DIA_SHAPE_HIDDEN,
	DIA_SHAPE_VISIBLE,
	DIA_SHAPE_VISIBLE_IF_SELECTED,
	DIA_SHAPE_VISIBLE_IF_FOCUSED,
	DIA_SHAPE_VISIBLE_IF_GRABBED
} DiaShapeVisibility;

#define DIA_TYPE_DASH_STYLE dia_dash_style_get_type()

typedef struct _DiaDashStyle DiaDashStyle;

struct _DiaDashStyle
{
	guint n_dash;
	gdouble dash[1];
};

GType dia_dash_style_get_type (void);

DiaDashStyle* dia_dash_style_new (gint n_dash, gdouble dash1, ...);
DiaDashStyle* dia_dash_style_newv (gint n_dash, gdouble dashes []);
void dia_dash_style_free (DiaDashStyle *dash_style);


#define DIA_TYPE_SHAPE_PATH dia_shape_path_get_type()
#define DIA_TYPE_SHAPE_BEZIER dia_shape_bezier_get_type()
#define DIA_TYPE_SHAPE_ELLIPSE dia_shape_ellipse_get_type()
#define DIA_TYPE_SHAPE_TEXT dia_shape_text_get_type()
#define DIA_TYPE_SHAPE_IMAGE dia_shape_image_get_type()
GType dia_shape_path_get_type (void);
GType dia_shape_bezier_get_type (void);
GType dia_shape_ellipse_get_type (void);
GType dia_shape_text_get_type (void);
GType dia_shape_image_get_type (void);

typedef struct _DiaShape	DiaShape;
typedef struct _DiaShapePath	DiaShapePath;
typedef struct _DiaShapeBezier	DiaShapeBezier;
typedef struct _DiaShapeEllipse DiaShapeEllipse;
typedef struct _DiaShapeText	DiaShapeText;
typedef struct _DiaShapeImage	DiaShapeImage;
typedef struct _DiaShapeClip	DiaShapeClip;

/**
 * DiaShape:
 * 
 * This is a collection of properties that count for all
 * shapes. All shapes are "inherited" from DiaShape.
 **/
struct _DiaShape
{
	DiaShapeType type;

	guint visibility: 4;
	guint update_cnt: 14;
	guint ref_cnt: 14;

	DiaColor color;

	gpointer extra_1;
};

/**
 * DiaShapePath:
 *
 * Path like shapes are lines, polygons, rectangles, etc.
 * If the shape is cyclic, you can set the fill style to
 * DIA_FILL_SOLID and use fill_color to specify a color for the content.
 *
 * Note that one shape can only represent a line, or a surface (e.g.
 * a filled rectangle).
 **/
struct _DiaShapePath
{
	DiaShape shape;
  
	ArtVpath *vpath;
  
	DiaColor  fill_color;

	guint     fill: 8;
	guint     join: 8;
	guint     cap: 8;
	guint     cyclic: 1;
	guint     clipping: 1;

	gdouble   line_width;

	ArtVpathDash dash;
};

/**
 * DiaShapeBezier:
 *
 * Bezier path.
 **/
struct _DiaShapeBezier
{
	DiaShape shape;
  
	ArtBpath *bpath;
  
	DiaColor  fill_color;

	guint     fill: 8;
	guint     join: 8;
	guint     cap: 8;
	guint     cyclic: 1;
	guint     clipping: 1;

	gdouble   line_width;

	ArtVpathDash dash;
};

/**
 * DiaShapeEllipse:
 *
 * Shape for ellipses and circles. This might be extended in the
 * near future to arc (curve) like shapes.
 **/
struct _DiaShapeEllipse
{
	DiaShape shape;
  
	DiaPoint  center;
	gdouble   width, height;
	
	DiaColor  fill_color;

	guint     fill: 8;
	guint     clipping: 1;

	gdouble   line_width;

	ArtVpathDash dash;
};

/**
 * DiaShapeText:
 * 
 * Text is described by a font (font_desc) and a text string.
 * The text can be clipped by setting maximum values for width and 
 * height. The text_width property can be used to determine the width
 * of the text block (text can be word-wrapped at text_width).
 *
 * A special part of a #DiaShapeText object is its cursor position. A
 * #DiaCanvasItem can specify a cursor position in the text. The cursor will
 * only be drawn if the view has the focus and if the object containing the
 * shape has the focus. As a result there will only be one cursor visible
 * in all #DiaCanvasViews.
 **/
struct _DiaShapeText
{
	DiaShape shape;
  
	PangoFontDescription *font_desc;
	gchar *text;

	gboolean need_free;
	gboolean justify;
	gboolean markup;
	DiaWrapMode wrap_mode;
	gdouble line_spacing;
	PangoAlignment alignment;
	gdouble text_width;

	/* Width and height for clipping text. */
	gdouble max_width, max_height;
	gdouble affine[6];

	gint cursor;
};

/**
 * DiaShapeImage:
 *
 * A DiaShapeImage contains an image. The affine matrix can be used
 * to change the offset. Rotating and shearing can result in ugly results.
 **/
struct _DiaShapeImage
{
	DiaShape shape;
  
	GdkPixbuf *pixbuf;

	gdouble affine[6];
};

/**
 * DiaShapeClip: OBSOLETE
 *
 * This shape is not really a shape. It can be set to create a clipping
 * rectangle: all shapes have to be within the clipping rectangle.
 **/
struct _DiaShapeClip
{
	DiaShape shape;
	
	ArtDRect clip;
};


GType dia_shape_get_type (DiaShape *shape);

DiaShape* dia_shape_new (DiaShapeType type);

DiaShape* dia_shape_ref (DiaShape *shape);

void dia_shape_unref (DiaShape *shape);

void dia_shape_free (DiaShape *shape);

void dia_shape_request_update (DiaShape *shape);

/* Generic properties: */
void dia_shape_set_visibility (DiaShape *shape, DiaShapeVisibility vis);
#define   dia_shape_get_visibility(shape) \
		((DiaShapeVisibility) ((shape) ? DIA_SHAPE (shape)->visibility : 0))

void dia_shape_set_color (DiaShape *shape, DiaColor color);

/* Not implemented yet: */
gboolean dia_shape_get_bounds (DiaShape *shape, DiaRectangle *bb);


/* Line like shapes (DIA_SHAPE_PATH) */
#define dia_shape_path_new() dia_shape_new(DIA_SHAPE_PATH)

void dia_shape_line (DiaShape *shape, DiaPoint *start, DiaPoint *end);
void dia_shape_rectangle (DiaShape *shape,
			  DiaPoint *upper_left, DiaPoint *lower_right);
void dia_shape_polyline (DiaShape *shape, guint n_points,
			 DiaPoint *points);
void dia_shape_polygon (DiaShape *shape, guint n_points,
			DiaPoint *points);
/*void dia_shape_arc (DiaShape *shape, DiaPoint *begin,
		    DiaPoint *middle, DiaPoint *end);
*/
/* Path properties: */
void dia_shape_path_set_fill_color (DiaShape *shape, DiaColor fill_color);
void dia_shape_path_set_line_width (DiaShape *shape, gdouble line_width);
void dia_shape_path_set_join (DiaShape *shape, DiaJoinStyle join);
void dia_shape_path_set_cap (DiaShape *shape, DiaCapStyle cap);
void dia_shape_path_set_fill (DiaShape *shape, DiaFillStyle fill);
void dia_shape_path_set_cyclic (DiaShape *shape, gboolean cyclic);
void dia_shape_path_set_clipping (DiaShape *shape, gboolean clipping);
void dia_shape_path_set_dash (DiaShape *shape, gdouble offset, guint n_dash,
			      gdouble *dash);

gboolean dia_shape_path_is_clip_path (DiaShape *shape);

/* Bezier (DIA_SHAPE_BEZIER). n_points should be dividable by 3. */
#define dia_shape_bezier_new() dia_shape_new(DIA_SHAPE_BEZIER)

void dia_shape_bezier (DiaShape *shape, DiaPoint *start,
		       guint n_points, DiaPoint *points);

void dia_shape_bezier_set_fill_color (DiaShape *shape, DiaColor fill_color);
void dia_shape_bezier_set_fill (DiaShape *shape, DiaFillStyle fill);
void dia_shape_bezier_set_line_width (DiaShape *shape, gdouble line_width);
void dia_shape_bezier_set_join (DiaShape *shape, DiaJoinStyle join);
void dia_shape_bezier_set_cap (DiaShape *shape, DiaCapStyle cap);
void dia_shape_bezier_set_cyclic (DiaShape *shape, gboolean cyclic);
void dia_shape_bezier_set_clipping (DiaShape *shape, gboolean clipping);
void dia_shape_bezier_set_dash (DiaShape *shape, gdouble offset, guint n_dash,
			        gdouble *dash);

gboolean dia_shape_bezier_is_clip_path (DiaShape *shape);



/* circle and ellipse (DIA_SHAPE_ELLIPSE) */
#define dia_shape_ellipse_new() dia_shape_new(DIA_SHAPE_ELLIPSE)

void dia_shape_ellipse (DiaShape *shape, DiaPoint *center,
			gdouble width, gdouble height);

/* Ellipse properties: */
void dia_shape_ellipse_set_fill_color (DiaShape *shape, DiaColor fill_color);
void dia_shape_ellipse_set_line_width (DiaShape *shape, gdouble line_width);
void dia_shape_ellipse_set_fill (DiaShape *shape, DiaFillStyle fill);
void dia_shape_ellipse_set_clipping (DiaShape *shape, gboolean clipping);
void dia_shape_ellipse_set_dash (DiaShape *shape, gdouble offset, guint n_dash,
				 gdouble *dash);

gboolean dia_shape_ellipse_is_clip_path (DiaShape *shape);


/* Text (DIA_SHAPE_TEXT) */
#define dia_shape_text_new() dia_shape_new(DIA_SHAPE_TEXT)

void dia_shape_text (DiaShape *shape, PangoFontDescription *font_desc,
		     const gchar *text);

/* Text properties: */
void dia_shape_text_set_font_description (DiaShape *shape,
					  PangoFontDescription *font_desc);
void dia_shape_text_set_text (DiaShape *shape, const gchar *text);
void dia_shape_text_set_static_text (DiaShape *shape, const gchar *text);

/* You should avoid shearing and rotating, since renderers can not handle
 * them. */
void dia_shape_text_set_affine (DiaShape *shape, gdouble affine[6]);
void dia_shape_text_set_pos (DiaShape *shape, DiaPoint *pos);
void dia_shape_text_set_text_width (DiaShape *shape, gdouble width);
void dia_shape_text_set_line_spacing (DiaShape *shape, gdouble line_spacing);
void dia_shape_text_set_max_width (DiaShape *shape, gdouble width);
void dia_shape_text_set_max_height (DiaShape *shape, gdouble height);

void dia_shape_text_set_justify (DiaShape *shape, gboolean justify);
void dia_shape_text_set_markup (DiaShape *shape, gboolean markup);
void dia_shape_text_set_wrap_mode (DiaShape *shape, DiaWrapMode wrap_mode);
void dia_shape_text_set_alignment (DiaShape *shape, PangoAlignment alignment);

/* Note that the layout does not worry about the max_width, max_height and
 * affine attributes. */
PangoLayout* dia_shape_text_to_pango_layout (DiaShape *shape, gboolean fill);

void dia_shape_text_fill_pango_layout (DiaShape *shape, PangoLayout *layout);

/* Cursor positions from text... */
gboolean dia_shape_text_cursor_from_pos (DiaShape *shape, DiaPoint *pos,
					 gint *cursor);

/* Image (DIA_SHAPE_IMAGE) */
#define dia_shape_image_new() dia_shape_new(DIA_SHAPE_IMAGE)

void dia_shape_image (DiaShape *shape, GdkPixbuf *image);

/* You should avoid shearing and rotating, since renderers can not handle
 * them. */
void dia_shape_image_set_affine (DiaShape *shape, gdouble affine[6]);
/* For convenience... */
void dia_shape_image_set_pos (DiaShape *shape, DiaPoint *pos);

/* Clipping rectangle (DIA_SHAPE_CLIP) */
#define dia_shape_clip_new() dia_shape_new(DIA_SHAPE_CLIP)

void dia_shape_clip (DiaShape *shape, gdouble left, gdouble top,
		     gdouble right, gdouble bottom);

/*< Private >
 *
 * This stuff is used by the Views:
 */

gboolean dia_shape_need_update (DiaShape *shape);
void dia_shape_is_updated (DiaShape *shape);


G_END_DECLS

#endif /* __DIA_SHAPE_H__ */
