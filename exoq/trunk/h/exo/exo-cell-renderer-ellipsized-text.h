/* $Id: exo-cell-renderer-ellipsized-text.h 18995 2005-12-05 16:46:54Z benny $ */
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

#ifndef __EXO_CELL_RENDERER_ELLIPSIZED_TEXT_H__
#define __EXO_CELL_RENDERER_ELLIPSIZED_TEXT_H__

#include <gtk/gtk.h>

G_BEGIN_DECLS;

#define EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT            (exo_cell_renderer_ellipsized_text_get_type ())
#define EXO_CELL_RENDERER_ELLIPSIZED_TEXT(obj)            (G_TYPE_CHECK_INSTANCE_CAST ((obj), EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT, ExoCellRendererEllipsizedText))
#define EXO_CELL_RENDERER_ELLIPSIZED_TEXT_CLASS(klass)    (G_TYPE_CHECK_CLASS_CAST ((obj), EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT, ExoCellRendererEllipsizedTextClass))
#define EXO_IS_CELL_RENDERER_ELLIPSIZED_TEXT(obj)         (G_TYPE_CHECK_INSTANCE_TYPE ((obj), EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT))
#define EXO_IS_CELL_RENDERER_ELLIPSIZED_TEXT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((obj), EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT))
#define EXO_CELL_RENDERER_ELLIPSIZED_TEXT_GET_CLASS(obj)  (G_TYPE_INSTANCE_GET_CLASS ((obj), EXO_TYPE_CELL_RENDERER_ELLIPSIZED_TEXT, ExoCellRendererEllipsizedTextClass))

typedef struct _ExoCellRendererEllipsizedText        ExoCellRendererEllipsizedText;
typedef struct _ExoCellRendererEllipsizedTextClass   ExoCellRendererEllipsizedTextClass;
typedef struct _ExoCellRendererEllipsizedTextPrivate ExoCellRendererEllipsizedTextPrivate;

struct _ExoCellRendererEllipsizedTextClass
{
  GtkCellRendererTextClass __parent__;
};

struct _ExoCellRendererEllipsizedText
{
  GtkCellRendererText __parent__;

  /*< private >*/
  ExoCellRendererEllipsizedTextPrivate *priv;
};

GType            exo_cell_renderer_ellipsized_text_get_type (void) G_GNUC_CONST;
GtkCellRenderer *exo_cell_renderer_ellipsized_text_new      (void);

G_END_DECLS;

#endif /* !__EXO_CELL_RENDERER_ELLIPSIZED_TEXT_H__ */
