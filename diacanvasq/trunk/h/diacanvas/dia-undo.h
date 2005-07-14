/* dia-undo.h
 * Copyright (C) 2004  Arjan Molenaar
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

#ifndef __DIA_UNDO_H__
#define __DIA_UNDO_H__

#include <glib-object.h>
#include <diacanvas/dia-undo-manager.h>

G_BEGIN_DECLS


#define DIA_TYPE_UNDO		(dia_undo_get_type ())
#define DIA_UNDO(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_UNDO, DiaUndo))
#define DIA_UNDO_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_UNDO, DiaUndoClass))
#define DIA_IS_UNDO(obj)	(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_UNDO))
#define DIA_IS_UNDO_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_UNDO))
#define DIA_UNDO_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_UNDO, DiaUndoClass))


typedef struct _DiaUndo DiaUndo;
typedef struct _DiaUndoClass DiaUndoClass;

/**
 * DiaUndo:
 *
 * Default undo/redo implementation.
 *
 * This class implements the DiaUndoManager interface.
 **/
struct _DiaUndo {
	GObject object;

	gpointer _priv;
};

struct _DiaUndoClass {
	GObjectClass parent_class;

};


GType	dia_undo_get_type (void);

void	dia_undo_clear_undo_stack	(DiaUndo *undo);
guint	dia_undo_get_depth		(DiaUndo *undo);

/* Redo last undo change: */
void	dia_undo_clear_redo_stack	(DiaUndo *undo);
guint	dia_undo_get_redo_depth		(DiaUndo *undo);

void	dia_undo_set_max_depth		(DiaUndo *undo, guint depth);
guint	dia_undo_get_max_depth		(DiaUndo *undo);


/* Visit all values that are in the undo stack, this is quite useful
 * for garbage collectors.
 */
//typedef void DiaTraverseValuesFunc (GValue *value, gpointer data);

//void	dia_undo_traverse_values	(DiaUndo *undo,
//					 DiaValueTraverseFunc traverse_func,
//					 gpointer data);

G_END_DECLS

#endif /* __DIA_UNDO_H__ */
