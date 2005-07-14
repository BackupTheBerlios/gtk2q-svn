/* dia-undo_manager.h
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

#ifndef __DIA_UNDO_MANAGER_H__
#define __DIA_UNDO_MANAGER_H__

#include <glib-object.h>

G_BEGIN_DECLS

#define DIA_TYPE_UNDO_MANAGER	(dia_undo_manager_get_type ())
#define DIA_UNDO_MANAGER(obj)	(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_UNDO_MANAGER, DiaUndoManager))
#define DIA_IS_UNDO_MANAGER(obj)	(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_UNDO_MANAGER))
#define DIA_UNDO_MANAGER_GET_IFACE(obj)  (G_TYPE_INSTANCE_GET_INTERFACE ((obj), DIA_TYPE_UNDO_MANAGER, DiaUndoManagerIface))

typedef struct _DiaUndoAction		DiaUndoAction;

typedef struct _DiaUndoManager		DiaUndoManager; /* Dummy typedef */
typedef struct _DiaUndoManagerIface	DiaUndoManagerIface;

typedef void  (*DiaUndoFunc)	(DiaUndoAction *action);
				 
#define DIA_TYPE_UNDO_ACTION dia_undo_action_get_type()

struct _DiaUndoAction
{
	DiaUndoFunc	undo;
	DiaUndoFunc	redo;
	GDestroyNotify	destroy;
};

GType	dia_undo_action_get_type		(void);

DiaUndoAction* dia_undo_action_new	(gsize sizeof_undo_action,
					 DiaUndoFunc undo,
					 DiaUndoFunc redo,
					 GDestroyNotify destroy);

void	dia_undo_action_undo		(DiaUndoAction *action);
void	dia_undo_action_redo		(DiaUndoAction *action);
void	dia_undo_action_destroy		(DiaUndoAction *action);

/**
 * DiaUndoManager:
 *
 * This interface provides the functions that are used to gather and act
 * on undo information.
 *
 * 
 **/
struct _DiaUndoManagerIface
{
	GTypeInterface g_iface;

	gboolean (* in_transaction)	(DiaUndoManager *undo_manager);
	gboolean (* can_undo)		(DiaUndoManager *undo_manager);
	gboolean (* can_redo)		(DiaUndoManager *undo_manager);

	/*
	 * Signals
	 */

	void	(* begin_transaction)	(DiaUndoManager *undo_manager);

	void	(* commit_transaction)	(DiaUndoManager *undo_manager);
	void	(* discard_transaction) (DiaUndoManager *undo_manager);

	void	(* add_undo_action)	(DiaUndoManager *undo_manager,
					 DiaUndoAction *action);

	void	(* undo_transaction)	(DiaUndoManager *undo_manager);
	void	(* redo_transaction)	(DiaUndoManager *undo_manager);
};

GType	dia_undo_manager_get_type		(void);

/* Begin a transaction. @comment is not freed when a transaction is 
 * terminated.
 * FixMe: Should comment be a GValue or something?
 */
void	dia_undo_manager_begin_transaction	(DiaUndoManager *undo_manager);

/* Save the transaction on the undo stack */
void	dia_undo_manager_commit_transaction	(DiaUndoManager *undo_manager);

/* Discard the transaction on the undo stack */
void	dia_undo_manager_discard_transaction	(DiaUndoManager *undo_manager);

void	dia_undo_manager_undo_transaction	(DiaUndoManager *undo_manager);
void	dia_undo_manager_redo_transaction	(DiaUndoManager *undo_manager);

gboolean dia_undo_manager_in_transaction	(DiaUndoManager *undo_manager);
gboolean dia_undo_manager_can_undo		(DiaUndoManager *undo_manager);
gboolean dia_undo_manager_can_redo	 	(DiaUndoManager *undo_manager);

void	dia_undo_manager_add_undo_action	(DiaUndoManager *undo_manager,
						 DiaUndoAction *action);

G_END_DECLS

#endif /* __DIA_UNDO_MANAGER_H__ */

